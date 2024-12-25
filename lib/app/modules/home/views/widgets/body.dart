import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/auth/controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import 'dashboard.dart';
import 'insuree_dashboard.dart';


class Body extends GetView<HomeController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller.homeScrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
             // SizedBox(height: 16.h),
              // Container(
              //   width: 90.w, // Set the container width
              //   height: 90.w, // Set the container height to match width for a circle
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle, // Make the decoration circular
              //     // Optional: Add a border or background color
              //     border: Border.all(color: Colors.white, width: 2), // Example of a border
              //     color: Colors.grey[200], // Example of a background color
              //   ),
              //   child: ClipOval(
              //     child: Image.asset(
              //       'assets/imis-gif.gif',
              //       width: 90.w, // Set the desired width
              //       height: 90.w, // Set the desired height to match width for a circle
              //       fit: BoxFit.cover, // Ensure the image covers the circle
              //     ),
              //   ),
              // ),

              //SizedBox(height: 16.0),
              Text(
                'openimis'.tr,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        //SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        // SliverToBoxAdapter(child: ChipsList()), // Uncomment if needed
        //SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        AuthController.to.isInsuree() ? InsureeDashboardScreen() : DashboardScreen(),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        // SliverToBoxAdapter(child: FeaturedJobs()), // Uncomment if needed
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        // SliverToBoxAdapter(child: RecentJobs()), // Uncomment if needed
      ],
    );
  }
}
