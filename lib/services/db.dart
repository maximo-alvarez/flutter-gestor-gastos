import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

// Clase que maneja la base de datos SQLite
class DbService extends GetxService {
  late Database db;
  Future<DbService> init() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'expense_manager.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (d, v) async {
        await d.execute('''
          CREATE TABLE categories(
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL
          );
        ''');
        await d.execute('''
          CREATE TABLE transactions(
            id TEXT PRIMARY KEY,
            description TEXT NOT NULL,
            amount REAL NOT NULL,
            date TEXT NOT NULL,
            categoryId TEXT NOT NULL,
            type TEXT NOT NULL,
            FOREIGN KEY (categoryId) REFERENCES categories(id)
          );
        ''');
      },
    );
    return this;
  }
}
