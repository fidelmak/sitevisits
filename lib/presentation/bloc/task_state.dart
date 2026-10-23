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
class TaskLoaded extends TaskState {
  final TaskApiModel tasks;
  final bool hasReachedMax;
  final bool isLoadingMore;

  TaskLoaded({
    required this.tasks,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  TaskLoaded copyWith({
    TaskApiModel? tasks,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return TaskLoaded(
      tasks: tasks ?? this.tasks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [tasks, hasReachedMax, isLoadingMore];
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
