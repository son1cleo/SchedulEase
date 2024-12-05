const mongoose = require('mongoose');
const TaskCount = require('../models/task_count');

// Get the task count for a specific user
const getTaskCount = async (req, res) => {
  const { userId } = req.params;

  try {
    const taskCount = await TaskCount.findOne({ user_id: userId });
    if (!taskCount) {
      return res.status(404).json({ message: 'Task count not found for the user.' });
    }
    res.status(200).json(taskCount);
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving task count.', error });
  }
};

// Create a new task count entry for a user
const createTaskCount = async (req, res) => {
  const { userId } = req.body;

  try {
    const existingTaskCount = await TaskCount.findOne({ user_id: userId });
    if (existingTaskCount) {
      return res.status(400).json({ message: 'Task count already exists for the user.' });
    }

    const taskCount = new TaskCount({ user_id: userId });
    await taskCount.save();
    res.status(201).json({ message: 'Task count created successfully.', taskCount });
  } catch (error) {
    res.status(500).json({ message: 'Error creating task count.', error });
  }
};

// Update the task count for a specific user
const updateTaskCount = async (req, res) => {
  const { userId } = req.params;
  const { incrementBy = 1 } = req.body; // Optional increment value, default is 1

  try {
    const taskCount = await TaskCount.findOneAndUpdate(
      { user_id: userId },
      { $inc: { task_count: incrementBy } },
      { new: true }
    );

    if (!taskCount) {
      return res.status(404).json({ message: 'Task count not found for the user.' });
    }

    res.status(200).json({ message: 'Task count updated successfully.', taskCount });
  } catch (error) {
    res.status(500).json({ message: 'Error updating task count.', error });
  }
};

module.exports = {
  getTaskCount,
  createTaskCount,
  updateTaskCount,
};