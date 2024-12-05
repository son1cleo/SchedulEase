const NoteReminder = require('../models/noteReminder');
const ScheduleReminder = require('../models/scheduleReminder');
const ReminderSubject = require('../observers/reminderObserver');

class ReminderService extends ReminderSubject {
  async createNoteReminder(note_id, reminder_time) {
    const reminder = new NoteReminder({
      note_id,
      reminder_time,
    });

    await reminder.save();
    this.notifyObservers(reminder); // Notify all observers
  }

  async createScheduleReminder(task_id, due_date) {
    const reminder = new ScheduleReminder({
      task_id,
      due_date,
    });

    await reminder.save();
    this.notifyObservers(reminder); // Notify all observers
  }

  async updateNoteReminderStatus(reminder_id, status) {
    const reminder = await NoteReminder.findById(reminder_id);
    if (!reminder) return;

    reminder.status = status;
    await reminder.save();
    this.notifyObservers(reminder); // Notify all observers about the status change
  }

  async updateScheduleReminderStatus(reminder_id, status) {
    const reminder = await ScheduleReminder.findById(reminder_id);
    if (!reminder) return;

    reminder.status = status;
    await reminder.save();
    this.notifyObservers(reminder); // Notify all observers about the status change
  }
}

module.exports = ReminderService;
