class BkashPayment {
    async process(amount) {
        return {
            success: true,
            transactionId: 'BKASH123456' // Replace with actual transactionId from the payment gateway
        };
    }
}

module.exports = BkashPayment;
