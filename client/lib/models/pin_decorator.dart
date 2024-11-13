// lib/models/pin_decorator.dart
import 'note_decorator.dart';

class PinDecorator extends NoteDecorator {
  PinDecorator(Note note) : super(note);

  @override
  String getContent() {
    return '${super.getContent()}\nStatus: Pinned';
  }
}
