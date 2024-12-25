import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/modules/public_enrollment/controller/public_enrollment_controller.dart';
import 'package:openimis_app/app/modules/public_enrollment/views/widgets/public_contribution.dart';
import 'package:openimis_app/app/modules/public_enrollment/views/widgets/public_enrollment_list.dart';
import '../../../../utils/functions.dart';
import '../../../../widgets/openimis_appbar.dart';
import '../../../enrollment/views/widgets/contribution.dart';
import '../../../enrollment/views/widgets/memberlist.dart';
import 'memberlist.dart';
import 'dart:io';
import 'public_enrollment_form.dart';

class PublicEnrollmentBody extends StatelessWidget {
  final PublicEnrollmentController controller =
  Get.put(PublicEnrollmentController());

  PublicEnrollmentBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1, // Number of tabs
      child: Scaffold(
          appBar: OpenIMISAppBar(
            title: 'enrollment'.tr,
            tabController: controller.tabController,
            selectedTabIndex: controller.selectedTabIndex,
            actions: [
              Obx(
                    () => Visibility(
                  visible: controller.enrollments.length < 1,
                  child: IconButton(
                    icon: HeroIcon(
                      HeroIcons.camera,
                      color: Colors.green.shade800,
                      size: 30.0,
                      style: HeroIconStyle.solid,
                    ),
                    onPressed: controller.pickAndCropPhoto,
                  ),
                ),
              ),

              // IconButton(
              //   icon: const Icon(Icons.replay_circle_filled),
              //   onPressed: () {
              //     showModalBottomSheet(
              //       context: context,
              //       isScrollControlled: true,
              //       builder: (BuildContext context) {
              //         return Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             const Text(
              //               'Do you want to reset the form?',
              //               style: TextStyle(fontSize: 18),
              //             ),
              //             const SizedBox(height: 20),
              //             Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 ElevatedButton(
              //                   onPressed: () {
              //                     controller.resetForm();
              //                     Navigator.of(context).pop();
              //                   },
              //                   child: const Text('Yes'),
              //                 ),
              //                 ElevatedButton(
              //                   onPressed: () {
              //                     Navigator.of(context).pop();
              //                   },
              //                   child: const Text('No'),
              //                   style: ElevatedButton.styleFrom(
              //                     backgroundColor: Colors.red,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ],
              //         );
              //       },
              //     );
              //   },
              // ),
              Obx(
                    () => Visibility(
                  visible: controller.enrollments.length < 1,
                  child: IconButton(
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
                ),
              ),
            ],
            tabs: [
              //Tab(text: "enrollment".tr), // Custom Tab 1
              Tab(text: "offline_enrollment".tr), // Custom Tab 2
            ],
          ),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.all(1.0),
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text('Contribution and Voucher',
                      style: TextStyle(color: Colors.white, fontSize: 24)),
                ),
                ListTile(
                  leading: Icon(Icons.attach_file),
                  title: Text('Voucher Image'),
                  onTap: () {
                    controller.pickVoucherImage();
                  },
                ),
                Obx(() {
                  if (controller.voucherImage.value != null) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            File(controller.voucherImage.value!.path),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ListTile(
                          title: Text('Remove Voucher'),
                          trailing: Icon(Icons.delete),
                          onTap: () {
                            controller.clearVoucherImage();
                          },
                        ),
                      ],
                    );
                  } else {
                    return ListTile(
                      title: Text('No Voucher Image'),
                    );
                  }
                }),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Contribution Information:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                        'Premium Amount: ${controller.premiumAmount.value} ${controller.currency.value}'),
                    Text(
                        'Per Member: ${controller.perMember.value} ${controller.currency.value}'),
                    Text('Validity: ${controller.validity.value}'),
                    SizedBox(height: 10),
                    Obx(() {
                      return Text(
                        'Total Contribution: ${controller.calculateTotalContribution()} ${controller.currency.value}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      );
                    }),
                  ],
                ),
                //PublicContribution(controller)
              ],
            ),
          ),
          body: TabBarView(controller: controller.tabController, children: [
            //EnrollmentListPage(),
            Obx(() {
              return controller.enrollments.length > 0
                  ?
              PublicFamilyMemberDetails()

                  : PublicEnrollmentForm();
            })
          ])),
    );
  }
}
