part of 'task.bloc.dart';

class TaskState extends Equatable {
  final List<Task> tasks;
  final bool isLoading;
  final String errorMessage;

  const TaskState({
    this.tasks = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [tasks, isLoading, errorMessage];
}
