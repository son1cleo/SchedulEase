abstract class Note {
  String getTitle();
  String getDescription();
  DateTime? getReminderTime();
  bool isPinned();
  List<Map<String, dynamic>> getChecklist(); // Checklist method
}
