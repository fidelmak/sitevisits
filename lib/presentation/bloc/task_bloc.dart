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
    on<LoadMoreTasks>(_onLoadMoreTask);
    on<RefreshTasks>(_onRefreshTasks);

  }

  FutureOr<void> _onGetTask(GetTask event, Emitter<TaskState> emit) async{

      emit(TaskLoading());
      await Future<void>.delayed(const Duration(seconds: 2));
      try{
        final tasks = await repository.getTask();
        emit(TaskLoaded( tasks:tasks,));
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
  Future<void> _onRefreshTasks(
      RefreshTasks event,
      Emitter<TaskState> emit,
      ) async {
    try {
      // Re-fetch the very first batch (cursor 0 or initial load)
      final freshTasks = await repository.loadMoreTask(0);

      emit(TaskLoaded(
        tasks: freshTasks,
        hasReachedMax: freshTasks.nextCursor == null,
        isLoadingMore: false,
      ));
    } catch (e) {

    } finally {

      event.completer?.complete();
    }
  }

  Future<void> _onLoadMoreTask(
      LoadMoreTasks event,
      Emitter<TaskState> emit,
      ) async {
    final currentState = state;


    if (currentState is! TaskLoaded ||
        currentState.hasReachedMax ||
        currentState.isLoadingMore) {
      return;
    }

    // Emit loading indicator for the pagination spinner
    emit(currentState.copyWith(isLoadingMore: true));
    await Future<void>.delayed(const Duration(seconds: 2));
    try {

      final cursor = currentState.tasks.items.length;


      final newPageData = await repository.loadMoreTask(cursor);

      final newItems = newPageData.items ?? [];

      if (newItems.isEmpty) {
        // No more data to fetch
        emit(currentState.copyWith(
          hasReachedMax: true,
          isLoadingMore: false,
        ));
      } else {

        final combinedItems = List.of(currentState.tasks.items)..addAll(newItems);


        final updatedTaskModel = currentState.tasks.copyWith(items: combinedItems);

        emit(currentState.copyWith(
          tasks: updatedTaskModel,
          hasReachedMax: newItems.length < 20,
          isLoadingMore: false,
        ));
      }
    } catch (e) {


      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}
