import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/home/controllers/home_controller.dart';


class HelpPage2 extends StatelessWidget {
  const HelpPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help: Submit to openIMIS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Step 3: Submit to openIMIS'),
            const SizedBox(height: 10),
            const Text('Click on the "Submit" button to save the enrollment in openIMIS.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.previousStep,
              child: const Text('Previous'),
            ),
            const SizedBox(height: 10),
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
