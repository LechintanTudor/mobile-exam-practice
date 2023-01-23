import 'package:books/model/book.dart';

class BookRepositoryError implements Exception {
  final String message;

  const BookRepositoryError(this.message);

  @override
  String toString() {
    return 'BookRepository: $message';
  }
}

abstract class BookRepository {
  Future<Book> addBook(Book book);

  Future<List<Book>> getBooks();
}
