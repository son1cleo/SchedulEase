import 'package:client/services/task_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/providers/user_provider.dart';

class TaskLimitProxy {
  final TaskService taskService;
  final UserProvider userProvider;

  TaskLimitProxy({required this.taskService, required this.userProvider});

  Future<Map<String, dynamic>> getTasks(String userId) async {
    if (userId.isEmpty) {
      throw Exception("User ID is required.");
    }

    try {
      final tasks = await taskService.getTasks(userId);

      final response = await http.get(
        Uri.parse('${taskService.baseUrl}/task-count/$userId'),
        headers: {
          'Authorization': 'Bearer ${taskService.userProvider.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'tasks': tasks,
          'task_count': data['task_count'] ?? 0,
        };
      } else {
        throw Exception("Failed to fetch task count.");
      }
    } catch (e) {
      throw Exception("Error fetching tasks and task count: $e");
    }
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> taskData) async {
    try {
      // Fetch the current task count and subscription status
      final response = await http.get(
        Uri.parse(
            '${taskService.baseUrl}/task-count/${taskService.userProvider.userId}'),
        headers: {
          'Authorization': 'Bearer ${taskService.userProvider.token}',
          'Content-Type': 'application/json',
        },
      );
      print(response.body);

      if (response.statusCode == 400 || response.statusCode == 500) {
        throw Exception('Failed to fetch task count.');
      }

      final data = json.decode(response.body);
      final int taskCount = data['task_count'] ?? 0;
      final bool isSubscribed =
          userProvider.user!['subscription_status'] ?? false;
      //userProvider.user!['subscription_status'] ? 'Active' : 'Inactive'

      // Check if task creation is allowed
      if (!isSubscribed && taskCount >= 100) {
        throw Exception(
            'Task creation limit reached. Please subscribe to add more tasks.');
      }
      print(taskCount);
      // Create the task
      final newTask = await taskService.createTask(taskData);

      // Update or create the task count
      // Task count is not 0; send PUT request
      final putResponse = await http.put(
        Uri.parse(
            '${taskService.baseUrl}/task-count/${taskService.userProvider.userId}'),
        headers: {
          'Authorization': 'Bearer ${taskService.userProvider.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode({'incrementBy': 1}),
      );

      if (putResponse.statusCode != 200) {
        throw Exception('Failed to update task count.');
      }

      return newTask;
    } catch (e) {
      throw Exception('Error in TaskLimitProxy: $e');
    }
  }

  Future<Map<String, dynamic>> updateTask(
      String id, Map<String, dynamic> updates) async {
    return await taskService.updateTask(id, updates);
  }

  Future<void> deleteTask(String id) async {
    try {
      await taskService.deleteTask(id);
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }
}
