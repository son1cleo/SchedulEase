class ReminderObserver {
  update(status) {
    // This method will be implemented by any observer
    console.log(`Reminder status: ${status}`);
    // In a real scenario, you would send a notification or handle logic based on the status.
  }
}

module.exports = ReminderObserver;
