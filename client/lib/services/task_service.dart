import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/providers/user_provider.dart'; // Import the UserProvider

class TaskService {
  final String baseUrl = "http://localhost:5000/api/tasks";
  final UserProvider userProvider; // Dependency injection of UserProvider

  TaskService({required this.userProvider});

  // Fetch tasks for the user
  Future<List<Map<String, dynamic>>> getTasks(String userId) async {
    if (userId.isEmpty) {
      throw Exception("User ID is required.");
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/$userId'),
        headers: {
          'Authorization': 'Bearer ${userProvider.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception("Failed to load tasks: ${error['message']}");
      }
    } catch (e) {
      throw Exception("Error fetching tasks: $e");
    }
  }

  // Create a new task at taskSrevice
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> taskData) async {
    try {
      // Add 'user_id' to the task data from the UserProvider
      final taskDataWithUserId = {
        'user_id': userProvider.userId,
        ...taskData, // Spread the remaining task data
      };

      // Validate task details based on type
      if (taskDataWithUserId['type'] == 'Description') {
        if (taskDataWithUserId['details'] is! String) {
          throw Exception("Details for Description type must be a string.");
        }
      } else if (taskDataWithUserId['type'] == 'Checklist') {
        if (taskDataWithUserId['details'] is! List) {
          throw Exception(
              "Details for Checklist type must be a list of objects.");
        }
        // Convert checklist items to a list of objects if they are plain strings
        taskDataWithUserId['details'] = (taskDataWithUserId['details'] as List)
            .map((item) => item is Map<String, dynamic>
                ? item
                : {'item': item, 'completed': false})
            .toList();
      }

      print('Task data being sent: $taskDataWithUserId');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(taskDataWithUserId),
      );

      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception("Failed to create task: ${error['message']}");
      }
    } catch (e) {
      throw Exception("Error creating task: $e");
    }
  }

  Future<Map<String, dynamic>> updateTask(
      String id, Map<String, dynamic> updates) async {
    try {
      // Ensure checklist details are formatted correctly
      if (updates.containsKey('details')) {
        updates['details'] =
            (updates['details'] as List<dynamic>).map((detail) {
          return {
            '_id': detail['_id'],
            'completed': detail['completed'], // Must be a bool
          };
        }).toList();
      }
      print('Updates body: ${updates}');
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updates),
      );
      print('Response body on update: ${response.body}');

      // Handle the response based on status code
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception("Failed to update task: ${error['message']}");
      }
    } catch (e) {
      // Handle any errors that occurred during the request or the process
      throw Exception("Error updating task: $e");
    }
  }

  // Delete a task
  Future<void> deleteTask(String id) async {
    try {
      final userId = userProvider.userId;
      final response = await http.delete(
        Uri.parse('$baseUrl/$id?userId=$userId'),
      );
      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception("Failed to delete task: ${error['message']}");
      }
    } catch (e) {
      throw Exception("Error deleting task: $e");
    }
  }
}
