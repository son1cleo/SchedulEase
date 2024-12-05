const mongoose = require('mongoose');

const TaskCountSchema = new mongoose.Schema({
  user_id: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    required: true, 
    unique: true 
  },
  task_count: { 
    type: Number, 
    default: 0,
    min: 0
  }
});

module.exports = mongoose.model('TaskCount', TaskCountSchema);