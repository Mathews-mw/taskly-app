import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

enum DbTables {
  tasks,
  subTasks;

  String get value {
    switch (this) {
      case DbTables.tasks:
        return 'tasks';
      case DbTables.subTasks:
        return 'sub_tasks';
    }
  }
}

class AppDatabase {
  // Criar uma instância privada (Singleton)
  static final AppDatabase _instance = AppDatabase._internal();

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  sql.Database? _db;

  Future<sql.Database> get database async {
    if (_db != null) {
      return _db!;
    }

    _db = await _initDatabase();
    return _db!;
  }

  Future<sql.Database> _initDatabase() async {
    final dbPath = await sql.getDatabasesPath();

    return await sql.openDatabase(
      path.join(dbPath, 'taskly.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE ${DbTables.tasks.value} (id TEXT PRIMARY KEY, title TEXT NOT NULL, description TEXT, date TEXT NOT NULL, priority INTEGER NOT NULL, reminder INTEGER NOT NULL, reminderTime TEXT, isCompleted INTEGER NOT NULL)');
      },
      version: 1,
    );
  }

  Future<void> close() async {
    final db = _db;

    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}
