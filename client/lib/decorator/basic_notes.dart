// lib/models/basic_note.dart
import 'note.dart';

class BasicNote implements Note {
  final String title;
  final String description;
  final DateTime? reminderTime;

  BasicNote({
    required this.title,
    required this.description,
    this.reminderTime,
  });

  @override
  String getTitle() => title;

  @override
  String getDescription() => description;

  @override
  DateTime? getReminderTime() => reminderTime;

  @override
  bool isPinned() => false;

  @override
  List<Map<String, dynamic>> getChecklist() => [];
}
