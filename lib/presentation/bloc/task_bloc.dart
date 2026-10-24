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
    on<SearchTasks>(_onSearchTasks);
    on<SyncUnsyncedTasks>(_onSyncUnsyncedTasks);
  }

  FutureOr<void> _onGetTask(GetTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await repository.getTask();
      emit(TaskLoaded(tasks: tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  FutureOr<void> _onSearchTasks(
    SearchTasks event,
    Emitter<TaskState> emit,
  ) async {
    final trimmed = event.query.trim();
    if (trimmed.isEmpty) {
      add(GetTask());
      return;
    }

    try {
      final tasks = await repository.searchTasks(trimmed);
      emit(TaskLoaded(tasks: tasks, searchQuery: trimmed));
    } catch (e) {
      final cachedItems = repository.localDatasource?.getCachedTasks() ?? [];
      final filtered = cachedItems
          .where((item) => item.title.toLowerCase().contains(trimmed.toLowerCase()))
          .toList();
      emit(TaskLoaded(tasks: TaskApiModel(items: filtered), searchQuery: trimmed));
    }
  }

  FutureOr<void> _onUpdateTask(
    UpdateTask event,
    Emitter<TaskState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TaskLoaded) return;

    final previousItems = currentState.tasks.items;

    // 1. Set task status and syncStatus = 'pending' (optimistic update)
    final pendingItems = previousItems.map((item) {
      if (item.id == event.id) {
        return item.copyWith(
          status: event.status,
          syncStatus: 'pending',
        );
      }
      return item;
    }).toList();

    final pendingLoadedState = currentState.copyWith(
      tasks: currentState.tasks.copyWith(items: pendingItems),
    );

    // Emit pending state so UI shows 'pending' status immediately
    emit(pendingLoadedState);

    // 2. Hit network in background
    try {
      final syncedTask = await repository.upDateTask(event.id, event.status);

      // On success, clear syncStatus for that item
      final successItems = pendingItems.map((item) {
        if (item.id == event.id) {
          return syncedTask.copyWith(clearSyncStatus: true);
        }
        return item;
      }).toList();

      final successLoadedState = currentState.copyWith(
        tasks: currentState.tasks.copyWith(items: successItems),
      );

      // Fire TaskUpdated to trigger success SnackBar
      emit(TaskUpdated(syncedTask));
      // Restore TaskLoaded state
      emit(successLoadedState);
    } catch (e) {
      // On error, set syncStatus = 'not saved retry'
      final errorItems = pendingItems.map((item) {
        if (item.id == event.id) {
          return item.copyWith(syncStatus: 'not saved retry');
        }
        return item;
      }).toList();

      final errorLoadedState = currentState.copyWith(
        tasks: currentState.tasks.copyWith(items: errorItems),
      );

      final displayId = event.id.replaceAll('task_', '');

      // Emit error state
      emit(TaskError("Couldn't update site visit #$displayId"));
      // Emit loaded state
      emit(errorLoadedState);
    }
  }

  Future<void> _onSyncUnsyncedTasks(
    SyncUnsyncedTasks event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await repository.syncUnsyncedTasks();
      final updatedTasks = await repository.getTask();
      emit(TaskLoaded(tasks: updatedTasks));
    } catch (e) {
      // Sync error handled silently or via state
    }
  }

  Future<void> _onRefreshTasks(
    RefreshTasks event,
    Emitter<TaskState> emit,
  ) async {
    try {
      // Sync any unsynced first
      await repository.syncUnsyncedTasks();
      final freshTasks = await repository.refreshTask();

      emit(TaskLoaded(
        tasks: freshTasks,
        hasReachedMax: freshTasks.nextCursor == null,
        isLoadingMore: false,
      ));
    } catch (e) {
      if (state is TaskLoaded) {
        // Keep current state on refresh error
      } else {
        emit(TaskError(e.toString()));
      }
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

    emit(currentState.copyWith(isLoadingMore: true));
    try {
      final cursor = currentState.tasks.items.length;
      final newPageData = await repository.loadMoreTask(cursor);
      final newItems = newPageData.items;

      if (newItems.isEmpty) {
        emit(currentState.copyWith(
          hasReachedMax: true,
          isLoadingMore: false,
        ));
      } else {
        final combinedItems = List.of(currentState.tasks.items)..addAll(newItems);
        final updatedTaskModel = currentState.tasks.copyWith(items: combinedItems);

        emit(currentState.copyWith(
          tasks: updatedTaskModel,
          hasReachedMax: newPageData.nextCursor == null,
          isLoadingMore: false,
        ));
      }
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}
