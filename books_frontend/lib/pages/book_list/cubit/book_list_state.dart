part of 'book_list_cubit.dart';

class BookListState extends Equatable {
  final OnlineStatus onlineStatus;
  final LoadingStatus status;
  final List<Book> books;
  final String error;

  const BookListState({
    required this.onlineStatus,
    required this.status,
    required this.books,
    required this.error,
  });

  const BookListState.initial()
      : onlineStatus = OnlineStatus.unknown,
        status = LoadingStatus.initial,
        books = const [],
        error = '';

  BookListState copyWith({
    OnlineStatus? onlineStatus,
    LoadingStatus? status,
    List<Book>? books,
    String? error,
  }) {
    return BookListState(
      onlineStatus: onlineStatus ?? this.onlineStatus,
      status: status ?? this.status,
      books: books ?? this.books,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [onlineStatus, status, books, error];
}
