import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Ensure you're using GetX for enrollmentController
import 'package:openimis_app/app/data/remote/api/api_routes.dart';
import 'package:openimis_app/app/modules/public_enrollment/controller/public_enrollment_controller.dart';
import 'package:openimis_app/app/modules/public_enrollment/views/widgets/payment_success.dart';
import 'package:openimis_app/app/modules/public_enrollment/views/widgets/paypal_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../data/remote/api/dio_client.dart';

class PaypalPaymentPage extends StatefulWidget {
  final Function(String)? onFinish;

  const PaypalPaymentPage({Key? key, this.onFinish}) : super(key: key);

  @override
  _PaypalPaymentPageState createState() => _PaypalPaymentPageState();
}

class _PaypalPaymentPageState extends State<PaypalPaymentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  late WebViewController _webViewController;


  final PaypalServices services = PaypalServices();

  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = "http://localhost:8000"+ApiRoutes.PAYMENT_COMPLETE;
  String cancelURL = 'cancel.example.com';

  final enrollmentController = Get.find<PublicEnrollmentController>(); // Use your actual controller class

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res = await services.createPaypalPayment(transactions, accessToken!);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (ex) {
        final snackBar = SnackBar(
          content: Text(ex.toString()),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Map<String, dynamic> getOrderParams() {
    var exchangeRate = 135.0;
    String itemName = "INSURANCE";

    // double premiumAmountInUSD = enrollmentController.premiumAmount.value / exchangeRate;
    double premiumAmountInUSD = 135.0 / exchangeRate;
    double itemPrice = double.parse(premiumAmountInUSD.toStringAsFixed(2));
    double totalAmount = itemPrice;
    double subTotalAmount = itemPrice;

    List<Map<String, dynamic>> items = [
      {
        "name": itemName,
        "quantity": 1,
        "price": itemPrice.toStringAsFixed(2),
        "currency": defaultCurrency["currency"], // e.g., "USD"
      }
    ];

    double shippingCost = 0.0;
    double shippingDiscountCost = 0.0;

    return {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount.toStringAsFixed(2),
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount.toStringAsFixed(2),
              "shipping": shippingCost.toStringAsFixed(2),
              "shipping_discount": (-1 * shippingDiscountCost).toStringAsFixed(2),
            }
          },
          "description": "Insurance payment",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {"items": items},
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": returnURL, // Ensure these are valid URLs
        "cancel_url": cancelURL,
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () => Navigator.pop(context),
          ),
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];

              if (payerID != null) {
                if (executeUrl != null && accessToken != null) {
                  // Call postEnrollmentAfterPayment
                  enrollmentController
                      .postEnrollmentAfterPayment(executeUrl!, payerID, accessToken!)
                      .then((_) {
                    if (widget.onFinish != null) {
                      widget.onFinish!("Enrollment successful!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                           PaymentSuccessScreen(paymentId: "Enrollment Successful"),
                        ),
                      );
                    }
                  }).catchError((error) {
                    // Handle errors from postEnrollmentAfterPayment
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Payment and enrollment failed: $error")),
                    );
                    Navigator.of(context).pop();
                  });
                } else {
                  // Handle case where executeUrl or accessToken is null
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment execution data is missing.")),
                  );
                  Navigator.of(context).pop();
                }
              } else {
                // Handle case where payerID is null
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Payment canceled.")),
                );
                Navigator.of(context).pop();
              }
            }

            if (request.url.contains(cancelURL)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Payment canceled.")),
              );
              Navigator.of(context).pop();
            }

            return NavigationDecision.navigate;
          },

        ),

      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
  }

  void _handleReturnUrl() {
    // Custom handling when returnUrl is detected
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: const Text('Your payment was processed successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back to the previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
