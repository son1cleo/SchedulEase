import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/providers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String? selectedPayment;
  bool isLoading = false;

  Future<void> proceedWithSubscription() async {
    if (selectedPayment == null) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user?['_id'];

    if (userId == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/subscribe/api/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'paymentMethod': selectedPayment,
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        await userProvider.refreshUserSubscription(); // Refresh user data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SubscriptionScreen()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Subscription successful!')),
        );
      } else {
        throw Exception('Failed to subscribe');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subscription failed: ${error.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bool isSubscribed =
        userProvider.user?['subscription_status'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                isSubscribed
                    ? 'You are currently subscribed!'
                    : 'Get Premium Subscription',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            if (!isSubscribed)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Benefits of Subscription:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...[
                    'Unlimited task management',
                    'Access to premium features',
                    'Priority customer support',
                    'Ad-free experience'
                  ].map((benefit) => ListTile(
                        leading: Icon(Icons.check, color: Colors.green),
                        title: Text(benefit),
                      )),
                  SizedBox(height: 16),
                  Text(
                    'Subscription Cost: 100 BDT',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Choose a Payment Method:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text('Credit Card'),
                    trailing: Radio<String>(
                      value: 'CreditCard',
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.credit_card),
                    title: Text('Debit Card'),
                    trailing: Radio<String>(
                      value: 'DebitCard',
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text('Bkash'),
                    trailing: Radio<String>(
                      value: 'Bkash',
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.payments),
                    title: Text('Nagad'),
                    trailing: Radio<String>(
                      value: 'Nagad',
                      groupValue: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : proceedWithSubscription,
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Proceed to Payment'),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  if (selectedPayment == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Please select a payment method to proceed.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              )
            else
              Center(
                child: Text(
                  'Thank you for being a subscriber!',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
