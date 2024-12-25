import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/public_enrollment_controller.dart';
import 'widgets/body.dart';

class PublicEnrollmentView extends GetView<PublicEnrollmentController> {
  const PublicEnrollmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PublicEnrollmentController());
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Get.theme.colorScheme.background,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Obx(() {
            return !controller.showForm.value
                ? PublicEnrollmentBody() // Show the form
                : Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Instructions",
                    style: Get.textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.instructions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Obx(() => Checkbox(
                            value: controller
                                .instructions[index].isAcknowledged,
                            onChanged: (value) {
                              controller.updateInstructionStatus(
                                  index, value ?? false);
                            },
                          )),
                          title: Text(controller.instructions[index].text),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: controller.allInstructionsAcknowledged
                        ? controller.proceedToForm
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      minimumSize: Size(double.infinity, 48.h),
                    ),
                    child: Text("Proceed"),
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () => Get.back(), // Navigate back
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      minimumSize: Size(double.infinity, 48.h),
                     // primary: Colors.red, // Red text for Cancel
                    ),
                    child: Text("Cancel"),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
