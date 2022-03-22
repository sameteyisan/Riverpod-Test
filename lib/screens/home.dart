import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_test/controllers/current_todo.dart';
import 'package:riverpod_test/controllers/todo_controller.dart';
import 'package:riverpod_test/widgets/current_todo.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final focus = useFocusNode();
    final isEmpty = useState(true);

    useEffect(() {
      ref.read(todoController.notifier).fetchAll();

      textEditingController.addListener(() {
        isEmpty.value = textEditingController.text.trim().isEmpty;
      });
      return null;
    }, const []);

    return GestureDetector(
      onTap: () {
        focus.unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  "Riverpod TODO",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 32),
                TextField(
                  focusNode: focus,
                  controller: textEditingController,
                  onSubmitted: (_) {
                    ref
                        .read(todoController.notifier)
                        .add(textEditingController.text);
                    textEditingController.clear();
                  },
                  decoration: InputDecoration(
                    hintText: "What needs to be done?",
                    labelText: "Todo",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => textEditingController.clear(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: !isEmpty.value
                      ? () {
                          ref
                              .read(todoController.notifier)
                              .add(textEditingController.text);
                          textEditingController.clear();
                        }
                      : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Consumer(builder: (ctx, ref, _) {
                  final todos = ref.watch(todoController);

                  if (todos.isEmpty) {
                    return const Center(
                      child: Text(
                        "Empty !",
                        style: TextStyle(fontSize: 21, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: ((context, index) {
                      return ProviderScope(
                        overrides: [
                          currentTodo.overrideWithValue(todos[index])
                        ],
                        child: const CurrentTodo(),
                      );
                    }),
                  );
                }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
