import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'family_enrollment.db');
    return await openDatabase(
      path,
      version: 4, // Update version to trigger migrations
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _migrateToVersion2(db);
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Create family table
    await db.execute('''
      CREATE TABLE family (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chfid TEXT NOT NULL UNIQUE,
        json_content TEXT,
        photo TEXT,
        sync INTEGER DEFAULT 0
      )
    ''');

    // Create members table
    await db.execute('''
      CREATE TABLE members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chfid TEXT NOT NULL UNIQUE,  -- Each member has a unique CHFID
        name TEXT NOT NULL,
        head INTEGER DEFAULT 0,      -- 1 for head, 0 for other members
        json_content TEXT,
        photo TEXT,
        sync INTEGER DEFAULT 0,
        family_id INTEGER,           -- Foreign key to link to the family
        FOREIGN KEY(family_id) REFERENCES family(id) ON DELETE CASCADE
      );
    ''');
  }

  Future<void> _migrateToVersion2(Database db) async {
    // Example migration steps if needed for version upgrade
  }

  // Insert family and head member
  Future<void> insertFamilyAndHeadMember(
      String chfid, Map<String, dynamic> familyDetails, String headName, String photoPath) async {
    final db = await database;

    // Family data
    String familyJsonContent = jsonEncode(familyDetails);

    await db.transaction((txn) async {
      // Insert into family table
      await txn.insert('family', {
        'chfid': chfid,
        'json_content': familyJsonContent,
        'photo': photoPath,
        'sync': 0
      });

      // Insert head member into members table
      await txn.insert('members', {
        'chfid': chfid,
        'name': headName,
        'head': 1,
        'json_content': familyJsonContent,
        'photo': photoPath,
        'sync': 0
      });
    });
  }

  // Insert additional family members
  Future<void> insertFamilyMember(
      String chfid, String memberName, Map<String, dynamic> memberDetails, String photoPath) async {
    final db = await database;

    String memberJsonContent = jsonEncode(memberDetails);

    await db.insert('members', {
      'chfid': chfid,
      'name': memberName,
      'head': 0,
      'json_content': memberJsonContent,
      'photo': photoPath,
      'sync': 0
    });
  }

  // Retrieve all family records
  Future<List<Map<String, dynamic>>> retrieveAllFamilies() async {
    final db = await database;
    return await db.query('family');
  }

  // Retrieve members for a specific family by chfid
  Future<List<Map<String, dynamic>>> retrieveFamilyMembers(String chfid) async {
    final db = await database;
    return await db.query('members', where: 'chfid = ?', whereArgs: [chfid]);
  }


  Future<List<Map<String, dynamic>>> getAllFamiliesWithMembers() async {
    final db = await database;

    // Query all families
    final List<Map<String, dynamic>> families = await db.query('family');

    List<Map<String, dynamic>> allData = [];

    for (var family in families) {
      // Get the family members associated with this family
      final List<Map<String, dynamic>> members = await db.query(
        'members',
        where: 'chfid = ?',
        whereArgs: [family['chfid']],
      );

      // Add family and its members to the result
      allData.add({
        'family': family,
        'members': members,
      });
    }

    return allData;
  }


  Future<Map<String, dynamic>?> getFamilyAndMembers(int familyId) async {
    final db = await database; // Access the database instance

    // Retrieve family data by family id
    final List<Map<String, dynamic>> familyResult = await db.query(
      'family', // Query the 'family' table
      where: 'id = ?', // Query by 'id'
      whereArgs: [familyId],
    );

    if (familyResult.isEmpty) {
      // If no family found, return null
      return null;
    }

    // Retrieve chfid from familyResult
    //final String chfid = familyResult.first['chfid'];

    // Retrieve members related to the family using the chfid
    final List<Map<String, dynamic>> membersResult = await db.query(
      'members', // Query the 'members' table
      where: 'family_id = ?', // Use chfid to get related members
      whereArgs: [familyId],
    );

    // Prepare the result with family and members
    Map<String, dynamic> result = {
      'family': familyResult.first, // There should only be one family per id
      'members': membersResult, // List of members related to the family
    };

    return result;
  }



  // Retrieve a specific enrollment (family) by ID
  Future<Map<String, dynamic>?> getFamilyById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('family', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  // Retrieve a specific family member by ID
  Future<Map<String, dynamic>?> getMemberById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('members', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  // Delete a family and its members by chfid
  Future<int> deleteFamily(int familyid) async {
    final db = await database;
    // SQLite foreign key constraint will handle members deletion
    return await db.delete('family', where: 'id = ?', whereArgs: [familyid]);

  }

  // Delete a member by ID
  Future<int> deleteMember(int id) async {
    final db = await database;
    return await db.delete('members', where: 'id = ?', whereArgs: [id]);
  }

  // Update sync status for a family and its members
  Future<void> updateSyncStatus(String chfid) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update('family', {'sync': 1}, where: 'chfid = ?', whereArgs: [chfid]);
      await txn.update('members', {'sync': 1}, where: 'chfid = ?', whereArgs: [chfid]);
    });
  }
}
