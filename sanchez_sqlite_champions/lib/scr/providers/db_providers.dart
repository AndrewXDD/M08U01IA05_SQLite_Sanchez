import 'dart:io';
import 'package:path/path.dart';
import 'package:sanchez_sqlite_champions/scr/models/champions_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    // Si la base de dades existeix, retorna la base de dades
    if (_database != null) return _database;

    // Si la base de dades no existeix i crea una
    _database = await initDB();

    return _database;
  }

  // Crear la base de dades i la taula "Champions"
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'champions_manager.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE champions('
          'id INTEGER PRIMARY KEY,'
          'nom TEXT,'
          'description TEXT,'
          'icon TEXT,'
          'lane TEXT'
          ')');
    });
  }

  // Inserta champions en la base de dades
  createChampions(Champions newChampion) async {
    await deleteAllChampions();
    final db = await database;
    final res = await db?.insert('champions', newChampion.toJson());

    return res;
  }

  // Esborra tots els champions
  Future<int?> deleteAllChampions() async {
    final db = await database;
    final res = await db?.rawDelete('DELETE FROM champions');

    return res;
  }

  Future<List<Champions?>> getAllChampions() async {
    final db = await database;
    final res = await db?.rawQuery("SELECT * FROM champions");

    List<Champions> list =
        res!.isNotEmpty ? res.map((c) => Champions.fromJson(c)).toList() : [];

    return list;
  }
}
