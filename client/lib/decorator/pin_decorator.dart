import 'note_decorator.dart';
import 'note.dart';

class PinDecorator extends NoteDecorator {
  PinDecorator(Note note) : super(note);

  @override
  bool isPinned() => true;
}
