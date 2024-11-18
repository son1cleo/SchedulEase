import 'package:http/http.dart' as http;
import 'dart:convert';

class NoteService {

  final String apiUrl = 'http://localhost:5000/notes'; // Backend URL

  // Fetch notes
  Future<List<dynamic>> fetchNotes(String userId) async {
    final response = await http.get(Uri.parse('$apiUrl/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch notes');
    }
  }

  // Create a note
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


  // Update a note
  Future<void> updateNote(String noteId, Map<String, dynamic> updateData) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$noteId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updateData),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
  }


  // Delete a note
  Future<void> deleteNote(String noteId) async {
    final response = await http.delete(Uri.parse('$apiUrl/$noteId'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete note');
    }
  }
}

