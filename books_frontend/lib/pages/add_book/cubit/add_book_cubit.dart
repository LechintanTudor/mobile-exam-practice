import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_book_state.dart';

class AddBookCubit extends Cubit<AddBookState> {
  AddBookCubit({
    AddBookState state = const AddBookState.initial(),
  }) : super(state);

  void submit() {
    emit(const AddBookState(didSubmit: true));
  }

  void reset() {
    emit(const AddBookState(didSubmit: false));
  }
}
