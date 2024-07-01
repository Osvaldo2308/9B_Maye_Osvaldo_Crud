import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crud/modelos/notas.dart';

class Crud {
  static Future<Database> _openDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'notas.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE IF NOT EXISTS notas (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT, descripcion TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> insertarOperacion(Notas nota) async {
    Database db = await _openDB();
    await db.insert('notas', nota.toMap());
  }

  static Future<List<Notas>> obtenerNotas() async {
    Database db = await _openDB();
    final List<Map<String, dynamic>> notasMap = await db.query('notas');
  
    return List.generate(notasMap.length, (i) {
      return Notas(
        id: notasMap[i]['id'],
        titulo: notasMap[i]['titulo'],
        descripcion: notasMap[i]['descripcion'],
      );
    });
  }

  static Future<void> actualizarNota(Notas nota) async {
    Database db = await _openDB();
    await db.update(
      'notas',
      nota.toMap(),
      where: 'id = ?',
      whereArgs: [nota.id],
    );
  }

  static Future<void> eliminarNota(int id) async {
    Database db = await _openDB();
    await db.delete(
      'notas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
