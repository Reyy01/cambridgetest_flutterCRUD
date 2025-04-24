import 'package:demo/models/task.model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task.event.dart';
part 'task.state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc() : super(const TaskState()) {
    on<AddTask>((AddTask event, Emitter<TaskState> emit) async {
      emit(state.copyWith(
        tasks: state.tasks.toList()..add(event.task),
      ));
    });

    on<UpdateTask>((UpdateTask event, Emitter<TaskState> emit) async {
      final updatedTasks = state.tasks.map((task) {
        return task.id == event.task.id ? event.task : task;
      }).toList();

      emit(state.copyWith(tasks: updatedTasks));
    });

    on<DeleteTask>((DeleteTask event, Emitter<TaskState> emit) async {
      final updatedTasks =
          state.tasks.where((task) => task.id != event.taskId).toList();

      emit(state.copyWith(tasks: updatedTasks));
    });

    on<ToggleTask>((ToggleTask event, Emitter<TaskState> emit) async {
      final updatedTasks = state.tasks.map((task) {
        return task.id == event.taskId
            ? task.copyWith(isCompleted: !task.isCompleted)
            : task;
      }).toList();

      emit(state.copyWith(tasks: updatedTasks));
    });

    on<LoadTasks>((LoadTasks event, Emitter<TaskState> emit) async {
      emit(state.copyWith(
        isLoading: true,
      ));

      // delay
      await Future.delayed(const Duration(seconds: 2), () {
        emit(state.copyWith(
          isLoading: false,
        ));
      });
    });
  }
}
