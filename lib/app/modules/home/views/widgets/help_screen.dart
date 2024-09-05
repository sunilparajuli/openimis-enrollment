import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/home/controllers/home_controller.dart';
import 'help1.dart';
import 'help2.dart';
import 'help3.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Obx(() {
      switch (controller.currentStep.value) {
        case 0:
          return HelpPage1();
        case 1:
          return HelpPage2();
        case 2:
          return HelpPage3();
        default:
          return HelpPage1(); // Default fallback
      }
    });
  }
}
