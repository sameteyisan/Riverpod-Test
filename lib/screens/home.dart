import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_test/controllers/todo_controller.dart';
import 'package:riverpod_test/models/todo_model.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final controller = ref.watch(todoController.notifier);
    final isEmpty = useState(true);

    useEffect(() {
      textEditingController.addListener(() {
        isEmpty.value = textEditingController.text.trim().isEmpty;
      });
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'TODO APP EXAMPLE',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: "What needs to be done?",
                labelText: "ToDo",
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
                      final todo = TodoModel(
                        title: textEditingController.text,
                        date: DateTime.now(),
                      );
                      controller.add(todo);
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

              return todos.when(
                  data: (list) {
                    return list.isNotEmpty
                        ? ListView.builder(
                            physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            itemCount: list.length,
                            itemBuilder: ((context, index) {
                              final item = list[index];
                              return Card(
                                color: Colors.cyanAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                  leading: Checkbox(
                                    activeColor: Colors.green,
                                    value: item.completed,
                                    onChanged: (value) =>
                                        controller.toggle(index),
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
                                  subtitle:
                                      Text(item.date.toString().split(".")[0]),
                                  trailing: IconButton(
                                      splashRadius: 25,
                                      onPressed: () =>
                                          controller.remove(item.id),
                                      icon: const Icon(Icons.delete)),
                                ),
                              );
                            }),
                          )
                        : const Center(
                            child: Text(
                              "No items...",
                              style:
                                  TextStyle(fontSize: 21, color: Colors.grey),
                            ),
                          );
                  },
                  error: (_, __) => const Center(child: Text("ERR")),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()));
            }))
          ],
        ),
      ),
    );
  }
}
