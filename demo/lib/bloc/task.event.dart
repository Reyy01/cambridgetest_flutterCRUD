part of 'task.bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final String taskId;

  const DeleteTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTask extends TaskEvent {
  final String taskId;

  const ToggleTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class LoadTasks extends TaskEvent {
  const LoadTasks();

  @override
  List<Object?> get props => [];
}
