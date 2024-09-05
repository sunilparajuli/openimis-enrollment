import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/enrollment/controller/enrollment_controller.dart';

class FamilyForm extends StatelessWidget {
  final EnrollmentController controller = Get.put(EnrollmentController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Section(
          title: "Family Details",
          children: [
            buildDropdownFormField(
              controller.selectedFamilyType,
              'Select Family Type',
              [
                'Council',
                'Organization',
                'Household',
                'Other',
                'Priests',
                'Students',
                'Teachers'
              ],
                  (dynamic newValue) {
                controller.selectedFamilyType.value = newValue;
              },
            ),
            buildDropdownFormField(
              controller.selectedConfirmationType,
              'Select Confirmation Type',
              ['Local council', 'Municipality', 'State', 'Other'],
                  (dynamic newValue) {
                controller.selectedConfirmationType.value = newValue;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Confirmation No',
                border: OutlineInputBorder(),
              ),
              controller: controller.confirmationNumber,
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Address Detail',
                border: OutlineInputBorder(),
              ),
              controller: controller.addressDetail,
            ),
            SizedBox(height: 10),
            Obx(() {
              return Row(
                children: [
                  Checkbox(
                    value: controller.povertyStatus.value,
                    onChanged: (bool? value) {
                      controller.povertyStatus.value = value!;
                    },
                  ),
                  Expanded(child: Text('poverty_status'.tr)),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  // Dropdown Form Field Widget
  Widget buildDropdownFormField(
      RxString controllerValue,
      String labelText,
      List<String> items,
      ValueChanged<dynamic> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() {
        return DropdownButtonFormField<String>(
          value: controllerValue.value.isEmpty ? null : controllerValue.value,
          onChanged: onChanged,
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
}

// Section Widget
class Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
