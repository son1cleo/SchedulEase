import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/providers/user_provider.dart'; // Import the UserProvider

class TaskService {
  final String baseUrl = "http://localhost:5000/api/tasks";
  final UserProvider userProvider; // Dependency injection of UserProvider
  TaskService({required this.userProvider});

  Future<List<Map<String, dynamic>>> getTasks() async {
    try {
      final userId = userProvider.userId; // Fetch userId from UserProvider
      final response = await http.get(
        Uri.parse('$baseUrl?userId=$userId'),
      );
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception("Failed to load tasks");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> taskData) async {
    try {
      taskData['userId'] = userProvider.userId; // Attach the userId to the task
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(taskData),
      );
      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to create task");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<Map<String, dynamic>> updateTask(
      String id, Map<String, dynamic> updates) async {
    try {
      updates['userId'] = userProvider.userId; // Attach userId to updates
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updates),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to update task");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      final userId = userProvider.userId; // Fetch userId
      final response = await http.delete(
        Uri.parse('$baseUrl/$id?userId=$userId'),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to delete task");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
