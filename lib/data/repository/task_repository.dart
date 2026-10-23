

import '../../domain/entity.dart';
import '../datasource/task_datasource.dart';
import '../models/task_api_model.dart';

class TaskRepository {
  final TaskDatasource  provider;

  TaskRepository({required this.provider,});


  Future<TaskApiModel> getTask() async {
    final tasks = await provider.getTasks();
    return tasks;
  }

  Future<Item> upDateTask(String id, Status status) async {
    final updateTask = await provider.upDateTasks(id, status);
    return updateTask;
  }


  Future<TaskApiModel> refreshTask() async{
    final tasks = await provider.getTasks();


    return tasks;

  }


}