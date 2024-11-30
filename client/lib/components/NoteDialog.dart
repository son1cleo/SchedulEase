import 'package:flutter/material.dart';

class NoteDialog extends StatefulWidget {
  final String noteId;
  final String title;
  final String description;
  final bool isPinned;
  final DateTime? reminderTime;
  final List<Map<String, dynamic>> checklist;
  final Function(String, String, bool, DateTime?, List<Map<String, dynamic>>)
      onSave;
  final VoidCallback? onDelete;

  const NoteDialog({
    Key? key,
    required this.noteId,
    required this.title,
    required this.description,
    required this.isPinned,
    required this.reminderTime,
    required this.checklist,
    required this.onSave,
    this.onDelete,
  }) : super(key: key);

  @override
  _NoteDialogState createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> checklist = [];
  bool isPinned = false;
  DateTime? reminderTime; // Will store reminder time

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    descriptionController.text = widget.description;
    checklist = widget.checklist;
    isPinned = widget.isPinned;
    reminderTime = widget.reminderTime; // Initialize reminder time
  }

  // Method to update a checklist item
  void updateChecklistItem(int index, String value) {
    setState(() {
      checklist[index]['item'] = value; // Update the checklist item text
    });
  }

  // Method to remove a checklist item
  void removeChecklistItem(int index) {
    setState(() {
      checklist.removeAt(index); // Remove the checklist item from the list
    });
  }

  // Method to add a new checklist item
  void addChecklistItem() {
    setState(() {
      checklist.add(
          {'item': '', 'completed': false}); // Add a new empty checklist item
    });
  }

  // Show the Date and Time Picker to select reminder time
  void pickReminderTime() async {
    DateTime? pickedTime = await showDatePicker(
      context: context,
      initialDate: reminderTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedTime != null) {
      TimeOfDay? pickedTimeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(reminderTime ?? DateTime.now()),
      );

      if (pickedTimeOfDay != null) {
        setState(() {
          reminderTime = DateTime(
            pickedTime.year,
            pickedTime.month,
            pickedTime.day,
            pickedTimeOfDay.hour,
            pickedTimeOfDay.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.noteId.isEmpty ? 'New Note' : 'Edit Note'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              autofocus: true,
            ),
            // Description field, shown if not in checklist mode
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),
            // Checklist section
            Column(
              children: [
                for (int i = 0; i < checklist.length; i++)
                  Row(
                    children: [
                      Checkbox(
                        value: checklist[i]['completed'],
                        onChanged: (_) {
                          setState(() {
                            checklist[i]['completed'] =
                                !checklist[i]['completed'];
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (value) => updateChecklistItem(i, value),
                          controller: TextEditingController(
                            text: checklist[i]['item'],
                          ),
                          decoration: InputDecoration(
                            hintText: 'Checklist item',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => removeChecklistItem(i),
                      ),
                    ],
                  ),
                TextButton(
                  onPressed: addChecklistItem,
                  child: Text('Add Checklist'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pin Note'),
                Checkbox(
                  value: isPinned,
                  onChanged: (value) {
                    setState(() {
                      isPinned = value ?? false;
                    });
                  },
                ),
              ],
            ),
            // Display and update reminder time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reminder Time:'),
                TextButton(
                  onPressed: pickReminderTime,
                  child: Text(reminderTime != null
                      ? "${reminderTime!.toLocal()}".split(' ')[0] +
                          " " +
                          reminderTime!.toLocal().toString().split(' ')[1]
                      : "Pick Time"),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        if (widget.onDelete != null)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        TextButton(
          onPressed: () {
            widget.onSave(
              titleController.text,
              descriptionController.text,
              isPinned,
              reminderTime, // Save reminder time
              checklist,
            );
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
