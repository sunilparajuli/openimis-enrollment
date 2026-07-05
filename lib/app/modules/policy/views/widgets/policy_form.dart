import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/policy/controller/policy_controller.dart';

class PolicyForm extends StatelessWidget {
  final PolicyController controller = Get.put(PolicyController());

  PolicyForm({super.key});

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
                    decoration: const InputDecoration(
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
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () => controller
                      .scanQRCode(controller.headInsureeChfidController),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.receiptNoController,
                    decoration: const InputDecoration(
                      labelText: 'Receipt No',
                      hintText: 'rasid no',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () =>
                      controller.scanQRCode(controller.receiptNoController),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.noOfFamilyController,
              decoration: const InputDecoration(
                labelText: 'Number of Family',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.enrolledDateController,
              decoration: const InputDecoration(
                labelText: 'Enrolled Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            Obx(() {
              return controller.selectedFile.value != null
                  ? Text(
                      'Attached File: ${controller.selectedFileName.value}',
                      style:
                          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : const Text('');
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
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
