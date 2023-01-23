import 'package:books/model/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book _book;

  const BookCard({super.key, required Book book}) : _book = book;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Id: ${_book.id}',
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Title: ${_book.title}',
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Date: ${_book.date}',
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
