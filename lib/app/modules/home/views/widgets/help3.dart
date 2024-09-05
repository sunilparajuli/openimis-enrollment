import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/home/controllers/home_controller.dart';


class HelpPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Help: Save Offline'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Step 4: Save Offline'),
            SizedBox(height: 10),
            Text('Click on the "Save Offline" button to save the enrollment locally in the app.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.previousStep,
              child: Text('Previous'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: controller.restartHelp,
              child: Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
