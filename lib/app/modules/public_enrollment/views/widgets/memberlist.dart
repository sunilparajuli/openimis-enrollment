import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:openimis_app/app/modules/public_enrollment/views/widgets/public_contribution.dart';
import 'package:openimis_app/app/modules/public_enrollment/views/widgets/public_enrollment_form.dart';
import 'dart:convert';

import '../../controller/public_enrollment_controller.dart'; // For JSON parsing

class PublicFamilyMemberDetails extends StatefulWidget {
  const PublicFamilyMemberDetails();

  @override
  _PublicFamilyMemberDetailsState createState() =>
      _PublicFamilyMemberDetailsState();
}

class _PublicFamilyMemberDetailsState extends State<PublicFamilyMemberDetails> {
  final PublicEnrollmentController controller =
      Get.find<PublicEnrollmentController>();

  @override
  void initState() {
    super.initState();
    controller.enrollments;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            // Update totalMembers reactively
            int totalMembers = controller.enrollments.length;
            return Text(
              'Total Family Members: $totalMembers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          }),
          SizedBox(height: 16),
          Obx(() {
            // Rebuild ListView when enrollments change
            return Expanded(
              child: ListView.builder(
                itemCount: controller.enrollments.length,
                itemBuilder: (context, index) {
                  // Parse JSON content
                  String jsonString =
                      controller.enrollments[index]['json_content'] ?? '{}';
                  Map<String, dynamic> jsonContent = jsonDecode(jsonString);

                  String name = jsonContent['givenName'] ?? 'N/A';
                  String birthdate = jsonContent['birthdate'] ?? 'N/A';
                  String gender = jsonContent['gender'] ?? 'N/A';
                  String servicePoint = jsonContent['eaCode'] ?? 'N/A';
                  String policyStatus = jsonContent['maritalStatus'] ?? 'N/A';
                  String photo = jsonContent['photo'] ?? 'N/A';
                  return Card(
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: photo.isNotEmpty
                          ? Image.memory(
                        base64Decode(photo), // Display the image from decoded base64 bytes
                        width: 40, // Adjust the size as needed
                        height: 40,
                        fit: BoxFit.cover, // Optional: To make the image fit inside the box
                      )
                          : Icon(
                        Icons.photo, // Fallback icon if no image is available
                        size: 40, // Adjust the icon size
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text('DOB: $birthdate'),
                          Text('Gender: $gender'),
                          Text('Service Point: $servicePoint'),
                          Text('Policy Status: $policyStatus'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show confirmation bottom sheet
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            ),
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Confirm Deletion",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Are you sure you want to delete this member?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // Cancel Button
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context); // Close the BottomSheet
                                          },
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(color: Colors.grey, fontSize: 16),
                                          ),
                                        ),
                                        // Delete Button
                                        TextButton(
                                          onPressed: () {
                                            // Perform delete action here
                                            controller.deleteFamilyMember(controller.enrollments[index]['id']);
                                            Navigator.pop(context); // Close the BottomSheet
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.red, fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),

                    ),
                  );
                },
              ),
            );
          }),
          SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text(''),
                onPressed: () {
                  _showAddMemberBottomSheet(context, controller);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Spacer(), // Adds flexible space between the buttons
              ElevatedButton.icon(
                icon: Icon(Icons.arrow_forward), // Changed icon for clarity
                label: Text(''),
                onPressed: () {
                  Get.to(() => PublicContribution());
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}

void _showAddMemberBottomSheet(BuildContext context, controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    controller.fetchPublicEnrollmentDetails();
                    Navigator.of(context).pop(); // Close the bottom sheet
                  },
                ),
              ],
            ),
            PublicEnrollmentForm(
              chfid: "1001",
              enrollmentId: 1,
            ),
            ElevatedButton(
              onPressed: () {
                {
                  controller.onEnrollmentSubmit();
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.blue, // Button color
              ),
            )
          ],
        ),
      );
    },
  );
}


