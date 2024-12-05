const mongoose = require('mongoose');

const ScheduleReminderSchema = new mongoose.Schema({
  task_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Task', required: true },
  due_date: { type: Date, required: true },
  status: { type: String, default: 'To-Do' }, // To-Do, Completed, Overdue
});

module.exports = mongoose.model('ScheduleReminder', ScheduleReminderSchema);
