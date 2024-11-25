import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:client/widgets/note_grid.dart';
import '../components/NoteGrid.dart';
import '../components/NoteDialog.dart';
import '../services/note_service.dart';
import '../providers/user_provider.dart';

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

      print('Fetched notes: $fetchedNotes');
      print('Mapped notes: $notes');

      setState(() {
        notes = fetchedNotes.map((note) {
          final reminder = fetchedReminders.firstWhere(
            (r) => r['note_id'] == note['_id'],
            orElse: () => null,
          );
          return {...note, 'reminder_time': reminder?['reminder_time']};
        }).toList();
        filteredNotes = notes; // Ensure the filtered list is updated
      });

      print('Notes after mapping: $notes');
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
          final title = note.getTitle().toLowerCase();
          final description = note.getDescription().toLowerCase();
          return title.contains(query.toLowerCase()) ||
              description.contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Future<void> addNote(String title, String description, bool isPinned,
      DateTime? reminderTime) async {
    try {
      final userId =
          Provider.of<UserProvider>(context, listen: false).user?['_id'];
      if (userId == null) return;

      final noteData = {
        'user_id': userId,
        'title': title,
        'description': description,
        'is_pinned': isPinned,
        'reminder_time': reminderTime?.toIso8601String(),
      };

      await noteService.createNote(noteData);
      await fetchNotes();
    } catch (e) {
      print('Error adding note: $e');
    }
  }

  Future<void> editNote(String noteId, String title, String description,
      bool isPinned, DateTime? reminderTime) async {
    try {
      final noteData = {
        'title': title,
        'description': description,
        'is_pinned': isPinned,
        'reminder_time': reminderTime?.toIso8601String(),
      };

      await noteService.updateNote(noteId, noteData);
      await fetchNotes();
    } catch (e) {
      print('Error editing note: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await noteService.deleteNote(noteId);
      await fetchNotes();
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  Future<void> addReminder(String noteId, DateTime reminderTime) async {
    try {
      final userId =
          Provider.of<UserProvider>(context, listen: false).user?['_id'];
      if (userId == null) return;

      final reminderData = {
        'user_id': userId,
        'note_id': noteId,
        'reminder_time': reminderTime.toIso8601String(),
      };

      await noteService.createReminder(reminderData);
      fetchNotes();
    } catch (e) {
      print('Error adding reminder: $e');
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
              filterNotes(''); // Reset the filtered list
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
                    noteId: note['_id'], // Add `_id` to BasicNote if needed
                    title: note.getTitle(),
                    description: note.getDescription(),
                    isPinned: note.isPinned(),
                    reminderTime: note.getReminderTime(),
                    onSave: (title, description, isPinned, reminderTime) {
                      editNote(note['_id'], title, description, isPinned,
                          reminderTime);
                    },
                    onDelete: () => deleteNote(note['_id']),
                  ),
                );
              },
              onPinToggle: (note) async {
                final updatedNote = {...note, 'is_pinned': !note['is_pinned']};
                await noteService.updateNote(
                    note['_id'], updatedNote.cast<String, dynamic>());
                fetchNotes(); // Refresh notes
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => NoteDialog(
              onSave: (title, description, isPinned, reminderTime) {
                addNote(title, description, isPinned, reminderTime);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
