import 'package:flutter/material.dart';

class NoteGrid extends StatelessWidget {
  final List<dynamic> notes;
  final Function(dynamic) onView;
  final Function(dynamic) onPinToggle;

  NoteGrid(
      {required this.notes, required this.onView, required this.onPinToggle});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () => onView(note),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListTile(
                  title: Text(note.getTitle()),
                  subtitle: Text(note.getDescription()),
                ),
                IconButton(
                  icon: Icon(
                    note.isPinned() ? Icons.push_pin : Icons.push_pin_outlined,
                  ),
                  onPressed: () => onPinToggle(note),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
