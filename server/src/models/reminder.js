const mongoose = require('mongoose');

const ReminderSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  note_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Note', required: true }, // Reference to the note
  reminder_time: { type: Date, required: true }, // The time for the reminder
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Reminder', ReminderSchema);
