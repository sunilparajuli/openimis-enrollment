// import 'package:flutter/material.dart';
// import 'package:flutter_braintree/flutter_braintree.dart';
//
// class PayPalPayment extends StatelessWidget {
//   final String tokenizationKey;
//   final String amount;
//
//   PayPalPayment({
//     required this.tokenizationKey,
//     required this.amount,
//   });
//
//   // Function to show the payment method nonce
//   void showNonce(BuildContext context, BraintreePaymentMethodNonce nonce) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Payment method nonce:'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Text('Nonce: ${nonce.nonce}'),
//             const SizedBox(height: 16),
//             Text('Type label: ${nonce.typeLabel}'),
//             const SizedBox(height: 16),
//             Text('Description: ${nonce.description}'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Function to initiate PayPal payment
//   Future<void> _startPayPalPayment(BuildContext context) async {
//     final request = BraintreePayPalRequest(amount: amount);
//     final result = await Braintree.requestPaypalNonce(tokenizationKey, request);
//
//     if (result != null) {
//       // Show the nonce details if successful
//       showNonce(context, result);
//     } else {
//       // Handle the error or cancellation
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment canceled or failed')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => _startPayPalPayment(context),
//       child: const Text('Pay with PayPal'),
//     );
//   }
// }
