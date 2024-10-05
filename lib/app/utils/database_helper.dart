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
    String path = join(await getDatabasesPath(), 'enrollment.db');
    return await openDatabase(
      path,
      version: 2, // Increment the version to trigger the onUpgrade
      onCreate: (db, version) async {
        await _createTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _migrateToVersion2(db);
        }
      },
    );
  }

  Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE enrollments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        photo TEXT,
        chfid TEXT,
        json_content TEXT,
        sync INTEGER
      )
    ''');
  }

  Future<void> _migrateToVersion2(Database db) async {
    // Rename the old table
    await db.execute('ALTER TABLE enrollments RENAME TO enrollments_old;');

    // Create the new table with the updated schema
    await _createTable(db);

    // Copy data from old table to new table
    await db.execute('''
      INSERT INTO enrollments (id, chfid, json_content, sync)
      SELECT id, chfid, json_content, sync FROM enrollments_old;
    ''');

    // Drop the old table
    await db.execute('DROP TABLE enrollments_old;');
  }

  Future<void> insertEnrollment(Map<String, dynamic> enrollmentData) async {
    final db = await database;

    // Create the family object
    Map<String, dynamic> familyData = {
      'familyType': enrollmentData['familyType'] ?? '',
      'confirmationType': enrollmentData['confirmationType'] ?? ''
    };

    // Create the members array
    List<Map<String, dynamic>> membersData = [
      {
        'phone': enrollmentData['phone'] ?? '',
        'birthdate': enrollmentData['birthdate'] ?? '',
        'chfid': enrollmentData['chfid'] ?? '',
        'eaCode': enrollmentData['eaCode'] ?? '',
        'email': enrollmentData['email'] ?? '',
        'gender': enrollmentData['gender'] ?? '',
        'givenName': enrollmentData['givenName'] ?? '',
        'identificationNo': enrollmentData['identificationNo'] ?? '',
        'isHead': enrollmentData['isHead'] ?? 0,
        'lastName': enrollmentData['lastName'] ?? '',
        'maritalStatus': enrollmentData['maritalStatus'] ?? '',
        'headChfid': enrollmentData['headChfid'] ?? '',
        'newEnrollment': enrollmentData['newEnrollment'] ?? 0,
        'photo': enrollmentData['photo'] ?? '',
        'remarks': enrollmentData['remarks'] ?? '',
        'healthFacilityLevel': enrollmentData['healthFacilityLevel'] ?? '',
        'healthFacility': enrollmentData['healthFacility'] ?? '',
        'relationShip': enrollmentData['relationShip'] ?? ''
      }
    ];

    // Combine family and members into a single data structure
    Map<String, dynamic> structuredData = {
      'family': familyData,
      'members': membersData
    };

    // Convert structured data to JSON string
    String jsonContent = jsonEncode(structuredData);

    // Prepare data for insertion into the database
    Map<String, dynamic> row = {
      'chfid': enrollmentData['chfid'],
      'photo': enrollmentData['photo'],
      'json_content': jsonContent,
      'sync': 0 // Assuming false for initial save
    };

    await db.insert('enrollments', row);
  }

  Future<List<Map<String, dynamic>>> retrieveAllEnrollments() async {
    final db = await database;
    // Fetch all records from the enrollments table
    List<Map<String, dynamic>> result = await db.query('enrollments');
    print(result);

    return result;
  }

  Future<int> deleteEnrollment(int id) async {
    final db = await database;
    return await db.delete('enrollments', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getEnrollmentById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'enrollments',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null; // Return null if no record is found
    }
  }
}


