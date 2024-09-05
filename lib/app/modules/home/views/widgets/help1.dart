import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/home/controllers/home_controller.dart';


class HelpPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Help: Enroll Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step 1: Navigate to the Enroll Page'),
            SizedBox(height: 10),
            Text('1. Click on the enrollment icon to navigate to the Enroll Page.'),
            SizedBox(height: 20),
            Text('Step 2: Fill in the enrollment fields'),
            SizedBox(height: 10),
            Text('Please fill in the following fields:'),
            Text('1. Phone'),
            Text('2. Birthdate'),
            Text('3. CHFID'),
            Text('4. EA Code'),
            Text('5. Email'),
            Text('6. Gender'),
            Text('7. Given Name'),
            Text('8. Identification No'),
            Text('9. Is Head'),
            Text('10. Last Name'),
            Text('11. Marital Status'),
            Text('12. Head CHFID'),
            Text('13. New Enrollment'),
            Text('14. Photo'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.nextStep,
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
