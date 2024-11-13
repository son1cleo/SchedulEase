class NagadPayment {
    async process(amount) {
        return {
            success: true,
            transactionId: 'NAGAD123456' // Replace with actual transactionId from the payment gateway
        };
    }
}

module.exports = NagadPayment;
