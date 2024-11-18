import 'dart:convert';

import 'package:flutter/material.dart';
import '../components/NoteGrid.dart';
import '../components/NoteDialog.dart';
import '../services/note_service.dart';
import 'package:client/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class KeepNoteScreen extends StatefulWidget {
  @override
  _KeepNoteScreenState createState() => _KeepNoteScreenState();
}

class _KeepNoteScreenState extends State<KeepNoteScreen> {
  final NoteService noteService = NoteService();
  List<dynamic> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  // Fetch notes from the backend
  Future<void> fetchNotes() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).user?['_id'];
      if (userId == null) {
        print('User ID is null. Cannot fetch notes.');
        return;
      }

      final fetchedNotes = await noteService.fetchNotes(userId);
      setState(() {
        notes = fetchedNotes;
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  // Add a new note
Future<void> addNote(String title, String description, bool isPinned, DateTime? reminderTime) async {
  try {
    final userId = Provider.of<UserProvider>(context, listen: false).user?['_id'];

    if (userId == null) {
      print('User ID is null. Cannot add note.');
      return;
    }

    final noteData = {
      'user_id': userId,
      'title': title,
      'description': description,
      'is_pinned': isPinned,
      'reminder_time': reminderTime?.toIso8601String(), // Convert DateTime to ISO string
    };

    await http.post(
      Uri.parse('http://localhost:5000/notes/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(noteData),
    );

    await fetchNotes(); // Refresh notes after adding
  } catch (e) {
    print('Error adding note: $e');
  }
}

  // Edit an existing note
Future<void> editNote(String noteId, String title, String description, bool isPinned,
    DateTime? reminderTime) async {
  try {
    final noteData = {
      'title': title,
      'description': description,
      'is_pinned': isPinned,
      'reminder_time': reminderTime?.toIso8601String(),
    };

    await noteService.updateNote(noteId, noteData);
    await fetchNotes(); // Refresh the notes
  } catch (e) {
    print('Error editing note: $e');
  }
}

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    try {
      await noteService.deleteNote(noteId);
      await fetchNotes();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('KeepNote')),
      body: NoteGrid(
        notes: notes,
        onEdit: (note) {
          showDialog(
            context: context,
            builder: (BuildContext context) => NoteDialog(
              noteId: note['_id'],
              title: note['title'],
              description: note['description'],
              isPinned: note['is_pinned'],
              reminderTime: note['reminder_time'] != null
                  ? DateTime.parse(note['reminder_time'])
                  : null,
              onSave: (title, description, isPinned, reminderTime) {
                editNote(note['_id'], title, description, isPinned, reminderTime);
              },
            ),
          );
        },
        onDelete: deleteNote,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => NoteDialog(
              onSave: (title, description, isPinned, reminderTime) {
                addNote(title, description, isPinned, reminderTime);
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
