import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  final String? noteId;
  final String? title;
  final String? description;
  final bool isPinned;
  final DateTime? reminderTime;
  final Function(String, String, bool, DateTime?) onSave;

  const NoteDialog({
    Key? key,
    this.noteId,
    this.title,
    this.description,
    this.isPinned = false,
    this.reminderTime,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dialogTitle = title ?? '';
    String dialogDescription = description ?? '';
    bool dialogPinned = isPinned;
    DateTime? dialogReminderTime = reminderTime;

    return AlertDialog(
      title: Text(noteId == null ? 'Add Note' : 'Edit Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(labelText: 'Title'),
            controller: TextEditingController(text: dialogTitle),
            onChanged: (value) => dialogTitle = value,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Description'),
            controller: TextEditingController(text: dialogDescription),
            onChanged: (value) => dialogDescription = value,
          ),
          Row(
            children: [
              Checkbox(
                value: dialogPinned,
                onChanged: (value) => dialogPinned = value!,
              ),
              Text('Pin this note'),
            ],
          ),
          TextButton.icon(
            icon: Icon(Icons.alarm),
            label: Text(
                dialogReminderTime == null ? 'Set Reminder' : dialogReminderTime.toString()),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: dialogReminderTime ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (selectedTime != null) {
                  dialogReminderTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                }
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => onSave(dialogTitle, dialogDescription, dialogPinned, dialogReminderTime),
          child: Text(noteId == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
