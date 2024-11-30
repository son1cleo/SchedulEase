import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final Map<String, dynamic> note; // Ensure note is a Map with expected keys
  final VoidCallback onView;
  final VoidCallback onPinToggle;

  const NoteCard({
    Key? key,
    required this.note,
    required this.onView,
    required this.onPinToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String reminderTimeFormatted = "";
    // Check if reminder time exists and is valid
    if (note['reminder_time'] != null) {
      try {
        DateTime reminderDate = DateTime.parse(note['reminder_time']);
        reminderTimeFormatted = "${reminderDate.toLocal()}".split(' ')[0]; // Formatting the date to display it
      } catch (e) {
        reminderTimeFormatted = "Invalid date";
      }
    }

    return GestureDetector(
      onTap: onView,
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
                      note['title'] ?? 'Untitled',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      (note['is_pinned'] ?? false)
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      color: (note['is_pinned'] ?? false)
                          ? Colors.orange
                          : Colors.grey,
                    ),
                    onPressed: onPinToggle,
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              // Show description or checklist based on the note
              if (note['description'] != null && note['description'].isNotEmpty)
                Text(
                  note['description'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14.0),
                ),
              if (note['checklist'] != null && note['checklist'].isNotEmpty)
                Column(
                  children: [
                    for (var item in note['checklist'])
                      Row(
                        children: [
                          Icon(
                            item['completed']
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: item['completed']
                                ? Colors.green
                                : Colors.grey,
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
                        reminderTimeFormatted, // Display reminder time
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
