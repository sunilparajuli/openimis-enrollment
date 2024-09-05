import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/policy/controller/policy_controller.dart';
import 'package:file_picker/file_picker.dart';

class PolicyForm extends StatelessWidget {
  final PolicyController controller = Get.put(PolicyController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Form(
        key: controller.policyFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.headInsureeChfidController,
                    decoration: InputDecoration(
                      labelText: 'Head Insuree CHFID',
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Head Insuree CHFID is required';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: () => controller
                      .scanQRCode(controller.headInsureeChfidController),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.receiptNoController,
                    decoration: InputDecoration(
                      labelText: 'Receipt No',
                      hintText: 'rasid no',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.qr_code_scanner),
                  onPressed: () =>
                      controller.scanQRCode(controller.receiptNoController),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: controller.noOfFamilyController,
              decoration: InputDecoration(
                labelText: 'Number of Family',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: controller.amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: controller.enrolledDateController,
              decoration: InputDecoration(
                labelText: 'Enrolled Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            SizedBox(height: 16),
            Obx(() {
              return controller.selectedFile.value != null
                  ? Text(
                      'Attached File: ${controller.selectedFileName.value}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : Text('');
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: controller.resetForm,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('reset'.tr),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
