import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:books/model/book.dart';
import 'package:books/model/loading_status.dart';
import 'package:books/model/online_status.dart';
import 'package:books/repository/book_repository.dart';
import 'package:books/repository/local_book_repository.dart';
import 'package:books/websocket/websocket_book_listener.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_list_state.dart';

class BookListCubit extends Cubit<BookListState> {
  final BookRepository _serverBookRepository;
  final LocalBookRepository _localBookRepository;
  final WebsocketBookListener _websocketBookListener;

  BookListCubit({
    BookListState state = const BookListState.initial(),
    required BookRepository serverBookRepository,
    required LocalBookRepository localBookRepository,
    required WebsocketBookListener websocketBookListener,
  })  : _serverBookRepository = serverBookRepository,
        _localBookRepository = localBookRepository,
        _websocketBookListener = websocketBookListener,
        super(state);

  Future<void> addBook(Book book) async {
    try {
      emit(state.copyWith(status: LoadingStatus.loading));
      var newBook = await _serverBookRepository.addBook(book);
      emit(state.copyWith(
        status: LoadingStatus.success,
        books: [...state.books, newBook],
      ));
    } catch (error) {
      emit(state.copyWith(
        status: LoadingStatus.error,
        error: error.toString(),
      ));
    }
  }

  Future<void> getAllBooks() async {
    emit(state.copyWith(status: LoadingStatus.loading));

    try {
      var books = await _serverBookRepository.getBooks();

      emit(state.copyWith(
        onlineStatus: OnlineStatus.online,
        status: LoadingStatus.success,
        books: books,
      ));

      await _localBookRepository.setBooks(books);

      _websocketBookListener.connect((message) async {
        var book = Book.fromJson(jsonDecode(message));
        await _addBookFromWebsocket(book);
      });
    } on SocketException catch (_) {
      await _getAllBooksOffline();
    } on TimeoutException catch (_) {
      await _getAllBooksOffline();
    } catch (error) {
      emit(state.copyWith(
        status: LoadingStatus.error,
        error: error.toString(),
      ));
    }
  }

  Future<void> _addBookFromWebsocket(Book book) async {
    await _localBookRepository.addBook(book);

    if (state.books.any((oldBook) => oldBook.id == book.id)) {
      return;
    }

    emit(state.copyWith(books: [...state.books, book]));
  }

  Future<void> _getAllBooksOffline() async {
    var books = await _localBookRepository.getBooks();

    emit(state.copyWith(
      onlineStatus: OnlineStatus.offline,
      status: LoadingStatus.success,
      books: books,
    ));
  }
}
