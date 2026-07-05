import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import '../../controller/public_enrollment_controller.dart';
import 'family_detail.dart';

class EnrollmentDetailsPage extends StatelessWidget {
  final String chfid;
  final int? enrollmentId;

  EnrollmentDetailsPage({super.key, required this.chfid, this.enrollmentId});

  final PublicEnrollmentController enrollmentController =
      Get.put(PublicEnrollmentController());

  @override
  Widget build(BuildContext context) {
    // Fetch data when the page is initialized
    enrollmentController.fetchPublicEnrollmentDetails();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollment Details'),
        actions: [
          Row(
            children: [
              // Tooltip(
              //   message: 'Voucher',
              //   child: IconButton(
              //     icon: Icon(Icons.attach_file),
              //     onPressed: () {
              //       // Call the method to pick the voucher image
              //       enrollmentController.pickVoucherImage();
              //     },
              //   ),
              // ),
              // Tooltip(
              //   message: 'Enroll',
              //   child: IconButton(
              //     icon: Icon(Icons.people_rounded),
              //     onPressed: () async {
              //       // Call the method to pick the voucher image
              //       enrollmentController.onEnrollmentOnline(
              //           enrollmentController.familyId.value);
              //     },
              //   ),
              // ),
              // // Wrap IconButton with Builder to access the right context
              Tooltip(
                message: 'Open Sidebar',
                child: Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.menu), // Drawer icon
                      onPressed: () {
                        Scaffold.of(context)
                            .openEndDrawer(); // Open the right drawer
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      // Right-side drawer (endDrawer)
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(1.0),
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text('Contribution and Voucher',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Voucher Image'),
              onTap: () {
                enrollmentController.pickVoucherImage();
              },
            ),
            Obx(() {
              if (enrollmentController.voucherImage.value != null) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(enrollmentController.voucherImage.value!.path),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ListTile(
                      title: const Text('Remove Voucher'),
                      trailing: const Icon(Icons.delete),
                      onTap: () {
                        enrollmentController.clearVoucherImage();
                      },
                    ),
                  ],
                );
              } else {
                return const ListTile(
                  title: Text('No Voucher Image'),
                );
              }
            }),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Contribution Information:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                    'Premium Amount: ${enrollmentController.premiumAmount.value} ${enrollmentController.currency.value}'),
                Text(
                    'Per Member: ${enrollmentController.perMember.value} ${enrollmentController.currency.value}'),
                Text('Validity: ${enrollmentController.validity.value}'),
                const SizedBox(height: 10),
                Obx(() {
                  return Text(
                    'Total Contribution: ${enrollmentController.calculateTotalContribution()} ${enrollmentController.currency.value}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  );
                }),
              ],
            ),
            //PublicContribution(enrollmentController)
          ],
        ),
      ),
      body: SafeArea(child: Obx(() {
        if (enrollmentController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (enrollmentController.errorMessage.isNotEmpty) {
          return Center(child: Text(enrollmentController.errorMessage.value));
        } else if (enrollmentController.family.isEmpty) {
          return const Center(child: Text('No data found'));
        }

        final family = enrollmentController.family;
        final members = enrollmentController.members;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.blue.shade50, // Background color of the Card
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Rounded corners
                  ),
                  elevation: 4, // Shadow effect for the card
                  child: Padding(
                    padding:
                        const EdgeInsets.all(2.0), // Padding inside the card
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        Text(
                          'CHFID: ${family['chfid']}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.white, // Text color for better contrast
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Sync Status: ${family['sync'] == 1 ? 'Synced' : 'Not Synced'}',
                          style: const TextStyle(
                            color: Colors.white, // Text color for sync status
                          ),
                        ),
                        const SizedBox(height: 20),
                        FamilyDetail(
                          family: family,
                          enrollmentController: enrollmentController,
                        ),
                      ],
                    ),
                  ),
                ),
                const Text('Members:'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        iconColor: Colors.brown,
                        leading: CircleAvatar(
                          backgroundImage: member['photo'] != null
                              ? MemoryImage(base64Decode(member['photo']))
                              : const AssetImage('assets/images/placeholder.png')
                                  as ImageProvider,
                          radius: 30,
                        ),
                        title: Text('Member Name: ${member['name']}'),
                        subtitle: Text('CHFID: ${member['chfid']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Ensures the Row takes up minimum width
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info_outline),
                              onPressed: () {
                                _showMemberDetailsPopup(
                                    context, member['json_content']);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              color: Colors
                                  .red, // Set the color of the delete button to red
                              onPressed: () async {
                                await enrollmentController
                                    .deleteFamilyMember(member['id']);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      })),

      // Footer-style button with loading indicator
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return enrollmentController.enrollmentState.when(
            idle: () {
              return Row(
                children: [
                  Expanded(
                    flex: 4, // 80% of the width
                    child: ElevatedButton(
                      onPressed: () {
                        // Trigger the state change to loading
                        // enrollmentController.onEnrollmentOnline(
                        //     enrollmentController.familyId.value);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.blue, // Button color
                      ),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(width: 16), // Add some spacing between the buttons
                  Expanded(
                    flex: 1, // 20% of the width
                    child: ElevatedButton(
                      onPressed: () => _showAddMemberBottomSheet(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.blue, // Button color
                      ),
                      child: const Icon(Icons.add_box_outlined),
                    ),
                  ),
                ],
              );
            },
            loading: () {
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ElevatedButton(
                      onPressed: null, // Disable the button while loading
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor:
                            Colors.grey, // Button color during loading
                      ),
                      child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor:
                            Colors.grey, // Button color during loading
                      ), // Disable the icon button while loading
                      child: const Icon(Icons.attach_money),
                    ),
                  ),
                ],
              );
            },
            success: (data) {
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.green, // Success color
                      ), // Disable the button after success
                      child: const Text('Success!'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.green, // Success color
                      ), // Disable the icon button after success
                      child: const Icon(Icons.attach_money),
                    ),
                  ),
                ],
              );
            },
            failure: (reason) {
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle retry logic here
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.red, // Failure color
                      ),
                      child: const Text('Retry'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle dollar icon button action on failure
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.red, // Failure color
                      ),
                      child: const Icon(Icons.attach_money),
                    ),
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }

  void _showMemberDetailsPopup(BuildContext context, String jsonContent) {
    final Map<String, dynamic> memberDetails = jsonDecode(jsonContent);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Member Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: memberDetails.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text('${entry.key}:',
                              style: const TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('${entry.value}')),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddMemberBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView()
          //   child: PublicEnrollmentForm(
          //       chfid: chfid, enrollmentId: enrollmentId), // Pass CHFID to form
          // ),
        );
      },
    );
  }
}
