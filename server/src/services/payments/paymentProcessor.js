class PaymentProcessor {
    constructor(strategy) {
        this.strategy = strategy;
    }

    setStrategy(strategy) {
        this.strategy = strategy;
    }

    async processPayment(amount) {
        return await this.strategy.process(amount);
    }
}

module.exports = PaymentProcessor;
