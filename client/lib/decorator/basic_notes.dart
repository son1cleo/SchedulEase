// lib/models/basic_note.dart
import 'note.dart';

class BasicNote extends Note {
  final String title;
  final String description;

  BasicNote({required this.title, required this.description});

  @override
  String getContent() {
    return 'Title: $title\nDescription: $description';
  }
}
