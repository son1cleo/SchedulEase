import 'note_decorator.dart';
import 'note.dart';

class ReminderDecorator extends NoteDecorator {
  final DateTime reminderTime;

  ReminderDecorator(Note note, this.reminderTime) : super(note);

  @override
  DateTime? getReminderTime() => reminderTime;

  @override
  List<Map<String, dynamic>> getChecklist() => note.getChecklist();
}
