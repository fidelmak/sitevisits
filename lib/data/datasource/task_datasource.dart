import '../../core/network/flaky_task_api.dart';
import '../../domain/entity.dart';
import '../models/task_api_model.dart';

class TaskDatasource {
  final FlakyTaskApi api;

  TaskDatasource({required this.api});

  Future<TaskApiModel> getTasks({String? query, String? cursor, int limit = 20}) async {
    final taskPage = await api.fetchTasks(
      cursor: cursor,
      query: query ?? '',
      limit: limit,
    );
    final items = taskPage.items.map((json) => Item.fromJson(json)).toList();
    return TaskApiModel(items: items, nextCursor: taskPage.nextCursor);
  }

  Future<TaskApiModel> loadMoreTasks(int cursor, {int limit = 20}) async {
    final taskPage = await api.fetchTasks(
      cursor: cursor == 0 ? null : cursor.toString(),
      limit: limit,
    );
    final items = taskPage.items.map((json) => Item.fromJson(json)).toList();
    return TaskApiModel(items: items, nextCursor: taskPage.nextCursor);
  }

  // update task
  Future<Item> upDateTasks(String id, Status status) async {
    final updatedJson = await api.updateStatus(id, status.name);
    return Item.fromJson(updatedJson);
  }
}
