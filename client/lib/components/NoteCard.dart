import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/note_service.dart';

class NoteCard extends StatefulWidget {
  final Map<String, dynamic> note;
  final VoidCallback onView;
  final VoidCallback onPinToggle;
  final String noteId;

  const NoteCard({
    Key? key,
    required this.note,
    required this.onView,
    required this.onPinToggle,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final NoteService noteService = NoteService();

  String formatReminderTime(dynamic reminderData) {
    try {
      // Handle different possible reminder data formats
      if (reminderData == null) return '';

      // If reminderData is a list, take the first item
      if (reminderData is List && reminderData.isNotEmpty) {
        reminderData = reminderData[0];
      }

      // Check if reminderData has a 'reminder_time' key
      String? reminderTimeString;

      if (reminderData is Map) {
        reminderTimeString = reminderData['reminder_time'];
      } else if (reminderData is String) {
        reminderTimeString = reminderData;
      }

      // If no valid reminder time, return empty string
      if (reminderTimeString == null ||
          reminderTimeString == 'No reminder' ||
          reminderTimeString.isEmpty) {
        return '';
      }

      // Try parsing with multiple potential formats
      DateTime? reminderDate;

      // List of potential parsing formats
      final parseAttempts = [
        () => DateTime.parse(reminderTimeString!),
        () => DateTime.tryParse(reminderTimeString!) ?? DateTime.now(),
        () => DateFormat('yyyy-MM-dd HH:mm:ss').parse(reminderTimeString!),
        () => DateFormat('yyyy-MM-dd HH:mm a').parse(reminderTimeString!),
        () => DateFormat('yyyy-MM-dd').parse(reminderTimeString!),
      ];

      for (var parseAttempt in parseAttempts) {
        try {
          reminderDate = parseAttempt();
          break;
        } catch (e) {
          // Continue to next parsing attempt
          print('Date parse attempt failed: $e');
          continue;
        }
      }

      // If no successful parse, return empty string
      if (reminderDate == null) {
        print('Could not parse reminder time: $reminderTimeString');
        return '';
      }

      // Format the date
      return "${reminderDate.toLocal()}".split(' ')[0] +
          " ${reminderDate.toLocal().toString().split(' ')[1]}";
    } catch (e) {
      print("Error formatting reminder time: $e");
      return '';
    }
  }

  // Method to handle note deletion
  void deleteNote(BuildContext context) async {
    try {
      await noteService.deleteNote(
          widget.noteId); // Call the deleteNote method from NoteService
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String reminderTimeFormatted = formatReminderTime(
        widget.note['reminders'] ?? widget.note['reminder_time']);

    return GestureDetector(
      onTap: widget.onView,
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.note['title'] ?? 'Untitled',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      (widget.note['is_pinned'] ?? false)
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      color: (widget.note['is_pinned'] ?? false)
                          ? Colors.orange
                          : Colors.grey,
                    ),
                    onPressed: widget.onPinToggle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        deleteNote(context), // Pass context to deleteNote
                  )
                ],
              ),
              const SizedBox(height: 4.0),
              // Show description or checklist based on the note
              if (widget.note['description'] != null &&
                  widget.note['description'].isNotEmpty)
                Text(
                  widget.note['description'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14.0),
                ),
              if ((widget.note['checklists'] ?? widget.note['checklist']) !=
                      null &&
                  (widget.note['checklists'] ?? widget.note['checklist'])
                      .isNotEmpty)
                Column(
                  children: [
                    for (var item in (widget.note['checklists'] ??
                        widget.note['checklist']))
                      Row(
                        children: [
                          Icon(
                            item['completed']
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color:
                                item['completed'] ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item['item'])),
                        ],
                      ),
                  ],
                ),
              // Show reminder time if reminder exists
              if (reminderTimeFormatted.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.alarm, size: 14, color: Colors.orange),
                      const SizedBox(width: 4.0),
                      Text(
                        reminderTimeFormatted,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
