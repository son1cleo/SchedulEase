import 'note_decorator.dart';
import 'note.dart';

class ReminderDecorator extends NoteDecorator {
  final DateTime reminderTime;

  ReminderDecorator(Note note, this.reminderTime) : super(note);

  @override
  DateTime? getReminderTime() => reminderTime;
}
