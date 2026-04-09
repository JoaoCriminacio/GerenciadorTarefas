import 'package:gerenciador_tarefas/model/tarefa.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _dbName = 'cadastro_tarefas.db';
  static const _dbVersion = 2;

  DatabaseProvider.int();

  static final DatabaseProvider instance = DatabaseProvider.int();

  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }

    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = '$databasePath/$_dbName';
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE ${Tarefa.NOME_TABELA} (
       ${Tarefa.CAMPO_ID} INTEGER PRIMARY KEY AUTOINCREMENT,
       ${Tarefa.CAMPO_DESCRICAO} TEXT NOT NULL,
       ${Tarefa.CAMPO_PRAZO} TEXT,
       ${Tarefa.CAMPO_FINALIZADA} INTEGER NOT NULL DEFAULT 0);
      '''
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    switch(oldVersion) {
      case 1:
        await db.execute('''
          ALTER TABLE ${Tarefa.NOME_TABELA}
          ADD ${Tarefa.CAMPO_FINALIZADA} INTERGER NOT NULL DEFAULT 0;
        ''');
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}