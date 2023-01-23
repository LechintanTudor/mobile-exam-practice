import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final String date;

  const Book({
    this.id = 0,
    required this.title,
    this.date = '',
  });

  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'data': date,
      };

  @override
  List<Object?> get props => [id, title, date];
}
