import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final dynamic note;
  final String createdAtFormatted;
  final Function onEdit;
  final Function onDelete;

  const NoteCard({
    Key? key,
    required this.note,
    required this.createdAtFormatted,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note['title'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(createdAtFormatted, style: TextStyle(fontSize: 12)),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
