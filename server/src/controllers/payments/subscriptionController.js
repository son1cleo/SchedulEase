// controllers/subscriptionController.js
const User = require('../../models/User');
const Payment = require('../../models/Payment');
const CreditCardPayment = require('../../services/payments/creditCardPayment');
const BkashPayment = require('../../services/payments/bkashPayment');
const NagadPayment = require('../../services/payments/nagadPayment');
const PaymentProcessor = require('../../services/payments/paymentProcessor');

const processSubscription = async ({ paymentMethod, userId }) => {
    const amount = 100;
    let paymentStrategy;

    // Select the payment strategy based on the method
    switch (paymentMethod) {
        case 'CreditCard':
            paymentStrategy = new CreditCardPayment();
            break;
        case 'DebitCard':
            paymentStrategy = new CreditCardPayment(); // Use a similar process for debit cards
            break;
        case 'Bkash':
            paymentStrategy = new BkashPayment();
            break;
        case 'Nagad':
            paymentStrategy = new NagadPayment();
            break;
        default:
            throw new Error('Invalid payment method');
    }

    const paymentProcessor = new PaymentProcessor(paymentStrategy);

    try {
        // Process the payment
        const paymentResult = await paymentProcessor.processPayment(amount);

        if (paymentResult.success) {
            // Create a new Payment record
            const payment = new Payment({
                user_id: userId,
                amount: amount,
                currency: 'BDT',
                status: 'Success',
                method: paymentMethod,
                transaction_id: paymentResult.transactionId,
            });

            await payment.save();

            // Update the user's subscription status
            await User.findByIdAndUpdate(userId, { subscription_status: true });

            return { message: 'Subscription successful' };
        } else {
            throw new Error('Payment failed');
        }
    } catch (error) {
        throw new Error('An error occurred during payment');
    }
};

module.exports = { processSubscription };
