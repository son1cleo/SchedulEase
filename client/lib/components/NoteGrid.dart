import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/NoteCard.dart';

class NoteGrid extends StatelessWidget {
  final List<dynamic> notes;
  final Function onEdit;
  final Function onDelete;

  const NoteGrid({
    Key? key,
    required this.notes,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.2,
      ),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        final createdAtFormatted =
            DateFormat.yMMMd().format(DateTime.parse(note['created_at']));
        return NoteCard(
          note: note,
          createdAtFormatted: createdAtFormatted,
          onEdit: () => onEdit(note),
          onDelete: () => onDelete(note['_id']),
        );
      },
    );
  }
}
