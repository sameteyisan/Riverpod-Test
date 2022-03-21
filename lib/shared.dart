import 'package:riverpod_test/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static Future<List<TodoModel>> fetch() async {
    final pref = await SharedPreferences.getInstance();
    final keys = pref.getKeys();
    return keys.map((e) => TodoModel.fromJson(pref.getString(e)!)).toList();
  }

  static Future<void> add(TodoModel todo) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(todo.id.toString(), todo.toJson());
  }

  static Future<void> delete(String id) async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(id);
  }

  static Future<void> toggle(TodoModel newTodo) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(newTodo.id, newTodo.toJson());
  }
}
