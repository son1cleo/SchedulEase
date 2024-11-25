// lib/models/basic_note.dart
import 'note.dart';

class BasicNote extends Note {
  final String title;
  final String description;
  final DateTime? createdAt;

  BasicNote({ required this.title, required this.description, this.createdAt});

  @override
  String getTitle() => title;

  @override
  String getDescription() => description;

  @override
  DateTime? getReminderTime() => createdAt;

  @override
  bool isPinned() => false;
}
