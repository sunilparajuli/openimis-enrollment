import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import "../controller/enrollment_controller.dart";
import 'widgets/body.dart';

class EnrollmentView extends GetView<EnrollmentController> {
  const EnrollmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.surface,
      resizeToAvoidBottomInset: false,

      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Get.theme.colorScheme.surface,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child:  SafeArea(child: Body()),
      ),
    );
  }
}
