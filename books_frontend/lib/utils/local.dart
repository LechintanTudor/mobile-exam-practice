import 'package:sqflite/sqflite.dart';
import 'package:books/repository/local_book_repository.dart';

Future<Database> openLocalDatabase(String path) async {
  return await openDatabase(
    path,
    version: 1,
    onCreate: (database, version) async {
      await database.execute('''
        CREATE TABLE ${LocalBookRepository.bookTable} (
          ${LocalBookRepository.idColumn} INT PRIMARY KEY NOT NULL,
          ${LocalBookRepository.titleColumn} CHAR(64) NOT NULL,
          ${LocalBookRepository.dateColumn} CHAR(64) NOT NULL
        );
      ''');
    },
  );
}
