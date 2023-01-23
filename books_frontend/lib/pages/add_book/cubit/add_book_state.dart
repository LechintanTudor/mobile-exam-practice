part of 'add_book_cubit.dart';

class AddBookState extends Equatable {
  final bool didSubmit;

  const AddBookState({required this.didSubmit});

  const AddBookState.initial() : didSubmit = false;

  @override
  List<Object?> get props => [didSubmit];
}
