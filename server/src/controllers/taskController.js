// Create a new task
const mongoose = require('mongoose');

const Task= require('../models/task');
exports.createTask = async (req, res) => {
  try {
    const { user_id, title, type, details, schedule_date, schedule_time, status } = req.body;
     
    // Validate required fields
    if (!Array.isArray(schedule_time) || !schedule_time.every(t => typeof t === 'string')) {
      return res.status(400).json({ message: "Invalid 'schedule_time' format. It should be an array of strings." });
    }
    

    const task = new Task({
      user_id,
      title,
      type,
      details,
      schedule_date,
      schedule_time,
      status,
    });

    await task.save();
    res.status(201).json(task);
  } catch (err) {
    console.error("Error creating task:", err.message);
    res.status(400).json({ message: `Failed to create task: ${err.message}` });
  }
};


// Update a task
exports.updateTask = async (req, res) => {
  const { id } = req.params;
  const updates = req.body;

  // Validate ObjectId
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid task ID' });
  }

  try {
    const task = await Task.findByIdAndUpdate(id, updates, { new: true });
    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }
    res.json(task);
  } catch (err) {
    console.error("Error updating task:", err.message);
    res.status(400).json({ message: `Failed to update task: ${err.message}` });
  }
};
exports.getTasks = async (req, res) => {
  const { user_id } = req.params;

  if (!mongoose.Types.ObjectId.isValid(user_id)) {
    return res.status(400).json({ message: 'Invalid user ID' });
  }

  try {
    const tasks = await Task.find({ user_id }).sort({ createdAt: -1 });
    if (tasks.length === 0) {
      return res.status(404).json({ message: 'No tasks found for this user' });
    }
    res.status(200).json(tasks);
  } catch (error) {
    console.error("Error fetching tasks:", error.message);
    res.status(500).json({ message: `Error fetching tasks: ${error.message}` });
  }
};

// Delete a task
exports.deleteTask = async (req, res) => {
  const { id } = req.params;

  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(400).json({ message: 'Invalid task ID' });
  }

  try {
    const task = await Task.findByIdAndDelete(id);
    if (!task) {
      return res.status(404).json({ message: 'Task not found' });
    }
    res.json({ message: 'Task deleted successfully' });
  } catch (err) {
    console.error("Error deleting task:", err.message);
    res.status(500).json({ message: `Failed to delete task: ${err.message}` });
  }
};