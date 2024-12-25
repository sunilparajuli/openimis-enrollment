import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:openimis_app/app/modules/enrollment/controller/enrollment_controller.dart';

class Contribution extends StatefulWidget {
  Contribution(EnrollmentController enrollmentController);

  @override
  _ContributionState createState() => _ContributionState();
}

class _ContributionState extends State<Contribution> {
  bool isVisible = false; // For toggling the visibility of the card
  final EnrollmentController enrollmentController =
  Get.put(EnrollmentController());
  final TextEditingController _amountPaidController = TextEditingController();
  final TextEditingController _voucherNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0), // Card content padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _amountPaidController,
            decoration: InputDecoration(
              labelText: 'Amount Paid',
            ),
            onChanged: (e)  {

            },
          ),
          Obx(() {
            return TextField(
              controller: _voucherNumberController..text = enrollmentController.voucherNumber.value,
              decoration: InputDecoration(
                labelText: 'Voucher Number',
              ),
              onChanged: (e) {
                enrollmentController.voucherNumber.value = e;
              },
            );
          })


        ],
      ),
    );
  }
}
