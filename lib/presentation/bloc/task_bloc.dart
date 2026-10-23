import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../../data/models/task_api_model.dart';
import '../../data/repository/task_repository.dart';
import '../../domain/entity.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final TaskRepository repository;

  TaskBloc({required this.repository}) : super(TaskInitial()) {
    on<GetTask>(_onGetTask);
    on<UpdateTask>(_onUpdateTask);

  }

  FutureOr<void> _onGetTask(GetTask event, Emitter<TaskState> emit) async{

      emit(TaskLoading());
      await Future<void>.delayed(const Duration(seconds: 2));
      try{
        final tasks = await repository.getTask();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }

  }

  FutureOr<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {

    emit(TaskLoading());
    try{
     await repository.upDateTask(event.id, event.status);
      add(GetTask());

    }catch(e){
      emit(TaskError(e.toString()));
    }
    
  }
}
