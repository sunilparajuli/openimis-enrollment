import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/Insuree/controllers/customer_profile_controller.dart';
import 'package:openimis_app/app/widgets/custom_lottie.dart';
import 'insuree_profile_details.dart';

class ProfileBody extends GetView<CustomerProfileController> {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.loadPage(isProfilePage: true);
    return Obx(
          () => controller.fhirPatient.when(
        idle: () => CustomLottie(
          title: "No Data Found",
          description: "No patient details are available at the moment.",
          asset: "assets/empty.json",
          assetHeight: 200.h,
        ),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        success: (data) => SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PatientDetailsScreen(patient: data), // Display patient details
              SizedBox(height: 20.h),

              // Add additional actions if needed
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add your custom action here
                    Get.snackbar('Action', 'Additional actions can go here.');
                  },
                  child: Text('Take Action'),
                ),
              ),
            ],
          ),
        ),
        failure: (reason) => CustomLottie(
          title: "Error",
          description: reason ?? "An unknown error occurred.",
          asset: "assets/error.json",
          assetHeight: 200.h,
          onTryAgain: controller.onRetry, // Retry action
        ),
      ),
    );
  }
}
