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

        // Safely extract and format created_at
        final createdAtFormatted = note['created_at'] != null
            ? formatDateTime(note['created_at'])
            : 'N/A';

        return NoteCard(
          note: note,
          createdAtFormatted: createdAtFormatted,
          onView: () => onView(note),
          onPinToggle: () => onPinToggle(note),
        );
      },
    );
  }

  /// Helper function to format the `created_at` field
  String formatDateTime(dynamic date) {
    try {
      if (date is String) {
        // Parse and format if the date is a String
        return DateTime.parse(date).toLocal().toString(); // Adjust as needed
      } else if (date is DateTime) {
        return date.toLocal().toString(); // Adjust as needed
      }
    } catch (e) {
      print('Error formatting date: $e');
    }
    return 'Invalid date';
  }
}
