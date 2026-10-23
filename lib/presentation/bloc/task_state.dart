part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();
}

final class TaskInitial extends TaskState {
  @override
  List<Object> get props => [];
}
final class TaskLoading extends TaskState {
  @override
  List<Object> get props => [];
}
final class TaskLoaded extends TaskState {
  final TaskApiModel tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];
}
final class TaskUpdated extends TaskState {
  final Item task;

  const TaskUpdated(this.task);

  @override
  List<Object> get props => [task];
}
final class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
