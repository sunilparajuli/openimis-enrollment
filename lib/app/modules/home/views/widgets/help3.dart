import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/home/controllers/home_controller.dart';


class HelpPage3 extends StatelessWidget {
  const HelpPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help: Save Offline'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Step 4: Save Offline'),
            const SizedBox(height: 10),
            const Text('Click on the "Save Offline" button to save the enrollment locally in the app.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.previousStep,
              child: const Text('Previous'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: controller.restartHelp,
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
