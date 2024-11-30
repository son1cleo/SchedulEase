import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/note_service.dart';
import '../providers/user_provider.dart';
import '../components/NoteGrid.dart';
import '../components/NoteDialog.dart';

class KeepNoteScreen extends StatefulWidget {
  @override
  _KeepNoteScreenState createState() => _KeepNoteScreenState();
}

class _KeepNoteScreenState extends State<KeepNoteScreen> {
  final NoteService noteService = NoteService();
  List<dynamic> notes = [];
  List<dynamic> filteredNotes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      final userId =
          Provider.of<UserProvider>(context, listen: false).user?['_id'];
      if (userId == null) return;

      final fetchedNotes = await noteService.fetchNotes(userId);
      final fetchedReminders = await noteService.fetchReminders(userId);

      setState(() {
        notes = List<Map<String, dynamic>>.from(fetchedNotes.map((note) {
          final reminder = fetchedReminders.firstWhere(
            (r) => r['note_id'] == note['_id'],
            orElse: () => null,
          );

          return {
            ...Map<String, dynamic>.from(note),
            'reminder_time': reminder?['reminder_time'] ??
                'No reminder', // Make sure it's a string
            'description': note['description'] ?? '',
            'checklist': note['checklist'] != null
                ? List<Map<String, dynamic>>.from(note['checklist'])
                : [],
          };
        }).toList());

        filteredNotes = notes;
      });
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  void filterNotes(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredNotes = notes;
      });
    } else {
      setState(() {
        filteredNotes = notes.where((note) {
          final title = (note['title'] ?? '').toString().toLowerCase();
          final description =
              (note['description'] ?? '').toString().toLowerCase();
          return title.contains(query.toLowerCase()) ||
              description.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> addNote(String title, String description, bool isPinned,
      DateTime? reminderTime, List<Map<String, dynamic>> checklist) async {
    try {
      final userId =
          Provider.of<UserProvider>(context, listen: false).user?['_id'];
      if (userId == null) return;

      final noteData = {
        'user_id': userId,
        'title': title,
        'description': description,
        'checklist': checklist.map((item) {
          return {
            'item': item['item'],
            'completed': item['completed'] ?? false,
          };
        }).toList(),
        'is_pinned': isPinned,
        'reminder_time': reminderTime?.toIso8601String(),
      };

      await noteService.createNote(noteData);
      await fetchNotes();
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  Future<void> editNote(
      String noteId,
      String title,
      String description,
      bool isPinned,
      DateTime? reminderTime,
      List<Map<String, dynamic>> checklist) async {
    try {
      final noteData = {
        'title': title,
        'description': description,
        'checklist': checklist
            .map((item) => {
                  'item': item['item'], // Ensure 'item' is present
                  'completed': item['completed'] ?? false,
                })
            .toList(),
        'is_pinned': isPinned,
        'reminder_time': reminderTime?.toIso8601String(),
      };

      await noteService.updateNote(noteId, noteData);
      await fetchNotes(); // Refresh notes after update
    } catch (e) {
      print('Error editing note: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await noteService.deleteNote(
          noteId); // This deletes the note, reminders, and checklists
      await fetchNotes(); // Refresh notes list after deletion
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  Future<void> pinNote(String noteId, bool isPinned) async {
    try {
      await noteService.updateNote(noteId, {'is_pinned': !isPinned});
      await fetchNotes(); // Re-fetch the notes after pin/unpin
    } catch (e) {
      print('Error pinning note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search notes...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (query) => filterNotes(query),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
              filterNotes('');
            },
          ),
        ],
      ),
      body: filteredNotes.isEmpty
          ? Center(child: Text('No notes available'))
          : NoteGrid(
              notes: filteredNotes,
              onView: (note) {
                showDialog(
                  context: context,
                  builder: (context) => NoteDialog(
                    noteId: note['_id'],
                    title: note['title'] ?? '',
                    description: note['description'] ?? '',
                    isPinned: note['is_pinned'] ?? false,
                    reminderTime: note['reminder_time'] != null
                        ? DateTime.parse(note['reminder_time'])
                        : null,
                    checklist: note['checklist'] ?? [],
                    onSave: (title, description, isPinned, reminderTime,
                        checklist) {
                      editNote(note['_id'], title, description, isPinned,
                          reminderTime, checklist);
                    },
                    onDelete: () => deleteNote(note['_id']),
                  ),
                );
              },
              onPinToggle: (note) async {
                final updatedNote = {...note, 'is_pinned': !note['is_pinned']};
                await noteService.updateNote(
                    note['_id'], updatedNote.cast<String, dynamic>());
                fetchNotes();
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => NoteDialog(
              noteId: '',
              title: '',
              description: '',
              isPinned: false,
              reminderTime: null,
              checklist: [],
              onSave: (title, description, isPinned, reminderTime, checklist) {
                addNote(title, description, isPinned, reminderTime, checklist);
              },
              onDelete: () {},
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
