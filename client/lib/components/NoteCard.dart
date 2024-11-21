import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final dynamic note;
  final String createdAtFormatted;
  final VoidCallback onView;
  final VoidCallback onPinToggle; // Add onPinToggle callback

  const NoteCard({
    Key? key,
    required this.note,
    required this.createdAtFormatted,
    required this.onView,
    required this.onPinToggle, // Include onPinToggle as required
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onView,
      child: Card(
        elevation: 3.0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    note['title'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(
                      note['is_pinned'] ? Icons.push_pin : Icons.push_pin_outlined,
                      color: Colors.orange,
                    ),
                    onPressed: onPinToggle, // Call onPinToggle when tapped
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              Expanded(
                child: Text(
                  note['description'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (note['reminder_time'] != null)
                Row(
                  children: [
                    Icon(Icons.alarm, size: 14, color: Colors.orange),
                    SizedBox(width: 4.0),
                    Text(
                      note['reminder_time'],
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              Spacer(),
              Text(createdAtFormatted, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
