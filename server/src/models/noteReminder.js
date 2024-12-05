const mongoose = require('mongoose');

const NoteReminderSchema = new mongoose.Schema({
  note_id: { type: mongoose.Schema.Types.ObjectId, ref: 'Note', required: true },
  reminder_time: { type: Date, required: true },
});

module.exports = mongoose.model('NoteReminder', NoteReminderSchema);
