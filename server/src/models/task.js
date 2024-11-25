const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema(
  {
    user_id: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    title: { type: String, required: true },
    type: { type: String, enum: ['Checklist', 'Description'], required: true },
    details: {
      type: mongoose.Schema.Types.Mixed, // Supports both string and array
      required: true,
      validate: {
        validator: function (v) {
          if (this.type === 'Checklist' && !Array.isArray(v)) return false;
          if (this.type === 'Description' && typeof v !== 'string') return false;
          return true;
        },
        message: props => `Invalid details for type "${props.value}"`,
      },
    },

    schedule_date: { type: String, required: true },
    schedule_time: { type: [String], required: true },
    status: { type: String, enum: ['To-do', 'Overdue', 'Completed'], default: 'To-do' },
  },
  { context: true } // Enable context for validators
);

module.exports = mongoose.model('Task', taskSchema);
