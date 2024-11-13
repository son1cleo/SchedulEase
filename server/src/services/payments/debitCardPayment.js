class DebitCardPayment {
    async process(amount) {
        return {
            success: true,
            transactionId: 'DEBIT123456' // Replace with actual transactionId from the payment gateway
        };
    }
}

module.exports = { DebitCardPayment };
