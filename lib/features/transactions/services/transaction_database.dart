import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/transaction_model.dart';

class TransactionDatabase {
  TransactionDatabase._();

  static final TransactionDatabase instance = TransactionDatabase._();

  static const String _databaseName = 'expenzia.db';
  static const int _databaseVersion = 1;
  static const String tableName = 'transactions';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL CHECK(amount > 0),
            type TEXT NOT NULL CHECK(type IN ('Income', 'Expense')),
            date TEXT NOT NULL
          )
        ''');
      },
    );

    return _database!;
  }

  Future<int> insert(TransactionModel transaction) async {
    final db = await database;

    final values = transaction.toMap()..remove('id');

    return db.insert(
      tableName,
      values,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<TransactionModel>> getAll() async {
    final db = await database;

    final rows = await db.query(tableName, orderBy: 'date DESC, id DESC');

    return rows.map(TransactionModel.fromMap).toList();
  }

  Future<TransactionModel?> getById(int id) async {
    final db = await database;

    final rows = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    return TransactionModel.fromMap(rows.first);
  }

  Future<int> update(TransactionModel transaction) async {
    final db = await database;
    final id = transaction.id;

    if (id == null) {
      throw ArgumentError('Cannot update a transaction without an ID.');
    }

    final values = transaction.toMap()..remove('id');

    return db.update(tableName, values, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await database;

    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
