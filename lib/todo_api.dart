import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_test/models/todo_model.dart';

class TodoAPI {
  static Future<List<TodoModel>> fetchAll() async {
    final box = Hive.box("todos");
    return box.values.map((e) => TodoModel.fromJson(e)).toList();
  }

  static Future<void> put(TodoModel todo) async {
    final box = Hive.box("todos");
    await box.put(todo.id, todo.toJson());
  }

  static Future<void> delete(String id) async {
    final box = Hive.box("todos");
    await box.delete(id);
  }
}
