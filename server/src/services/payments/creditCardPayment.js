class CreditCardPayment {
    async process(amount) {
        return {
            success: true,
            transactionId: 'CREDIT123456' // Replace with actual transactionId from the payment gateway
        };
    }
}

module.exports = CreditCardPayment;
