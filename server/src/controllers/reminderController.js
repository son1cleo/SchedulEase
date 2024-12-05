const ReminderObserver = require('../observers/reminderObserver');
const ReminderSubject = require('../observers/reminderSubject');

// Create an instance of the ReminderSubject
const reminderSubject = new ReminderSubject();

// Create instances of the ReminderObserver
const observer1 = new ReminderObserver();
const observer2 = new ReminderObserver();

// Add observers to the subject
reminderSubject.addObserver(observer1);
reminderSubject.addObserver(observer2);

// Simulate a status change in reminder (this could be a time-based trigger in real scenario)
const reminderStatus = "30 minutes left";

// Notify all observers
reminderSubject.notifyObservers(reminderStatus);

// Simulate another status change
const overdueStatus = "Task is overdue";
reminderSubject.notifyObservers(overdueStatus);
