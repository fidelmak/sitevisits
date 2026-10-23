

import '../datasource/task_datasource.dart';
import '../models/task_api_model.dart';

class TaskRepository {
  final TaskDatasource  provider;

  TaskRepository({required this.provider,});


  Future<TaskApiModel> getTask() async {
    final tasks = await provider.getTasks();
    return tasks;
  }


  Future<TaskApiModel> refreshTask() async{
    final tasks = await provider.getTasks();


    return tasks;

  }


}