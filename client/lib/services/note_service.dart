import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteService {
  final String baseUrl = 'http://localhost:5000';

  Future<List<dynamic>> fetchNotes(String userId) async {
    try {
      final Uri url = Uri.parse(
          '$baseUrl/notes/$userId'); // Use user_id to match the backend
      print('Fetching notes from: $url');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        // print('Fetched notes: ${response.body}');
        print('Fetched notes: ${json.decode(response.body)}');
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to fetch notes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notes: $e');
    }
  }

  Future<void> createNote(Map<String, dynamic> noteData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(noteData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create note');
      }
    } catch (e) {
      throw Exception('Error creating note: $e');
    }
  }

  Future<void> updateNote(String noteId, Map<String, dynamic> noteData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/notes/$noteId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(noteData),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update note');
      }
    } catch (e) {
      throw Exception('Error updating note: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/notes/$noteId'),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete note');
      }
    } catch (e) {
      throw Exception('Error deleting note: $e');
    }
  }

  Future<void> createReminder(Map<String, dynamic> reminderData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reminders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reminderData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create reminder');
      }
    } catch (e) {
      throw Exception('Error creating reminder: $e');
    }
  }

  Future<List<dynamic>> fetchReminders(String userId) async {
    try {
      final Uri url = Uri.parse(
          '$baseUrl/reminders/$userId'); // Use user_id to match the backend
      print('Fetching reminders from: $url');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch reminders');
      }
    } catch (e) {
      throw Exception('Error fetching reminders: $e');
    }
  }
}
