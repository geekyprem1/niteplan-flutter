import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'task_model.dart';
import 'daily_reflection_model.dart';
import 'discipline_score_model.dart';
import 'future_self_letter_model.dart';

class NitePlanDatabase {
  static final NitePlanDatabase instance = NitePlanDatabase._init();
  static Database? _database;

  NitePlanDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('niteplan_v2.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT DEFAULT '',
        lifeArea TEXT DEFAULT 'general',
        hour INTEGER NOT NULL,
        minute INTEGER NOT NULL,
        durationMinutes INTEGER NOT NULL,
        plannedDate TEXT DEFAULT '',
        createdAt INTEGER NOT NULL,
        status TEXT DEFAULT 'PENDING',
        failureCategory TEXT DEFAULT '',
        reason TEXT DEFAULT '',
        completedAt INTEGER DEFAULT 0,
        actualDurationMinutes INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_reflections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        wentWell TEXT DEFAULT '',
        whatFailed TEXT DEFAULT '',
        whyItFailed TEXT DEFAULT '',
        tomorrowImprovement TEXT DEFAULT '',
        mood INTEGER DEFAULT 3,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE discipline_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        executionScore REAL DEFAULT 0,
        consistencyScore REAL DEFAULT 0,
        planningScore REAL DEFAULT 0,
        reflectionScore REAL DEFAULT 0,
        totalScore REAL DEFAULT 0,
        createdAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE future_self_letters (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        writtenAt INTEGER NOT NULL,
        unlockDays INTEGER NOT NULL,
        unlockAt INTEGER NOT NULL,
        isUnlocked INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migrate old tasks table if exists
      try {
        await db.execute("ALTER TABLE tasks ADD COLUMN lifeArea TEXT DEFAULT 'general'");
        await db.execute("ALTER TABLE tasks ADD COLUMN plannedDate TEXT DEFAULT ''");
        await db.execute("ALTER TABLE tasks ADD COLUMN failureCategory TEXT DEFAULT ''");
        await db.execute("ALTER TABLE tasks ADD COLUMN actualDurationMinutes INTEGER DEFAULT 0");
      } catch (_) {}

      await db.execute('''
        CREATE TABLE IF NOT EXISTS daily_reflections (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          wentWell TEXT DEFAULT '',
          whatFailed TEXT DEFAULT '',
          whyItFailed TEXT DEFAULT '',
          tomorrowImprovement TEXT DEFAULT '',
          mood INTEGER DEFAULT 3,
          createdAt INTEGER NOT NULL,
          updatedAt INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS discipline_scores (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT NOT NULL UNIQUE,
          executionScore REAL DEFAULT 0,
          consistencyScore REAL DEFAULT 0,
          planningScore REAL DEFAULT 0,
          reflectionScore REAL DEFAULT 0,
          totalScore REAL DEFAULT 0,
          createdAt INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS future_self_letters (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          content TEXT NOT NULL,
          writtenAt INTEGER NOT NULL,
          unlockDays INTEGER NOT NULL,
          unlockAt INTEGER NOT NULL,
          isUnlocked INTEGER DEFAULT 0
        )
      ''');
    }
  }

  // ==================== TASKS ====================

  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'createdAt DESC');
    return result.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> getTasksByDate(String date) async {
    final db = await database;
    final result = await db.query('tasks', where: 'plannedDate = ?', whereArgs: [date]);
    return result.map((m) => Task.fromMap(m)).toList();
  }

  Future<List<Task>> getTasksInRange(String startDate, String endDate) async {
    final db = await database;
    final result = await db.query(
      'tasks',
      where: 'plannedDate >= ? AND plannedDate <= ?',
      whereArgs: [startDate, endDate],
      orderBy: 'plannedDate ASC',
    );
    return result.map((m) => Task.fromMap(m)).toList();
  }

  // ==================== REFLECTIONS ====================

  Future<int> upsertReflection(DailyReflection reflection) async {
    final db = await database;
    final existing = await db.query('daily_reflections',
        where: 'date = ?', whereArgs: [reflection.date]);
    if (existing.isEmpty) {
      return await db.insert('daily_reflections', reflection.toMap());
    } else {
      return await db.update(
        'daily_reflections',
        reflection.copyWith(updatedAt: DateTime.now().millisecondsSinceEpoch).toMap(),
        where: 'date = ?',
        whereArgs: [reflection.date],
      );
    }
  }

  Future<DailyReflection?> getReflectionByDate(String date) async {
    final db = await database;
    final result = await db.query('daily_reflections',
        where: 'date = ?', whereArgs: [date]);
    if (result.isEmpty) return null;
    return DailyReflection.fromMap(result.first);
  }

  Future<List<DailyReflection>> getReflectionsInRange(
      String startDate, String endDate) async {
    final db = await database;
    final result = await db.query(
      'daily_reflections',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date DESC',
    );
    return result.map((m) => DailyReflection.fromMap(m)).toList();
  }

  // ==================== DISCIPLINE SCORES ====================

  Future<void> upsertScore(DisciplineScore score) async {
    final db = await database;
    await db.insert('discipline_scores', score.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DisciplineScore>> getScoresInRange(
      String startDate, String endDate) async {
    final db = await database;
    final result = await db.query(
      'discipline_scores',
      where: 'date >= ? AND date <= ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date ASC',
    );
    return result.map((m) => DisciplineScore.fromMap(m)).toList();
  }

  Future<DisciplineScore?> getLatestScore() async {
    final db = await database;
    final result = await db.query('discipline_scores',
        orderBy: 'date DESC', limit: 1);
    if (result.isEmpty) return null;
    return DisciplineScore.fromMap(result.first);
  }

  // ==================== FUTURE SELF LETTERS ====================

  Future<int> insertLetter(FutureSelfLetter letter) async {
    final db = await database;
    return await db.insert('future_self_letters', letter.toMap());
  }

  Future<void> updateLetter(FutureSelfLetter letter) async {
    final db = await database;
    await db.update('future_self_letters', letter.toMap(),
        where: 'id = ?', whereArgs: [letter.id]);
  }

  Future<int> deleteLetter(int id) async {
    final db = await database;
    return await db.delete('future_self_letters', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FutureSelfLetter>> getAllLetters() async {
    final db = await database;
    final result =
        await db.query('future_self_letters', orderBy: 'writtenAt DESC');
    return result.map((m) => FutureSelfLetter.fromMap(m)).toList();
  }
}
