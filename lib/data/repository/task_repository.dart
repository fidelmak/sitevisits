import '../../domain/entity.dart';
import '../datasource/task_datasource.dart';
import '../datasource/task_local_datasource.dart';
import '../models/task_api_model.dart';

class TaskRepository {
  final TaskDatasource provider;
  final TaskLocalDatasource? localDatasource;

  TaskRepository({
    required this.provider,
    this.localDatasource,
  });

  /// Get tasks
  Future<TaskApiModel> getTask() async {
    try {
      final remoteTasks = await provider.getTasks();
      // Merge with local unsynced status if present
      final mergedItems = _mergeWithLocal(remoteTasks.items);
      final updatedModel = remoteTasks.copyWith(items: mergedItems);
      await localDatasource?.saveTasks(mergedItems);
      return updatedModel;
    } catch (e) {
      final cachedItems = localDatasource?.getCachedTasks() ?? [];
      if (cachedItems.isNotEmpty) {
        return TaskApiModel(items: cachedItems);
      }
      rethrow;
    }
  }

  /// Update task on server
  Future<Item> upDateTask(String id, Status status) async {
    // 1. Save locally as pending
    await localDatasource?.updateTaskLocal(id, status, 'pending');

    try {
      // 2. Attempt remote update
      final updatedTask = await provider.upDateTasks(id, status);
      // 3. Success: mark synced locally
      await localDatasource?.markTaskSynced(id);
      return updatedTask.copyWith(clearSyncStatus: true);
    } catch (e) {
      // 4. Failure: mark as 'not saved retry' locally
      await localDatasource?.updateTaskLocal(id, status, 'not saved retry');
      rethrow;
    }
  }

  /// Load more
  Future<TaskApiModel> loadMoreTask(int cursor, {int limit = 20}) async {
    try {
      final moreTasks = await provider.loadMoreTasks(cursor, limit: limit);
      final mergedItems = _mergeWithLocal(moreTasks.items);
      final updatedModel = moreTasks.copyWith(items: mergedItems);

      // Save combined cached tasks
      final currentCached = localDatasource?.getCachedTasks() ?? [];
      final combinedMap = <String, Item>{};
      for (final item in currentCached) {
        combinedMap[item.id] = item;
      }
      for (final item in mergedItems) {
        combinedMap[item.id] = item;
      }
      await localDatasource?.saveTasks(combinedMap.values.toList());

      return updatedModel;
    } catch (e) {
      final cachedItems = localDatasource?.getCachedTasks() ?? [];
      if (cachedItems.isNotEmpty) {
        return TaskApiModel(items: cachedItems);
      }
      rethrow;
    }
  }

  /// Search tasks with automatic local cache
  Future<TaskApiModel> searchTasks(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return getTask();
    }

    try {
      final searchResults = await provider.getTasks(query: trimmed, cursor: null);
      final mergedItems = _mergeWithLocal(searchResults.items);
      return searchResults.copyWith(items: mergedItems);
    } catch (e) {
      final cachedItems = localDatasource?.getCachedTasks() ?? [];
      final filtered = cachedItems
          .where((item) => item.title.toLowerCase().contains(trimmed.toLowerCase()))
          .toList();
      return TaskApiModel(items: filtered);
    }
  }

  /// Refresh tasks
  Future<TaskApiModel> refreshTask() async {
    return await getTask();
  }

  /// Sync unsynced tasks to backend
  Future<List<Item>> syncUnsyncedTasks() async {
    final unsynced = localDatasource?.getUnsyncedTasks() ?? [];
    if (unsynced.isEmpty) return [];

    final syncedList = <Item>[];
    for (final item in unsynced) {
      try {
        final updated = await provider.upDateTasks(item.id, item.status);
        await localDatasource?.markTaskSynced(item.id);
        syncedList.add(updated.copyWith(clearSyncStatus: true));
      } catch (e) {
        await localDatasource?.updateTaskLocal(item.id, item.status, 'not saved retry');
      }
    }
    return syncedList;
  }

  /// Merge remote items with local unsynced statuses
  List<Item> _mergeWithLocal(List<Item> remoteItems) {
    if (localDatasource == null) return remoteItems;
    final unsyncedMap = localDatasource!.getUnsyncedMap();
    if (unsyncedMap.isEmpty) return remoteItems;

    return remoteItems.map((item) {
      if (unsyncedMap.containsKey(item.id)) {
        final localData = unsyncedMap[item.id] as Map<String, dynamic>;
        final syncStatus = localData['syncStatus'] as String?;
        final statusName = localData['status'] as String?;
        final localStatus = Status.fromApi(statusName);
        return item.copyWith(
          status: localStatus,
          syncStatus: syncStatus,
        );
      }
      return item;
    }).toList();
  }
}
