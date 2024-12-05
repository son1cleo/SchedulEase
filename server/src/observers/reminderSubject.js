class ReminderSubject {
  constructor() {
    this.observers = [];
  }

  addObserver(observer) {
    this.observers.push(observer);
  }

  removeObserver(observer) {
    const index = this.observers.indexOf(observer);
    if (index > -1) {
      this.observers.splice(index, 1);
    }
  }

  notifyObservers(status) {
    for (const observer of this.observers) {
      observer.update(status);
    }
  }
}

module.exports = ReminderSubject;
