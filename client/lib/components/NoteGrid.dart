import 'package:flutter/material.dart';
import 'NoteCard.dart';

class NoteGrid extends StatelessWidget {
  final List<dynamic> notes;
  final Function(dynamic note) onView;
  final Function(dynamic note) onPinToggle; // Add onPinToggle callback

  const NoteGrid({
    Key? key,
    required this.notes,
    required this.onView,
    required this.onPinToggle, // Include onPinToggle as required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          createdAtFormatted: note['created_at'], // Pass formatted date
          onView: () => onView(note),
          onPinToggle: () => onPinToggle(note), // Pass onPinToggle callback
        );
      },
    );
  }
}
