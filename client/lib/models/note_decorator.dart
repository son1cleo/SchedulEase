// lib/models/note_decorator.dart
import 'note.dart';

abstract class NoteDecorator extends Note {
  final Note note;

  NoteDecorator(this.note);

  @override
  String getContent() {
    return note.getContent();
  }
}
