import 'package:books/pages/book_list/book_list_page.dart';
import 'package:books/pages/book_list/cubit/book_list_cubit.dart';
import 'package:books/repository/http_book_repository.dart';
import 'package:books/repository/local_book_repository.dart';
import 'package:books/utils/local.dart';
import 'package:books/utils/web.dart';
import 'package:books/websocket/websocket_book_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var database = await openLocalDatabase('books.db');
  runApp(App(database: database));
}

class App extends StatelessWidget {
  final Database _database;

  const App({
    super.key,
    required Database database,
  }) : _database = database;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HttpBookRepository>(create: (context) {
          return const HttpBookRepository();
        }),
        RepositoryProvider<LocalBookRepository>(create: (context) {
          return LocalBookRepository(database: _database);
        }),
        RepositoryProvider<WebsocketBookListener>(create: (context) {
          return WebsocketBookListener(uri: websocketUrl);
        }),
      ],
      child: BlocProvider<BookListCubit>(
        create: (context) {
          var serverBookRepository =
              RepositoryProvider.of<HttpBookRepository>(context);

          var localBookRepository =
              RepositoryProvider.of<LocalBookRepository>(context);

          var websocketBookListener =
              RepositoryProvider.of<WebsocketBookListener>(context);

          return BookListCubit(
            serverBookRepository: serverBookRepository,
            localBookRepository: localBookRepository,
            websocketBookListener: websocketBookListener,
          )..getAllBooks();
        },
        child: const MaterialApp(
          home: BookListPage(),
        ),
      ),
    );
  }
}
