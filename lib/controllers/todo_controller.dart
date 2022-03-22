import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_test/models/todo_model.dart';
import 'package:riverpod_test/todo_api.dart';

final todoController = StateNotifierProvider<TodoController, List<TodoModel>>(
    (ref) => TodoController());

class TodoController extends StateNotifier<List<TodoModel>> {
  TodoController([List<TodoModel>? state]) : super(state ?? []);

  Future<void> fetchAll() async {
    state = await TodoAPI.fetchAll();
  }

  Future<void> add(String txt) async {
    final todo = TodoModel(
      title: txt,
      date: DateTime.now(),
    );
    await TodoAPI.put(todo);
    state = state.toList()..add(todo);
  }

  Future<void> remove(String id) async {
    await TodoAPI.delete(id);
    state = state.toList()..removeWhere((element) => element.id == id);
  }

  void toggle(String id) async {
    final todo = state.firstWhere((element) => element.id == id);
    final newTodo = todo.copyWith(completed: !todo.completed);
    await TodoAPI.put(newTodo);
    state = state.map((e) => e.id == id ? newTodo : e).toList();
  }
}
