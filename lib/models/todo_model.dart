import 'dart:convert';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TodoModel {
  final String id;
  final String title;
  final DateTime date;
  final bool completed;

  TodoModel({
    String? id,
    required this.title,
    required this.date,
    this.completed = false,
  }) : id = id ?? uuid.v4();

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'date': date.millisecondsSinceEpoch});
    result.addAll({'completed': completed});

    return result;
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      completed: map['completed'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));

  TodoModel copyWith({
    String? id,
    String? title,
    DateTime? date,
    bool? completed,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      completed: completed ?? this.completed,
    );
  }
}
