import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/public_enrollment/views/widgets/payment_esewa.dart';
import 'package:openimis_app/app/modules/public_enrollment/views/widgets/paypal_page.dart';
import '../../controller/public_enrollment_controller.dart';
import 'dart:io';

class PublicContribution extends StatefulWidget {
  const PublicContribution({Key? key}) : super(key: key);

  @override
  _PublicContributionState createState() => _PublicContributionState();
}

class _PublicContributionState extends State<PublicContribution> {
  final PublicEnrollmentController enrollmentController =
  Get.put(PublicEnrollmentController());
  final TextEditingController _amountPaidController = TextEditingController();
  final TextEditingController _voucherNumberController =
  TextEditingController();

  // Selected Payment Method
  RxString selectedPaymentMethod = 'None'.obs;

  void _showPaymentOptionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Payment Option',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.card_giftcard),
                  title: const Text('Voucher Payment'),
                  onTap: () {
                    selectedPaymentMethod.value = 'Voucher';
                    Navigator.pop(context); // Close BottomSheet
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.payment),
                  title: const Text('Online Payment'),
                  onTap: () {
                    selectedPaymentMethod.value = 'Online';
                    Navigator.pop(context); // Close BottomSheet
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Public Contribution'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Paid Input
            TextField(
              controller: _amountPaidController
                ..text = "${enrollmentController.currency.value.toString()} ${enrollmentController.premiumAmount.value.toString()}",
              decoration: const InputDecoration(
                labelText: 'Amount Due',
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),

            // Button to Choose Payment Option
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showPaymentOptionBottomSheet(context);
                },
                icon: const Icon(Icons.payment),
                label: const Text('Choose Payment Option'),
              ),
            ),
            const SizedBox(height: 16),

            // Display Chosen Payment Method Section
            Obx(() {
              if (selectedPaymentMethod.value == 'Voucher') {
                return buildVoucherPaymentSection();
              } else if (selectedPaymentMethod.value == 'Online') {
                return buildOnlinePaymentSection();
              } else {
                return  Column(
                  children: [
                    Center(
                      child: Text('No Payment Method Selected'),
                    ),
                    Text("Review your enrollment members"),
                  ],
                );
              }
            }),

            const SizedBox(height: 16),
            FamilyMemberTable(enrollments: enrollmentController.enrollments, controller : enrollmentController),

            Obx(() {
              final isVoucherSelected =
                  selectedPaymentMethod.value == 'Voucher';
              final isVoucherImageSelected =
                  enrollmentController.voucherImage.value != null;

              return Visibility(
                visible: isVoucherSelected && isVoucherImageSelected,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        print("Submit Button Pressed");
                      },
                      child: const Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ),
                ),
              );
            }),

          ],
        ),
      ),
    );
  }

  // Voucher Payment Section
  Widget buildVoucherPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voucher Payment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return TextField(
            controller: _voucherNumberController
              ..text = enrollmentController.voucherNumber.value,
            decoration: const InputDecoration(
              labelText: 'Voucher Number',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              enrollmentController.voucherNumber.value = value;
            },
          );
        }),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.attach_file),
          title: const Text('Upload Voucher Image'),
          onTap: () {
            enrollmentController.pickVoucherImage();
          },
        ),
        Obx(() {
          final voucherImage = enrollmentController.voucherImage.value;
          if (voucherImage != null) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    File(voucherImage.path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                ListTile(
                  title: const Text('Remove Voucher'),
                  trailing: const Icon(Icons.delete, color: Colors.red),
                  onTap: () {
                    enrollmentController.clearVoucherImage();
                  },
                ),
              ],
            );
          } else {
            return const ListTile(
              title: Text('No Voucher Image Selected'),
            );
          }
        }),
      ],
    );
  }

  // Online Payment Section
  // Online Payment Section
  Widget buildOnlinePaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Online Payment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // PayPal Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaypalPaymentPage(
                        onFinish: (paymentId) {
                          print("PayPal Payment finished with ID: $paymentId");
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text('PayPal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // PayPal button color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
            const SizedBox(width: 8), // Space between buttons

            // eSewa Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EsewaEpay()),
                  );
                },
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text('eSewa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // eSewa button color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}

class FamilyMemberTable extends StatelessWidget {
  final List<Map<String, dynamic>> enrollments;
  final PublicEnrollmentController controller;

   FamilyMemberTable({required this.enrollments, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: enrollments.map((enrollment) {
        final jsonContent = jsonDecode(enrollment['json_content'] ?? '{}');
        return Column(
          children: [

            ListTile(
              title: Text("${jsonContent['givenName']} ${jsonContent['lastName']}"),
              subtitle: Text('DOB: ${jsonContent['birthdate'] ?? 'N/A'}'),
              trailing: ClipOval(
                child: (jsonContent['photo'] != null && jsonContent['photo'].isNotEmpty)
                    ? controller.buildImageFromBase64(jsonContent['photo'])
                    : controller.buildPlaceholder(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
