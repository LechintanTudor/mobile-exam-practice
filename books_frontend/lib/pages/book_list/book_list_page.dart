import 'package:books/components/book_card.dart';
import 'package:books/model/loading_status.dart';
import 'package:books/model/online_status.dart';
import 'package:books/pages/add_book/add_book_page.dart';
import 'package:books/pages/book_list/cubit/book_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookListCubit, BookListState>(
      builder: (context, state) {
        var isOffline = state.onlineStatus == OnlineStatus.offline;
        var title = isOffline ? 'Books - Offline' : 'Books';

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Builder(builder: (context) {
            if (state.status == LoadingStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: context.read<BookListCubit>().getAllBooks,
              child: ListView.builder(
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  return BookCard(book: state.books[index]);
                },
              ),
            );
          }),
          floatingActionButton: isOffline
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    var bookListCubit = context.read<BookListCubit>();

                    Navigator.push(
                      context,
                      AddBookPage.route(bookListCubit: bookListCubit),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
        );
      },
    );
  }
}
