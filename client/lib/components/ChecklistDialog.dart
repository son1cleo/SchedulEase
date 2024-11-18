import 'package:flutter/material.dart';

class ChecklistDialog extends StatelessWidget {
  final String noteId;
  final Function(String) onAddItem;

  const ChecklistDialog({
    Key? key,
    required this.noteId,
    required this.onAddItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String content = '';

    return AlertDialog(
      title: Text('Add Checklist Item'),
      content: TextField(
        decoration: InputDecoration(labelText: 'Checklist Item'),
        onChanged: (value) {
          content = value;
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (content.isNotEmpty) {
              onAddItem(content);
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
