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
      version: 3,
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

    await db.execute('''
      CREATE TABLE personal_records (
        key TEXT PRIMARY KEY,
        value REAL NOT NULL,
        timestamp INTEGER NOT NULL,
        detail TEXT DEFAULT ''
      )
    ''');

    await db.execute('''
      CREATE TABLE unlocked_milestones (
        id TEXT PRIMARY KEY,
        unlockedAt INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE growth_timeline_points (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dateStr TEXT NOT NULL UNIQUE,
        disciplineScore REAL NOT NULL,
        reliabilityScore REAL NOT NULL,
        levelNumber INTEGER NOT NULL,
        promisesKept INTEGER NOT NULL,
        timestamp INTEGER NOT NULL
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

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS personal_records (
          key TEXT PRIMARY KEY,
          value REAL NOT NULL,
          timestamp INTEGER NOT NULL,
          detail TEXT DEFAULT ''
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS unlocked_milestones (
          id TEXT PRIMARY KEY,
          unlockedAt INTEGER NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS growth_timeline_points (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          dateStr TEXT NOT NULL UNIQUE,
          disciplineScore REAL NOT NULL,
          reliabilityScore REAL NOT NULL,
          levelNumber INTEGER NOT NULL,
          promisesKept INTEGER NOT NULL,
          timestamp INTEGER NOT NULL
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
    final result = await db.query('tasks', where: 'plannedDate = ?', whereArgs: [date], orderBy: 'hour ASC, minute ASC');
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

  // ==================== DAILY REFLECTIONS ====================

  Future<int> upsertReflection(DailyReflection ref) async {
    final db = await database;
    return await db.insert('daily_reflections', ref.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
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

  Future<int> getReflectionsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM daily_reflections');
    return Sqflite.firstIntValue(result) ?? 0;
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

  // ==================== PERSONAL RECORDS ====================

  Future<List<Map<String, dynamic>>> getPersonalRecords() async {
    final db = await database;
    return await db.query('personal_records');
  }

  Future<void> savePersonalRecord(String key, double value, String detail) async {
    final db = await database;
    await db.insert(
      'personal_records',
      {
        'key': key,
        'value': value,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'detail': detail,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ==================== UNLOCKED MILESTONES ====================

  Future<List<String>> getUnlockedMilestones() async {
    final db = await database;
    final result = await db.query('unlocked_milestones');
    return result.map((m) => m['id'] as String).toList();
  }

  Future<void> unlockMilestone(String id) async {
    final db = await database;
    await db.insert(
      'unlocked_milestones',
      {
        'id': id,
        'unlockedAt': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // ==================== GROWTH TIMELINE POINTS ====================

  Future<List<Map<String, dynamic>>> getGrowthTimelinePoints() async {
    final db = await database;
    return await db.query('growth_timeline_points', orderBy: 'timestamp ASC');
  }

  Future<void> saveGrowthTimelinePoint(String dateStr, double disciplineScore, double reliabilityScore, int levelNumber, int promisesKept) async {
    final db = await database;
    await db.insert(
      'growth_timeline_points',
      {
        'dateStr': dateStr,
        'disciplineScore': disciplineScore,
        'reliabilityScore': reliabilityScore,
        'levelNumber': levelNumber,
        'promisesKept': promisesKept,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
