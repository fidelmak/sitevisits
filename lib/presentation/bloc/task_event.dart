part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();
}
class GetTask extends TaskEvent {
  @override

  List<Object?> get props =>[];

}
class LoadMoreTasks extends TaskEvent {
  @override
  List<Object?> get props => [];
}
class UpdateTask extends TaskEvent {
 final  String id ;
 final Status status;

  const UpdateTask({required this.id, required this.status});
  @override

  List<Object?> get props =>[id,status];

}

class RefreshTasks extends TaskEvent {
  final Completer<void>? completer;

  const RefreshTasks({this.completer});

  @override
  List<Object?> get props => [completer];
}