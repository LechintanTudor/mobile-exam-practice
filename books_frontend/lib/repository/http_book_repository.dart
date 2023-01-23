import 'dart:convert';

import 'package:books/model/book.dart';
import 'package:books/repository/book_repository.dart';
import 'package:books/utils/web.dart';
import 'package:http/http.dart' as http;

class HttpBookRepository implements BookRepository {
  const HttpBookRepository();

  @override
  Future<Book> addBook(Book book) async {
    var response = await http.post(
      Uri.parse('$apiBaseUrl/book'),
      body: <String, String>{
        'title': book.title,
      },
    );

    if (response.statusCode != 201) {
      throw const BookRepositoryError('Failed to add book');
    }

    return Book.fromJson(jsonDecode(response.body));
  }

  @override
  Future<List<Book>> getBooks() async {
    var response = await http.get(Uri.parse('$apiBaseUrl/books'));

    if (response.statusCode != 200) {
      throw const BookRepositoryError('Failed to get books');
    }

    return (jsonDecode(response.body) as List)
        .map((book) => Book.fromJson(book))
        .toList();
  }
}
