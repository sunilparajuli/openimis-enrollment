import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/modules/enrollment/views/widgets/family_form.dart';
import 'package:openimis_app/app/modules/enrollment/views/widgets/location_dropdowns.dart';
import '../../controller/enrollment_controller.dart';

import 'health_service_provider.dart';

class EnrollmentForm extends StatelessWidget {
  final int? enrollmentId;
  final String? chfid;
  final EnrollmentController controller = Get.put(EnrollmentController());
  EnrollmentForm({super.key, this.enrollmentId, this.chfid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Form(
        key: controller.enrollmentFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // New Enrollment Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (enrollmentId != null)
                    Text('Adding members with ID: $chfid'),
                  if (enrollmentId == null) Text('new_enrollment'.tr),

                  if (enrollmentId == null)
                    Obx(() {
                      return Switch(
                        value: controller.newEnrollment.value,
                        onChanged: (value) {
                          controller.newEnrollment.value = value;
                          if (value) {
                            controller.isHead.value = true;
                          }
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.shade400,
                      );
                    }),

                  if (enrollmentId == null)
                    Obx(() {
                      return Row(
                        children: [
                          Text('head'.tr),
                          Switch(
                            value: controller.isHead.value,
                            onChanged: (value) {
                              controller.isHead.value = value;
                            },
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: Colors.grey.shade400,
                          ),
                        ],
                      );
                    }),
                ],
              ),

              const SizedBox(height: 16),
              Obx(() {
                return controller.photo.value == null
                    ? const Stack()
                    : Column(
                        children: [
                          Image.file(
                            File(controller.photo.value!.path),
                            width: enrollmentId == null ? 100 : 50,
                            height: enrollmentId == null ? 100 : 50,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 30),
                            onPressed: controller.pickAndCropPhoto,
                          ),
                        ],
                      );
              }),
              const SizedBox(height: 16),
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
                  if(enrollmentId!=null)
                    IconButton(
                      icon: HeroIcon(
                        HeroIcons.userPlus,
                        color: Colors.green.shade800,
                        size: 30.0,
                        style: HeroIconStyle.solid,
                      ),
                      onPressed: () => { controller.onEnrollmentSubmit()},
                    ),
                  if (enrollmentId == null)
                    Expanded(
                      child: buildTextFormField(controller.headChfidController,
                          'head_chfid'.tr, TextInputType.number, (value) {
                        if (value == null || value.isEmpty) {
                          return 'head_chfid_is_required'.tr;
                        }
                        if (value.length != 10) {
                          return 'Head CHFID must be exactly 10 digits';
                        }
                        return null;
                      }),
                    ),
                  if (enrollmentId == null)
                    IconButton(
                      icon: Icon(
                        Icons.qr_code_scanner,
                        color: Colors.green.shade400,
                        size: 40,
                      ), // Use HeroIcon with the desired icon
                      onPressed: () =>
                          controller.scanQRCode(controller.headChfidController),
                    ),
                ],
              ),

              const SizedBox(height: 16),
              // Form Fields
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(children: [
                    buildTextFormField(controller.chfidController, 'chfid'.tr,
                        TextInputType.number, (value) {
                      if (value == null || value.isEmpty) {
                        return 'CHFID is required';
                      }
                      if (value.length != 10) {
                        return 'CHFID must be exactly 10 digits';
                      }
                      return null;
                    }),
                    buildTextFormField(controller.eaCodeController, 'EA Code',
                        TextInputType.text, null),
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
                    const SizedBox.shrink()
                  ]),
                ],
              ),
              HealthServiceProviderDropdown(),

              const SizedBox(height: 16),

              Obx(() {
                return controller.newEnrollment.value
                    ? Padding(
                        padding: const EdgeInsets.all(1),
                        child: Column(
                          children: [
                            const Text("Location"),
                            const SizedBox(
                              height: 10,
                            ),
                            BuildDropdowns(
                              controller: controller,
                            ),
                            const Text("Family"),
                            const SizedBox(
                              height: 10,
                            ),
                            if (enrollmentId == null) FamilyForm(),
                          ],
                        ))
                    : const Text("");
              }),
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
          border: const OutlineInputBorder(),
          errorStyle: const TextStyle(color: Colors.red),
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
            border: const OutlineInputBorder(),
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
          border: const OutlineInputBorder(),
          errorStyle: const TextStyle(color: Colors.red),
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
