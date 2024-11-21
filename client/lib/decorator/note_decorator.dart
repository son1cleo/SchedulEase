import 'note.dart';

abstract class NoteDecorator implements Note {
  final Note note;

  NoteDecorator(this.note);

  @override
  String getTitle() => note.getTitle();

  @override
  String getDescription() => note.getDescription();

  @override
  DateTime? getReminderTime() => note.getReminderTime();

  @override
  bool isPinned() => note.isPinned();
}
