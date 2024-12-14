
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';



class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  Database? _db;

  // Private constructor for the singleton
  DatabaseHelper._internal();
  // Factory to return the same instance
  factory DatabaseHelper() => _instance;


  // Method to initialize the database
  Future<void> initDatabase(String dbName) async {

    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String dbPath = '${documentsDirectory.path}/$dbName';

    _db = sqlite3.open(dbPath); // Initialize the SQLite database

  }


  Future<void> tryCreateTaskTable() async {
    // Check if the table exists
    final tableExists = db.select('''
      SELECT name 
      FROM sqlite_master 
      WHERE type='table' AND name='tasks';
    ''');

    // If the table exists, return early
    if (tableExists.isNotEmpty) return;
    

    // Create the table if it doesn't exist
    db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each task
        name TEXT NOT NULL, -- Task description, required
        point_reward INTEGER DEFAULT 0, -- Reward points, default 0
        remind_date DATETIME, -- Reminder date and time (can be NULL)
        due_date DATETIME, -- Due date (optional)
        is_recurring BOOLEAN DEFAULT FALSE, -- Whether the task is recurring, default FALSE
        done BOOLEAN DEFAULT FALSE -- Whether the task is completed, default FALSE
      );
    ''');
  }


  void tryCreatePointTableSync() async {

    final tableExists = db.select('''
      SELECT name 
      FROM sqlite_master 
      WHERE type='table' AND name='points';
    ''');

    if (tableExists.isNotEmpty) {
      return;
    }

    db.execute('''
      CREATE TABLE IF NOT EXISTS points (
          points INTEGER
      );
    ''');
    db.execute('''
      INSERT INTO points (points)
      VALUES (0)
    ''');
  }

  void tryCreatePointTransactionTableSync() async {
    // Check if the table exists
    final tableExists = db.select('''
      SELECT name 
      FROM sqlite_master 
      WHERE type='table' AND name='points_transactions';
    ''');

    // If the table exists, return early
    if (tableExists.isNotEmpty) {
      return;
    }

    // Create the table if it doesn't exist
    db.execute('''
      CREATE TABLE IF NOT EXISTS points_transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT, -- Identifiant unique pour chaque transaction
          task_id INTEGER NOT NULL, -- Référence à la tâche associée
          points INTEGER NOT NULL, -- Nombre de points (positif ou négatif)
          date_obtained DATETIME DEFAULT CURRENT_TIMESTAMP, -- Date et heure de la transaction
          FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE -- Relation avec la table tasks
      );
    ''');
  }

  


  Future<void> tryCreateRecurringTasksTable() async {
    // Check if the table exists
    final tableExists = db.select('''
      SELECT name 
      FROM sqlite_master 
      WHERE type='table' AND name='recurring_tasks';
    ''');

    // If the table exists, return early
    if (tableExists.isNotEmpty) {
      return;
    }

    // Create the table if it doesn't exist
    db.execute('''
      CREATE TABLE recurring_tasks (
        id INTEGER PRIMARY KEY,
        re_enable_time TEXT,
        times_completed INTEGER DEFAULT 0,
        FOREIGN KEY (id) REFERENCES tasks (id) ON DELETE CASCADE
      );
    ''');
  }


  Future<void> addTask(String taskName, int pointReward, String remindDate, String dueDate, bool isRecuring, bool isDone) async {
    db.execute('''
      INSERT INTO tasks (name, point_reward, remind_date, due_date, is_recurring, done)
      VALUES ('$taskName', $pointReward, '$remindDate', '$dueDate', $isRecuring, $isDone)
    ''');
  }

  void addPoint(int pointToAdd) {
    db.execute('''
      UPDATE points
      SET points = points + $pointToAdd;
    ''');
  }


  void addTaskSyncro(String taskName, int pointReward, String remindDate, String dueDate, bool isRecuring, bool isDone) async {
    db.execute('''
      INSERT INTO tasks (name, point_reward, remind_date, due_date, is_recurring, done)
      VALUES ('$taskName', $pointReward, '$remindDate', '$dueDate', $isRecuring, $isDone)
    ''');
  }


  Future<String> getTasks() async {
    final ResultSet resultSet = db.select('SELECT * FROM tasks;');
    return resultSet.toString();
  }

  int getNumberOfPointsSync() {
    final ResultSet resultSet = db.select('SELECT points FROM points;');
    return resultSet.first['points'];
  }
  
  String getTasksSync() {
    final ResultSet resultSet = db.select('SELECT * FROM tasks;');
    return resultSet.toString();
  }


  List<String> getTasksNameSync() {
    List<String> names = [];
    final ResultSet resultSet = db.select('SELECT name FROM tasks ORDER BY id DESC;');

    for (final Row row in resultSet) {
      names.add(row['name'].toString());
    }
    return names;
  }
  
  List<String> getPointsNameSync() {
    List<String> names = [];
    final ResultSet resultSet = db.select('SELECT * FROM tasks;'); // todo: not "SELECT * FROM tasks;" but "SELECT point_reward FROM tasks;"
    for (final Row row in resultSet) {
      names.add(row['point_reward'].toString());
    }
    return names;
  }

  Future<void> completeTask(String taskName) async {
    db.execute('''UPDATE tasks SET done = 1 WHERE name = ?;''', [taskName]);
  }
    Future<void> resetTaskCompletion(String taskName) async {
    db.execute('''UPDATE tasks SET done = 0 WHERE name = ?;''', [taskName]);
  }

  Future<void> updateTask(String taskName, bool newDoneStatus) async {
    db.execute('''UPDATE tasks SET done = ? WHERE name = ?;''', [newDoneStatus ? 1 : 0, taskName]);
  }


  Future<void> removeTask(String taskName) async {
    db.execute('''DELETE FROM tasks WHERE name = ?;''', [taskName]);
  }

  void removeTaskSync(String taskName) {
    db.execute('''DELETE FROM tasks WHERE name = ?;''', [taskName]);
  }

  void removeLastTaskSync(String taskName) {
    db.execute('''DELETE FROM tasks WHERE rowid = ( SELECT rowid FROM tasks WHERE name = ? ORDER BY id DESC LIMIT 1);''', [taskName]);
  }
  
  int getPointFromTaskName(String taskName) {
    final resultSet = db.select(
      'SELECT point_reward FROM tasks WHERE name = ?',
      [taskName],
    );

    if (resultSet.isNotEmpty) {
      return resultSet.first['point_reward'] as int; // Retourne le nombre de points
    } else {
      throw Exception('Task not found');
    }
  }


  Database get db {
    if (_db == null) {
      throw Exception("Database not initialized. Call initDatabase() first.");
    }
    return _db!;
  }

  void closeDatabase() {
    db.dispose();
  }



// whishlist
  Future<void> tryCreateWishesTable() async {
    // Check if the table exists
    final tableExists = db.select('''
      SELECT name 
      FROM sqlite_master 
      WHERE type='table' AND name='wishes';
    ''');

    // If the table exists, return early
    if (tableExists.isNotEmpty) {
      return;
    }

    // Create the table if it doesn't exist
    db.execute('''
      CREATE TABLE wishes (
        id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique identifier for each task
        name TEXT NOT NULL, -- Task description, required
        point_reward INTEGER DEFAULT 0, -- Reward points, default 0
        remind_date DATETIME, -- Reminder date and time (can be NULL)
        due_date DATETIME, -- Due date (optional)
        is_recurring BOOLEAN DEFAULT FALSE, -- Whether the task is recurring, default FALSE
        done BOOLEAN DEFAULT FALSE -- Whether the task is completed, default FALSE
      );
    ''');
  }

  List<String> getWishesNameSync() {
    List<String> names = [];
    final ResultSet resultSet = db.select('SELECT * FROM wishes;');
    for (final Row row in resultSet) {
      names.add(row['name'].toString());
    }
    return names;
  }

  void removeLastWishesSync(String taskName) {
    db.execute('''DELETE FROM wishes WHERE rowid = ( SELECT rowid FROM wishes WHERE name = ? ORDER BY id DESC LIMIT 1);''', [taskName]);
  }


  void addWishesSyncro(String taskName, int pointReward, String remindDate, String dueDate, bool isRecuring, bool isDone) async {
    db.execute('''
      INSERT INTO wishes (name, point_reward, remind_date, due_date, is_recurring, done)
      VALUES ('$taskName', $pointReward, '$remindDate', '$dueDate', $isRecuring, $isDone)
    ''');
  }


  int getPointFromWishName(String taskName) {
    final resultSet = db.select(
      'SELECT point_reward FROM wishes WHERE name = ?',
      [taskName],
    );

    if (resultSet.isNotEmpty) {
      return resultSet.first['point_reward'] as int; // Retourne le nombre de points
    } else {
      throw Exception('Task not found');
    }
  }


}


  // SQL Functions
  // Register a custom function we can invoke from sql:
  // db.createFunction(
  //   functionName: 'dart_version',
  //   argumentCount: const AllowedArgumentCount(0),
  //   function: (args) => Platform.version,
  // );
  // debugPrint(db.select('SELECT dart_version()').toString());









