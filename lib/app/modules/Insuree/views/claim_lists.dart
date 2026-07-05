
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/modules/Insuree/controllers/customer_profile_controller.dart';
import 'package:openimis_app/app/widgets/shimmer/claim_shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/core/values/strings.dart';
import '../../../widgets/custom_info_card.dart';
import '../../../widgets/custom_lottie.dart';

class ClaimResults extends GetView<CustomerProfileController> {
  const ClaimResults({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    // Define the grievance reporting function
    void reportToGrievance() {
      // Implement the logic for reporting to grievance, such as:
      // - Showing a dialog
      // - Navigating to another page
      // - Making an API call, etc.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Report Grievance"),
            content: const Text("Grievance has been reported successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
    return Obx(
      () => controller.claimResults.when(
        idle: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Empty container for idle state, no issues here
              Container()
            ],
          ),
        ),
        loading: () => const Center(child: ClaimResultsShimmer()), // Loading state
        success: (results) => results!.isEmpty
            ? CustomLottie(
                title: AppStrings.NO_RESULT,
                asset: "assets/empty.json",
                description: AppStrings.NO_RESULT_DES,
                assetHeight: 200.h,
              )
            : ListView.builder(
                itemCount: results.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: CustomInfoCard(
                    padding: 10.0,
                    icon: HeroIcons.bars3,
                    title: results[index].code,
                    action: HeroIcons.adjustmentsHorizontal,
                    onActionTap: () {
                      controller.getClaimServItemsResults(results[index].id);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, // Allow full screen drag
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                            expand: false,
                            initialChildSize:
                                0.5, // Initial size of the bottom sheet
                            minChildSize:
                                0.3, // Minimum size of the sheet when collapsed
                            maxChildSize:
                                0.9, // Maximum size when fully expanded
                            builder: (BuildContext context,
                                ScrollController scrollController) {
                              return Obx(() {
                                return controller.claimServItemResults.when(
                                  idle: () => Container(),
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  success: (data) {
                                    // Check if data is not null and has claimed items or services
                                    if (data!.claimedItems.isEmpty &&
                                        data.claimedServices.isEmpty) {
                                      return const Center(
                                          child: Text("No data available"));
                                    }

                                    return SingleChildScrollView(
                                      controller:
                                          scrollController, // Use scrollController to sync with draggable sheet
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: const EdgeInsets.symmetric(vertical: 10.0),
                                              width: 80.0,
                                              height: 5.0,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[400], // Light grey color for the handle
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                            ),
                                          ),
                                          // Title for Items
                                          if (data.claimedItems.isNotEmpty) ...[
                                            const Text(
                                              'Items', // Title for Items section
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    10.0), // Space between title and list
                                            ListView.builder(
                                              shrinkWrap:
                                                  true, // Allows ListView to take only the needed space
                                              physics:
                                                  const NeverScrollableScrollPhysics(), // Disable internal scrolling
                                              itemCount: data.claimedItems
                                                  .length, // Use dynamic length of claimedItems
                                              itemBuilder: (context, index) {
                                                final item = data.claimedItems[
                                                    index]; // Get the item from the list
                                                return ListTile(
                                                  leading: GestureDetector(
                                                    onTap: () {
                                                      const Dialog(); // Define what happens when tapped
                                                    },
                                                    child: const CircleAvatar(
                                                      child: Icon(
                                                          Icons.report_sharp,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  title: Text(item
                                                      .itemName), // Access itemName from claimedItems
                                                  subtitle: Text(
                                                      'Quantity: ${item.qtyProvided}, Price Asked: ${item.priceAsked}'),
                                                );
                                              },
                                            ),
                                          ],

                                          // Space between Items and Services section
                                          const SizedBox(height: 10.0),

                                          // Title for Services
                                          if (data
                                              .claimedServices.isNotEmpty) ...[
                                            const Text(
                                              'Services', // Title for Services section
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                                height:
                                                    10.0), // Space between title and list
                                            ListView.builder(
                                              shrinkWrap:
                                                  true, // Allows ListView to take only the needed space
                                              physics:
                                                  const NeverScrollableScrollPhysics(), // Disable internal scrolling
                                              itemCount: data.claimedServices
                                                  .length, // Use dynamic length of claimedServices
                                              itemBuilder: (context, index) {
                                                final service = data
                                                        .claimedServices[
                                                    index]; // Get the service from the list
                                                return ListTile(
                                                  leading: GestureDetector(
                                                    onTap: () {
                                                      const Dialog(); // Define what happens when tapped
                                                    },
                                                    child: const CircleAvatar(
                                                      child: Icon(
                                                          Icons.report_sharp,
                                                          color: Colors.blue),
                                                    ),
                                                  ),
                                                  title: Text(service
                                                      .serviceName), // Access serviceName from claimedServices
                                                  subtitle: Text(
                                                      'Duration: ${service.status}, Price Asked: ${service.priceAsked}'),
                                                );
                                              },
                                            ),
                                            // Space between Services and the Button
                                            const SizedBox(height: 10.0),

                                            // ElevatedButton to report to grievance
                                            Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Add your grievance reporting logic here
                                                  print('Reporting to grievance...');
                                                  // You can navigate, show a dialog, or call a method
                                                  reportToGrievance();
                                                },
                                                child: const Text('Report'),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
                                  failure: (reason) {
                                    return Center(
                                        child: Text("Error: $reason"));
                                  },
                                );
                              });
                            },
                          );
                        },
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const HeroIcon(
                              HeroIcons.calendar, // Use the dollar sign icon
                              size: 20.0,               // Adjust size as needed
                              color: Colors.green,      // Optional: Set icon color
                            ),
                            const SizedBox(width: 8),          // Add spacing between icon and text
                            Text(
                              results[index].dateClaimed.toString().substring(0, 10), // Claimed amount
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15.0,),
                        Row(
                          children: [
                            const HeroIcon(
                              HeroIcons.currencyDollar, // Use the dollar sign icon
                              size: 20.0,               // Adjust size as needed
                              color: Colors.green,      // Optional: Set icon color
                            ),
                            const SizedBox(width: 8),          // Add spacing between icon and text
                            Text(
                              results[index].claimed, // Claimed amount
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),          // Add spacing between text elements
                            Text(
                              "Stage: ${results[index].status}", // Claim status
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        failure: (e) => CustomLottie(
          asset: "assets/space.json",
          title: e!,
          onTryAgain: controller.onRetry,
        ),
      ),
    );
  }
}
