import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/home/controllers/home_controller.dart';


class HelpPage1 extends StatelessWidget {
  const HelpPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help: Enroll Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Step 1: Navigate to the Enroll Page'),
            const SizedBox(height: 10),
            const Text('1. Click on the enrollment icon to navigate to the Enroll Page.'),
            const SizedBox(height: 20),
            const Text('Step 2: Fill in the enrollment fields'),
            const SizedBox(height: 10),
            const Text('Please fill in the following fields:'),
            const Text('1. Phone'),
            const Text('2. Birthdate'),
            const Text('3. CHFID'),
            const Text('4. EA Code'),
            const Text('5. Email'),
            const Text('6. Gender'),
            const Text('7. Given Name'),
            const Text('8. Identification No'),
            const Text('9. Is Head'),
            const Text('10. Last Name'),
            const Text('11. Marital Status'),
            const Text('12. Head CHFID'),
            const Text('13. New Enrollment'),
            const Text('14. Photo'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.nextStep,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
