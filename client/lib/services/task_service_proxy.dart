import 'package:client/services/task_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/providers/user_provider.dart';

class TaskLimitProxy {
  final TaskService taskService;
  final UserProvider userProvider;

  TaskLimitProxy({required this.taskService, required this.userProvider});

  Future<Map<String, dynamic>> getTasks(String userId) async {
    try {
      // Fetch tasks
      final tasks = await taskService.getTasks(userId);

      // Fetch task count
      final response = await http.get(
        Uri.parse('${taskService.baseUrl}/task-count/$userId'),
        headers: {
          'Authorization': 'Bearer ${taskService.userProvider.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final int taskCount = data['task_count'] ?? 0;

        return {
          'tasks': tasks,
          'task_count': taskCount,
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
      // Step 1: Fetch the current task count and subscription status
      final response = await http.get(
        Uri.parse(
            '${taskService.baseUrl}/task-count/${taskService.userProvider.userId}'),
        headers: {
          'Authorization': 'Bearer ${taskService.userProvider.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch task count.');
      }

      final data = json.decode(response.body);
      final int taskCount = data['task_count'] ?? 0;
      final bool isSubscribed =
          userProvider.user!['subscription_status'] ?? false;
      //userProvider.user!['subscription_status'] ? 'Active' : 'Inactive'

      // Step 2: Check if task creation is allowed
      if (!isSubscribed && taskCount >= 3) {
        throw Exception(
            'Task creation limit reached. Please subscribe to add more tasks.');
      }

      // Step 3: Create the task
      final newTask = await taskService.createTask(taskData);

      // Update or create the task count
      if (taskCount == 0) {
        // Task count is 0; send POST request
        final postResponse = await http.post(
          Uri.parse('${taskService.baseUrl}/task-count'),
          headers: {
            'Authorization': 'Bearer ${taskService.userProvider.token}',
            'Content-Type': 'application/json',
          },
          body: json.encode({'user_id': taskService.userProvider.userId}),
        );

        if (postResponse.statusCode != 201) {
          throw Exception('Failed to create task count.');
        }
      } else {
        // Task count is not 0; send PUT request
        final putResponse = await http.put(
          Uri.parse(
              '${taskService.baseUrl}/task-count/${taskService.userProvider.userId}'),
          headers: {
            'Authorization': 'Bearer ${taskService.userProvider.token}',
            'Content-Type': 'application/json',
          },
          body: json.encode({'task_count': taskCount + 1}),
        );

        if (putResponse.statusCode != 200) {
          throw Exception('Failed to update task count.');
        }
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
