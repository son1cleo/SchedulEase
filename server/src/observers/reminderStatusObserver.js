const ReminderObserver = require('./reminderObserver');

class ReminderStatusObserver extends ReminderObserver {
  update(status) {
    // Handle the logic to update the status of the note/task
    if (status instanceof NoteReminder) {
      // Update note status based on the reminder time (To-Do, Completed, Overdue)
      console.log('Note Reminder Status:', status.status);
    }

    if (status instanceof ScheduleReminder) {
      // Update schedule task status based on the reminder time (To-Do, Overdue)
      console.log('Schedule Task Status:', status.status);
    }
  }
}

module.exports = ReminderStatusObserver;
