const User = require('../../models/User');
const Payment = require('../../models/Payment');
const CreditCardPayment = require('../../services/payments/creditCardPayment');
const BkashPayment = require('../../services/payments/bkashPayment');
const NagadPayment = require('../../services/payments/nagadPayment');
const PaymentProcessor = require('../../services/payments/paymentProcessor');

const processSubscription = async ({ paymentMethod, userId }) => {
    const amount = 100;

    // Check if the user is already subscribed
    const existingPayment = await Payment.findOne({ user_id: userId, status: 'Success' });
    if (existingPayment) {
        throw new Error('User is already subscribed');
    }

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
            console.error('Invalid payment method:', paymentMethod);
            throw new Error('Invalid payment method');
    }

    const paymentProcessor = new PaymentProcessor(paymentStrategy);

    try {
        console.log(`Processing payment of ${amount} BDT via ${paymentMethod} for user ${userId}`);

        // Process the payment
        const paymentResult = await paymentProcessor.processPayment(amount);
        console.log('Payment result:', paymentResult);

        if (paymentResult && paymentResult.success) {
            // Payment was successful, proceed with updating the database
            const payment = new Payment({
                user_id: userId,
                amount: amount,
                currency: 'BDT',
                status: 'Success',
                method: paymentMethod,
                transaction_id: paymentResult.transactionId,
            });

            await payment.save();
            console.log('Payment record saved:', payment);

            // Update the user's subscription status
            const updatedUser = await User.findByIdAndUpdate(
                userId,
                { subscription_status: true },
                { new: true }  // Returns the updated document
            );

            console.log("User subscription status updated:", updatedUser);
            return { message: 'Subscription successful' };

        } else {
            console.error('Payment failed or undefined result:', paymentResult);
            throw new Error('Payment failed');
        }
    } catch (error) {
        console.error('An error occurred during payment:', error);
        throw new Error(error.message || 'An error occurred during payment');
    }
};


module.exports = { processSubscription };
