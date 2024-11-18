const mongoose = require('mongoose');

const ReminderSchema = new mongoose.Schema({
  user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  note_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Note' }, // Reference to the note
  reminder_time: { type: Date }, // The time for the reminder
  is_sent: { type: Boolean, default: false },
  created_at: { type: Date, default: Date.now },
  updated_at: { type: Date },
});

module.exports = mongoose.model('Reminder', ReminderSchema);
