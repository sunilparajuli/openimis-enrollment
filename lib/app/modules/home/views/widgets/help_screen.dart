import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/home/controllers/home_controller.dart';
import 'help1.dart';
import 'help2.dart';
import 'help3.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Obx(() {
      switch (controller.currentStep.value) {
        case 0:
          return const HelpPage1();
        case 1:
          return const HelpPage2();
        case 2:
          return const HelpPage3();
        default:
          return const HelpPage1(); // Default fallback
      }
    });
  }
}
