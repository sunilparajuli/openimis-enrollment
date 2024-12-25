import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/public_enrollment_controller.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String paymentId;
  final PublicEnrollmentController controller = Get.put(PublicEnrollmentController());

  PaymentSuccessScreen({Key? key, required this.paymentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Successful")),
      body: Center(
        child: Obx(() {
          return controller.enrollmentState.when(
            idle: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                const Text("Thank you for your payment!", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text("Payment ID: $paymentId", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    //controller.onEnrollmentOnline();
                   Navigator.of(context).popUntil((route) => route.isFirst); // Go back to the home page
                  },
                  child: const Text("OK"),
                ),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
            success: (results) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                const Text("Enrollment Successful!", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text("Payment ID: $paymentId", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst); // Go back to the home page
                  },
                  child: const Text("Back to Home"),
                ),
              ],
            ),
            failure: (errors) {
              return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 80),
                const SizedBox(height: 20),
                const Text("Enrollment Failed!", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                const Text("Please try again later.", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Go back to the previous page
                  },
                  child: const Text("Retry"),
                ),
              ],
            );},
          );
        }),
      ),
    );
  }
}
