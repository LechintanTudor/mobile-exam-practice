import 'package:books/model/book.dart';
import 'package:books/model/loading_status.dart';
import 'package:books/pages/add_book/cubit/add_book_cubit.dart';
import 'package:books/pages/book_list/cubit/book_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBookPage extends StatelessWidget {
  final _titleController = TextEditingController();

  AddBookPage({super.key});

  static Route route({required BookListCubit bookListCubit}) {
    return MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: bookListCubit,
          ),
          BlocProvider(
            create: (context) => AddBookCubit(),
          ),
        ],
        child: AddBookPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddBookCubit, AddBookState>(
      listener: (context, state) {
        if (!state.didSubmit) {
          return;
        }

        var bookListState = context.read<BookListCubit>().state;

        switch (bookListState.status) {
          case LoadingStatus.success:
            Navigator.pop(context);
            break;

          case LoadingStatus.error:
            _showErrorDialog(context: context, message: bookListState.error);
            context.read<AddBookCubit>().reset();
            break;

          default:
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add Book'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: state.didSubmit
                        ? null
                        : () async {
                            var addBookCubit = context.read<AddBookCubit>();
                            var bookListCubit = context.read<BookListCubit>();

                            await bookListCubit.addBook(_getBook());
                            addBookCubit.submit();
                          },
                    child: const Text('Add book'),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Book _getBook() {
    return Book(title: _titleController.text);
  }
}

void _showErrorDialog({
  required BuildContext context,
  required String message,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
      );
    },
  );
}
