import 'settings.dart';
import 'models/book.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {
  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      onCreate: (db, version) {
        return db.execute(CREATE_BOOKS_TABLE_SCRIPT);
      },
      version: 1,
    );
  }

  Future create(Book model) async {
    try {
      final Database db = await _getDatabase();
      await db.insert(
        TABLE_NAME,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future<List<Book>> getBooks() async {
    try {
      final Database db = await _getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);

      return List.generate(
        maps.length,
        (i) {
          return Book(
            id: maps[i]['id'],
            title: maps[i]['title'],
            done: maps[i]['done'],
            startDate: maps[i]['startDate'],
            endDate: maps[i]['endDate'],
            newTest: maps[i]['newTest'],
          );
        },
      );
    } catch (ex) {
      print(ex);
      return new List<Book>();
    }
  }

  // Future update(ContactModel model) async {
  //   try {
  //     final Database db = await _getDatabase();

  //     await db.update(
  //       TABLE_NAME,
  //       model.toMap(),
  //       where: "id = ?",
  //       whereArgs: [model.id],
  //     );
  //   } catch (ex) {
  //     print(ex);
  //     return;
  //   }
  // }

}
