import 'note_decorator.dart';
import 'note.dart';

class ChecklistDecorator extends Note {
  final Note note;
  final List<Map<String, dynamic>> checklist;

  ChecklistDecorator(this.note, this.checklist);

  @override
  String getTitle() => note.getTitle();

  @override
  String getDescription() => note.getDescription();

  @override
  List<Map<String, dynamic>> getChecklist() => checklist;

  @override
  DateTime? getReminderTime() => note.getReminderTime();

  @override
  bool isPinned() => note.isPinned();

}
