import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/task_api_model.dart';
import '../../data/repository/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(TaskInitial()) {
    on<GetTask>((event, emit) async {
      emit(TaskLoading());
      try{
        final tasks = await repository.getTask();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
  }
}
