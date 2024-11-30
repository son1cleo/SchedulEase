// lib/services/checklist_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChecklistService {
  final String apiUrl = 'http://localhost:5000/checklist'; // Update with your backend URL

  Future<List<dynamic>> fetchChecklist(String noteId) async {
    final response = await http.get(Uri.parse('$apiUrl/$noteId'));
    if (response.statusCode == 204) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch checklist');
    }
  }

  Future<void> createChecklistItem(String noteId, String content) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'note_id': noteId, 'content': content}),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to create checklist item');
    }
  }

  Future<void> updateChecklistItem(String id, bool isChecked) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'is_checked': isChecked}),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update checklist item');
    }
  }

  Future<void> deleteChecklistItem(String id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete checklist item');
    }
  }
}
