import 'package:demo/bloc/task.bloc.dart';
import 'package:demo/models/task.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TaskBloc taskBloc;
  late Uuid uid;
  late TextEditingController controller;

  @override
  void initState() {
    taskBloc = TaskBloc();
    uid = const Uuid();
    controller = TextEditingController();
    taskBloc.add(const LoadTasks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        mini: true,
        onPressed: () {
          controller.clear();
          taskDialog(null);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        bloc: taskBloc,
        builder: (BuildContext context, TaskState state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.errorMessage.isNotEmpty) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (BuildContext context, int index) {
              final Task task = state.tasks[index];
              return Dismissible(
                confirmDismiss: (DismissDirection direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    taskBloc.add(UpdateTask(
                      Task(
                        id: task.id,
                        title: task.title,
                        isCompleted: !task.isCompleted,
                      ),
                    ));
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    taskBloc.add(DeleteTask(task.id));
                    return true;
                  }
                  return null;
                },
                background: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.green,
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 10),
                        Text(
                          'Done',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.red,
                  child: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                key: Key(task.id),
                child: ListTile(
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: null,
                  ),
                  title: Text(task.title),
                  onTap: () {
                    controller.text = task.title;
                    taskDialog(task.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> taskDialog(String? id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              id != null ? const Text('Update Task') : const Text('Add Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Task Name'),
            onSubmitted: (String value) {
              taskBloc.add(AddTask(
                Task(
                  id: uid.v1(),
                  title: id ?? controller.text,
                  isCompleted: false,
                ),
              ));
              Navigator.of(context).pop();
              controller.clear();
            },
          ),
          actions: <Widget>[
            TextButton(
              child: id != null ? const Text('Update') : const Text('Add'),
              onPressed: () {
                if (id != null) {
                  taskBloc.add(UpdateTask(
                    Task(
                      id: id,
                      title: controller.text,
                      isCompleted: false,
                    ),
                  ));
                } else {
                  taskBloc.add(AddTask(
                    Task(
                      id: uid.v1(),
                      title: controller.text,
                      isCompleted: false,
                    ),
                  ));
                }
                Navigator.of(context).pop();
                controller.clear();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
