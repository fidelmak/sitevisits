import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entity.dart';
import '../models/task_api_model.dart';

class TaskDatasource {
  final http.Client client;
  final String _baseUrl =  'http://10.0.2.2:5000/tasks';

  TaskDatasource({required this.client});
  Future<TaskApiModel> getTasks () async {
    final response = await client.get(Uri.parse(_baseUrl));

    if ( response.statusCode == 200 ){
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return TaskApiModel.fromJson(json);
    }else{
      throw Exception('Failed to fetch tasks: ${response.statusCode}',);
    }

  }

  // update  task
  Future<Item> upDateTasks (String id, Status status) async {
    final response= await client.patch(Uri.parse("$_baseUrl/$id"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status.name,}),);

    if ( response.statusCode == 200 ){
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      print(json);
      return Item.fromJson(json);
    }else{
      throw Exception('Failed to fetch tasks: ${response.statusCode}',);
    }

  }
}