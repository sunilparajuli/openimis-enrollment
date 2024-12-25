import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/modules/public_enrollment/views/widgets/public_family_form.dart';
import '../../controller/public_enrollment_controller.dart';
import 'health_service_provider.dart';

class PublicEnrollmentForm extends StatelessWidget {
  final int? enrollmentId;
  final String? chfid;
  final PublicEnrollmentController controller =
      Get.put(PublicEnrollmentController());
  PublicEnrollmentForm({this.enrollmentId, this.chfid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child:
      Form(
        key: controller.enrollmentFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                return controller.photo.value == null
                    ? Stack()
                    : Column(
                        children: [
                          Image.file(
                            File(controller.photo.value!.path),
                            width: enrollmentId == null ? 100 : 50,
                            height: enrollmentId == null ? 100 : 50,
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, size: 30),
                            onPressed: controller.pickAndCropPhoto,
                          ),
                        ],
                      );
              }),
              SizedBox(height: 16),
              // Head CHFID Field with QR Code Scanner

              Row(
                children: [
                  if (enrollmentId != null)
                    IconButton(
                      icon: HeroIcon(
                        HeroIcons.camera,
                        color: Colors.green.shade800,
                        size: 30.0,
                        style: HeroIconStyle.solid,
                      ),
                      onPressed: controller.pickAndCropPhoto,
                    ),
                  // if (enrollmentId != null)
                  //   IconButton(
                  //     icon: HeroIcon(
                  //       HeroIcons.userPlus,
                  //       color: Colors.green.shade800,
                  //       size: 30.0,
                  //       style: HeroIconStyle.solid,
                  //     ),
                  //     onPressed: () => {controller.onEnrollmentSubmit()},
                  //   ),
                ],
              ),

              SizedBox(height: 16),
              // Form Fields
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(children: [
                    TextFormField(
                      controller: controller.nationalIdController,
                      decoration: InputDecoration(labelText: 'National ID'),
                      keyboardType: TextInputType.text,
                      onChanged: (value) => controller.nationalId.value = value.trim(),
                    ),
                    buildTextFormField(controller.headChfidController,
                        controller.enrollments.length==0 ? 'head_chfid'.tr : 'chfid', TextInputType.number, (value) {
                          if (value == null || value.isEmpty) {
                            return 'head_chfid_is_required'.tr;
                          }
                          if (value.length != 10) {
                            return 'Head CHFID must be exactly 10 digits';
                          }
                          return null;
                        }

                        )
                  //   Obx(() {
                  //     // Use the reactive state for UI changes
                  //     final status = controller.getNationalId;
                  //
                  //     return status.when(
                  //       idle: () => const SizedBox.shrink(), // Show nothing in idle state
                  //       loading: () => Center(
                  //         child: Image.asset(
                  //           'assets/openimis-loading.gif', // Your custom loading image
                  //           width: 50, // Set the size of the image
                  //           height: 50,
                  //           fit: BoxFit.contain,
                  //         ),
                  //       ),
                  //       success: (data) => Row(
                  //         children: const [
                  //           Icon(Icons.check_circle, color: Colors.green),
                  //           SizedBox(width: 8),
                  //           Text('National ID information fetched successfully'),
                  //         ],
                  //       ),
                  //       failure: (reason) => Row(
                  //         children: const [
                  //           Icon(Icons.error, color: Colors.red),
                  //           SizedBox(width: 8),
                  //           Text('Failed to fetch National ID information'),
                  //         ],
                  //       ),
                  //     );
                  //   }),
                  // ]),
      ]),
                  TableRow(children: [
                    buildTextFormField(controller.lastNameController,
                        'last_name'.tr, TextInputType.text, null),
                    buildTextFormField(controller.givenNameController,
                        'given_name'.tr, TextInputType.text, null),
                  ]),
                  TableRow(children: [
                    buildDropdownFormField(
                        controller.gender, 'gender'.tr, ['Male', 'Female']),
                    buildTextFormField(controller.phoneController, 'Phone',
                        TextInputType.phone, null),
                  ]),
                  TableRow(children: [
                    buildTextFormField(controller.emailController, 'Email',
                        TextInputType.emailAddress, null),
                    buildTextFormField(controller.identificationNoController,
                        'Identification No.', TextInputType.text, null),
                  ]),
                  TableRow(children: [
                    buildDropdownFormField(controller.maritalStatus,
                        'Marital Status', ['Married', 'Widow', 'Unmarried']),
                    buildDateFormField(
                        context, controller.birthdateController, 'Birthdate'),
                  ]),
                  TableRow(children: [
                    buildDropdownFormField(
                        controller.relationShip, 'Relation', [
                      'Brother/Sister',
                      'Father/Mother',
                      'Uncle/Aunt',
                      'Son/Daughter',
                      'Grant Parent',
                      'Employee',
                      'Other',
                      'Spouse'
                    ]),
                    SizedBox.shrink()
                  ]),
                ],
              ),
              HealthServiceProviderDropdown(),

              SizedBox(height: 16),
              Padding(
                  padding: EdgeInsets.all(1),
                  child: Column(
                    children: [
                      // Text("Location"),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // BuildDropdowns(
                      //   controller: controller,
                      // ),
                      Text("Family"),
                      SizedBox(
                        height: 10,
                      ),
                      if (enrollmentId == null) PublicFamilyForm(),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String labelText,
      TextInputType keyboardType, String? Function(String?)? validator) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          errorStyle: TextStyle(color: Colors.red),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }

  Widget buildDropdownFormField(
      RxString controllerValue, String labelText, List<String> items) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        return DropdownButtonFormField<dynamic>(
          value: controllerValue.value.isEmpty ? null : controllerValue.value,
          onChanged: (newValue) {
            controllerValue.value = newValue;
          },
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(),
          ),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget buildDateFormField(BuildContext context,
      TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          errorStyle: TextStyle(color: Colors.red),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text = "${pickedDate.toLocal()}".split(' ')[0];
          }
        },
      ),
    );
  }
}
