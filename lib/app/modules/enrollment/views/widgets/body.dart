import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/modules/enrollment/controller/enrollment_controller.dart';
import 'package:openimis_app/app/modules/enrollment/views/widgets/submit_botton_sheet.dart';
import '../../../../utils/functions.dart';
import '../../../../widgets/openimis_appbar.dart';
import 'enrollment_form.dart';
import 'enrollment_list.dart';

class Body extends StatelessWidget {
  // Initialize the controller outside of the build method
  final EnrollmentController controller = Get.put(EnrollmentController());

  Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
          appBar: OpenIMISAppBar(
            title: 'enrollment'.tr,
            tabController: controller.tabController,
            selectedTabIndex: controller.selectedTabIndex,
            actions: [
              IconButton(
                icon: HeroIcon(
                  HeroIcons.camera,
                  color: Colors.green.shade800,
                  size: 30.0,
                  style: HeroIconStyle.solid,
                ),
                onPressed: controller.pickAndCropPhoto,
              ),
              IconButton(
                icon: const Icon(Icons.replay_circle_filled),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Do you want to reset the form?',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  controller.resetForm();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: HeroIcon(
                  HeroIcons.inboxArrowDown,
                  size: 35.0,
                  color: Colors.blueAccent.shade200,
                  style: HeroIconStyle.solid,
                ),
                onPressed: () {
                  if (controller.enrollmentFormKey.currentState!.validate()) {
                    controller.onEnrollmentSubmit();
                    print("Form Submitted");
                  }
                },
              ),
            ],
            tabs: [
              Tab(text: "enrollment".tr), // Custom Tab 1
              Tab(text: "offline_enrollment".tr), // Custom Tab 2
            ],
          ),
          body: TabBarView(controller: controller.tabController, children: [
            Obx(() {
              return controller.enrollmentState.when(
                  idle: () => EnrollmentForm(),
                  loading: () => Center(child: CircularProgressIndicator()),
                  failure: (reason) => Text("error"),
                  success: (data) {
                    return (EnrollmentForm());
                    // Default widget when none of the states match
                  });
            }),
            EnrollmentListPage(),
          ])),
    );
  }
}
