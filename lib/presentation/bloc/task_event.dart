part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
}
class GetTask extends TaskEvent {
  @override

  List<Object?> get props =>[];

}
class UpdateTask extends TaskEvent {
  @override

  List<Object?> get props =>[];

}