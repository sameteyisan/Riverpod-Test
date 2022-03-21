import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_test/models/todo_model.dart';
import 'package:riverpod_test/shared.dart';

final todoList = FutureProvider((ref) => Shared.fetch());

final todoController =
    StateNotifierProvider<TodoController, AsyncValue<List<TodoModel>>>((ref) {
  final todos = ref.watch(todoList);
  return TodoController(todos);
});

class TodoController extends StateNotifier<AsyncValue<List<TodoModel>>> {
  TodoController(AsyncValue<List<TodoModel>> state) : super(state);

  void add(TodoModel todo) async {
    await Shared.add(todo);
    state = AsyncData(state.value!.toList()..add(todo));
  }

  void remove(String id) async {
    await Shared.delete(id);
    state = AsyncData(
        state.value!.toList()..removeWhere((element) => element.id == id));
  }

  void toggle(int index) async {
    final todo = state.value!.elementAt(index);
    final newTodo = todo.copyWith(completed: !todo.completed);
    await Shared.toggle(state.value![index]);
    state = AsyncData(state.value!.toList()..[index] = newTodo);
  }
}
