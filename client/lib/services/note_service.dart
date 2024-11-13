// lib/services/note_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteService {
  final String apiUrl = 'http://localhost:5500/notes';

  Future<void> createNote(Map<String, dynamic> noteData) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(noteData),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create note');
    }
  }

  Future<List<dynamic>> fetchNotes(String userId) async {
    final response = await http.get(Uri.parse('$apiUrl/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch notes');
    }
  }

  Future<void> deleteNote(String noteId) async {
    final response = await http.delete(Uri.parse('$apiUrl/$noteId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete note');
    }
  }
}
