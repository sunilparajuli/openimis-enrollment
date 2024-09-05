import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'policy_database.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE policies(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        headInsureeChfid TEXT,
        receiptNo TEXT,
        noOfFamily INTEGER,
        amount INTEGER,
        enrolledDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE enrollments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT,
        birthdate TEXT,
        chfid TEXT,
        eaCode TEXT,
        email TEXT,
        gender TEXT,
        givenName TEXT,
        identificationNo TEXT,
        isHead INTEGER,
        lastName TEXT,
        maritalStatus TEXT,
        headChfid TEXT,
        newEnrollment INTEGER,
        photo TEXT,
        remarks TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE enrollments(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          phone TEXT,
          birthdate TEXT,
          chfid TEXT,
          eaCode TEXT,
          email TEXT,
          gender TEXT,
          givenName TEXT,
          identificationNo TEXT,
          isHead INTEGER,
          lastName TEXT,
          maritalStatus TEXT,
          headChfid TEXT,
          newEnrollment INTEGER,
          photo TEXT,
          remarks TEXT
        )
      ''');
    }
  }

  Future<int> insertPolicy(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('policies', row);
  }

  Future<int> insertEnrollment(Map<String, dynamic> row) async {
    final db = await database;
    try {
      return await db.insert('enrollments', row);
    } catch (e) {
      print('Error inserting into enrollments: $e');
      return -1; // return -1 to indicate failure
    }
  }

  Future<List<Map<String, dynamic>>> queryAllPolicies() async {
    final db = await database;
    return await db.query('policies');
  }

  Future<List<Map<String, dynamic>>> queryAllEnrollments() async {
    final db = await database;
    return await db.query('enrollments');
  }

  Future<int> deleteEnrollment(int id) async {
    final db = await database;
    return await db.delete('enrollments', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> queryEnrollmentByChfid(String chfid) async {
    final db = await database;
    final result = await db.query(
      'enrollments',
      where: 'chfid = ?',
      whereArgs: [chfid],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<void> updateEnrollment(Map<String, dynamic> enrollment) async {
    final db = await database;
    await db.update(
      'enrollments',
      enrollment,
      where: 'chfid = ?', // Use `chfid` to identify the enrollment
      whereArgs: [enrollment['id']],
    );
  }
}
