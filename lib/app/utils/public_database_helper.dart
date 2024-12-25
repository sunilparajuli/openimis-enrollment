import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class PublicDatabaseHelper {
  static final PublicDatabaseHelper _instance = PublicDatabaseHelper._internal();
  factory PublicDatabaseHelper() => _instance;

  static Database? _database;

  PublicDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'public_enrollment.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE family (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        json_content TEXT NOT NULL, -- Serialized JSON for family details
        photo TEXT,                 -- Base64 encoded family photo
        sync INTEGER DEFAULT 0      -- Sync status (0 = unsynced, 1 = synced)
      );
    ''');
    await db.execute('''
      CREATE TABLE members (
        family_id INTEGER NULL,
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chfid TEXT NOT NULL UNIQUE, -- Unique identifier for each member
        name TEXT NOT NULL,         -- Full name
        isHead INTEGER DEFAULT 0,   -- 1 for head, 0 for others
        json_content TEXT,          -- Serialized JSON for member details
        photo TEXT,                 -- Base64 encoded photo
        sync INTEGER DEFAULT 0      -- Sync status (0 = unsynced, 1 = synced)
      );
    ''');
  }

  Future<void> insertMember({
    required String chfid,
    required String name,
    required int isHead,
    required Map<String, dynamic> memberDetails,
    String? photo,
  }) async {
    final db = await database;

    // Ensure only one head exists
    if (isHead == 1) {
      await db.update('members', {'isHead': 0}); // Reset all existing heads
    }

    String memberJsonContent = jsonEncode(memberDetails);

    await db.insert('members', {
      'chfid': chfid,
      'name': name,
      'isHead': isHead,
      'json_content': memberJsonContent,
      'photo': photo ?? "",
      'sync': 0,
    });
  }

  Future<void> insertFamily({
    required Map<String, dynamic> familyDetails,
    String? photo,
  }) async {
    final db = await database;

    String familyJsonContent = jsonEncode(familyDetails);

    await db.insert('family', {
      'json_content': familyJsonContent,
      'photo': photo ?? "",
      'sync': 0,
    });
  }

  Future<Map<String, dynamic>?> retrieveFamily() async {
    final db = await database;

    // Query to fetch the first row from the 'family' table
    final List<Map<String, dynamic>> result = await db.query(
      'family',
      limit: 1, // Ensures only one row is fetched
    );

    // Return the first row if it exists, otherwise return null
    return result.isNotEmpty ? result.first : null;
  }


  Future<void> updateMember({
    required int id,
    required String name,
    required int isHead,
    required Map<String, dynamic> memberDetails,
    String? photo,
  }) async {
    final db = await database;

    // Ensure only one head exists
    if (isHead == 1) {
      await db.update('members', {'isHead': 0}); // Reset all existing heads
    }

    String memberJsonContent = jsonEncode(memberDetails);

    await db.update(
      'members',
      {
        'name': name,
        'isHead': isHead,
        'json_content': memberJsonContent,
        'photo': photo ?? "",
        'sync': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> retrieveAllMembers() async {
    final db = await database;
    return await db.query('members');
  }

  Future<Map<String, dynamic>?> retrieveHeadMember() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'members',
      where: 'isHead = ?',
      whereArgs: [1],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> deleteMember(int id) async {
    final db = await database;
    return await db.delete('members', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateSyncStatus(String chfid) async {
    final db = await database;
    await db.update(
      'members',
      {'sync': 1},
      where: 'chfid = ?',
      whereArgs: [chfid],
    );
  }

  Future<bool> hasRecords() async {
    final db = await database;
    final memberCount = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM members'));
    return (memberCount ?? 0) > 0;
  }

  Future<void> deleteAllData() async {
    final db = await database;

    // Delete all rows from the 'family' table
    await db.delete('family');

    // Delete all rows from the 'members' table
    await db.delete('members');
  }


}
