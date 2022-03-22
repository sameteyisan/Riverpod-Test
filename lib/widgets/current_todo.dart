import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_test/controllers/current_todo.dart';
import 'package:riverpod_test/controllers/todo_controller.dart';

class CurrentTodo extends HookConsumerWidget {
  const CurrentTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(currentTodo);
    return Card(
      color: !item.completed
          ? Colors.white
          : const Color.fromARGB(255, 255, 246, 195),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        onTap: () {
          ref.read(todoController.notifier).toggle(item.id);
        },
        leading: Checkbox(
          activeColor: Colors.black,
          value: item.completed,
          onChanged: (value) =>
              ref.read(todoController.notifier).toggle(item.id),
        ),
        minVerticalPadding: 15,
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        title: Text(
          item.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text("📅 " +
            item.date.toString().split(".")[0].replaceFirst(" ", " 🕑 ")),
        trailing: IconButton(
            splashRadius: 25,
            onPressed: () => ref.read(todoController.notifier).remove(item.id),
            icon: const Icon(Icons.delete)),
      ),
    );
  }
}
