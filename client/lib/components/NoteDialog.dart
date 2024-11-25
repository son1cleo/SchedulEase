import 'package:flutter/material.dart';

class NoteDialog extends StatefulWidget {
  final String? noteId;
  final String? title;
  final String? description;
  final bool? isPinned;
  final DateTime? reminderTime; // This will hold the reminder time
  final Function(String title, String description, bool isPinned,
      DateTime? reminderTime) onSave;
  final VoidCallback? onDelete;

  const NoteDialog({
    Key? key,
    this.noteId,
    this.title,
    this.description,
    this.isPinned = false,
    this.reminderTime, // Initialize reminderTime
    required this.onSave,
    this.onDelete,
  }) : super(key: key);

  @override
  _NoteDialogState createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  late String title;
  late String description;
  late bool isPinned;
  DateTime? reminderTime;

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    title = widget.title ?? '';
    description = widget.description ?? '';
    isPinned = widget.isPinned ?? false;
    reminderTime = widget.reminderTime; // Set reminderTime from widget

    // Initialize controllers only once
    titleController = TextEditingController(text: title);
    descriptionController = TextEditingController(text: description);
  }

  @override
  void dispose() {
    // Dispose the controllers to avoid memory leaks
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void pickReminderTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: reminderTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(reminderTime ?? DateTime.now()),
      );

      if (time != null) {
        setState(() {
          reminderTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.noteId == null ? 'Add Note' : 'Edit Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
            onChanged: (value) => title = value,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
            onChanged: (value) => description = value,
          ),
          Row(
            children: [
              Checkbox(
                value: isPinned,
                onChanged: (value) {
                  setState(() {
                    isPinned = value ?? false;
                  });
                },
              ),
              Text('Pin Note'),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.alarm),
                onPressed: pickReminderTime,
              ),
              if (reminderTime != null)
                Text(
                    '${reminderTime!.year}-${reminderTime!.month}-${reminderTime!.day} ${reminderTime!.hour}:${reminderTime!.minute}'),
            ],
          ),
        ],
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: widget.onDelete,
            child: const Text('Delete'),
          ),
        TextButton(
          onPressed: () {
            widget.onSave(title, description, isPinned, reminderTime);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
