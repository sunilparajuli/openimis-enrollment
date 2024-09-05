import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/modules/policy/controller/policy_controller.dart';
import 'package:openimis_app/app/modules/policy/views/widgets/policy_form.dart';
import 'package:openimis_app/app/modules/policy/views/widgets/policy_save.dart';
import '../../../../widgets/openimis_appbar.dart';

class Body extends GetView<PolicyController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PolicyController controller = Get.put(PolicyController());

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: OpenIMISAppBar(
          title: "policy".tr,
          tabController: controller.tabController,
          selectedTabIndex: controller.selectedTabIndex,
          tabs: const [
            Tab(text: "Policy Form"),
            Tab(text: "Saved Offline"), // Custom tab titles
          ],
          actions: [
            Obx(() {
              return IconButton(
                icon: HeroIcon(
                  controller.selectedFile.value == null
                      ? HeroIcons.documentPlus
                      : HeroIcons.minusCircle,
                  color: controller.selectedFile.value != null
                      ? Colors.red.shade800
                      : Colors.blue.shade500,
                  size: 30.0,
                  style: HeroIconStyle.solid,
                ),
                onPressed: controller.selectedFile.value != null
                    ? controller.removeAttachment
                    : controller.pickFile,
              );
            }),
            SizedBox(
              width: 16.w,
            ),
            IconButton(
              icon: HeroIcon(
                HeroIcons.arrowUpTray,
                color: Colors.green.shade800,
                size: 30.0,
                style: HeroIconStyle.solid,
              ),
              onPressed: () {
                if (controller.policyFormKey.currentState!.validate()) {
                  print("Form Submitted");
                }
              },
            ),
            SizedBox(
              width: 16.w,
            ),
            IconButton(
              icon: HeroIcon(
                HeroIcons.arrowDownTray,
                color: Colors.blue.shade500,
                size: 30.0,
                style: HeroIconStyle.solid,
              ),
              onPressed: controller.savePolicyOffline,
            ),
          ],
        ),
        body: TabBarView(
          controller: controller.tabController,
          children: [
            // Policy Form tab content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          PolicyForm(),
                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Saved Offline tab content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 30.h),
                          PolicyListPage(), // Renders the PolicyListPage() widget
                          SizedBox(height: 50.h),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
