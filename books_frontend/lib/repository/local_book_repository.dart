import 'package:books/model/book.dart';
import 'package:books/repository/book_repository.dart';
import 'package:sqflite/sqflite.dart';

class LocalBookRepository implements BookRepository {
  static const bookTable = 'books';
  static const idColumn = 'id';
  static const titleColumn = 'title';
  static const dateColumn = 'date';

  final Database _database;

  const LocalBookRepository({required Database database})
      : _database = database;

  @override
  Future<Book> addBook(Book book) async {
    await _database.insert(bookTable, {
      idColumn: book.id,
      titleColumn: book.title,
      dateColumn: book.date,
    });

    return book;
  }

  @override
  Future<List<Book>> getBooks() async {
    var bookObjects = await _database.query(
      bookTable,
      columns: [idColumn, titleColumn, dateColumn],
    );

    return bookObjects.map((book) => Book.fromJson(book)).toList();
  }

  Future<void> setBooks(List<Book> books) async {
    await _database.transaction((transaction) async {
      await transaction.delete(bookTable);

      for (var book in books) {
        await transaction.insert(bookTable, {
          idColumn: book.id,
          titleColumn: book.title,
          dateColumn: book.date,
        });
      }
    });
  }
}
