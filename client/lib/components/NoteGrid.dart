import 'package:flutter/material.dart';
import 'NoteCard.dart';

class NoteGrid extends StatelessWidget {
  final List<dynamic> notes;
  final Function(dynamic note) onView;
  final Function(dynamic note) onPinToggle;

  const NoteGrid({
    Key? key,
    required this.notes,
    required this.onView,
    required this.onPinToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        final noteId = note['_id']; // Extract noteId from the note data

        return NoteCard(
          note: note,
          onView: () => onView(note),
          onPinToggle: () => onPinToggle(note),
          noteId: noteId, // Pass the noteId to NoteCard
        );
      },
    );
  }
}
