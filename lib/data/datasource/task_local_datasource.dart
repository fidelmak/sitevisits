import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entity.dart';
import '../models/task_api_model.dart';

class TaskLocalDatasource {
  static const String _cachedTasksKey = 'cached_tasks';
  static const String _unsyncedTasksKey = 'unsynced_tasks';

  final SharedPreferences prefs;

  TaskLocalDatasource({required this.prefs});

  /// Get cached task items from SharedPreferences
  List<Item> getCachedTasks() {
    try {
      final jsonString = prefs.getString(_cachedTasksKey);
      if (jsonString == null || jsonString.isEmpty) return [];
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Save task items to SharedPreferences cache
  Future<void> saveTasks(List<Item> tasks) async {
    try {
      final jsonList = tasks.map((e) => e.toJson()).toList();
      await prefs.setString(_cachedTasksKey, jsonEncode(jsonList));
    } catch (e) {
      // Ignore cache write errors
    }
  }

  /// Save or update a single task's status and syncStatus in cache
  Future<List<Item>> updateTaskLocal(String id, Status status, String syncStatus) async {
    final currentTasks = getCachedTasks();
    bool found = false;

    final updatedTasks = currentTasks.map((item) {
      if (item.id == id) {
        found = true;
        return item.copyWith(
          status: status,
          syncStatus: syncStatus,
          updatedAt: DateTime.now(),
        );
      }
      return item;
    }).toList();

    if (!found) {
      updatedTasks.add(
        Item(
          id: id,
          title: 'Task $id',
          status: status,
          updatedAt: DateTime.now(),
          syncStatus: syncStatus,
        ),
      );
    }

    await saveTasks(updatedTasks);
    await _recordUnsynced(id, status, syncStatus);
    return updatedTasks;
  }

  /// Record an unsynced task update
  Future<void> _recordUnsynced(String id, Status status, String syncStatus) async {
    final unsyncedMap = getUnsyncedMap();
    if (syncStatus == 'synced' || syncStatus.isEmpty) {
      unsyncedMap.remove(id);
    } else {
      unsyncedMap[id] = {
        'id': id,
        'status': status.name,
        'syncStatus': syncStatus,
        'updatedAt': DateTime.now().toIso8601String(),
      };
    }
    await prefs.setString(_unsyncedTasksKey, jsonEncode(unsyncedMap));
  }

  /// Get raw unsynced map
  Map<String, dynamic> getUnsyncedMap() {
    try {
      final jsonString = prefs.getString(_unsyncedTasksKey);
      if (jsonString == null || jsonString.isEmpty) return {};
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return {};
    }
  }

  /// Mark task as synced in local cache
  Future<List<Item>> markTaskSynced(String id) async {
    final currentTasks = getCachedTasks();
    final updatedTasks = currentTasks.map((item) {
      if (item.id == id) {
        return item.copyWith(clearSyncStatus: true);
      }
      return item;
    }).toList();

    await saveTasks(updatedTasks);
    await _recordUnsynced(id, Status.open, 'synced');
    return updatedTasks;
  }

  /// Get list of unsynced items
  List<Item> getUnsyncedTasks() {
    final tasks = getCachedTasks();
    return tasks
        .where((item) => item.syncStatus == 'pending' || item.syncStatus == 'not saved retry')
        .toList();
  }
}
