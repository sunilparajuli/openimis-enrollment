import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/enrollment/controller/enrollment_controller.dart';

class FamilyForm extends StatelessWidget {
  final EnrollmentController controller = Get.put(EnrollmentController());

  // Key-value maps for dropdowns
  final Map<String, String> familyTypeCodes = {
    "Council": "C",
    "Organization": "G",
    "Household": "H",
    "Other": "O",
    "Priests": "P",
    "Students": "S",
    "Teachers": "T",
  };

  final Map<String, String> confirmationTypes = {
    "Local council": "A",
    "Municipality": "B",
    "State": "C",
    "Other": "D",
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Section(
              title: "Family Details",
              children: [
                buildDropdownFormField(
                  controller.selectedFamilyType,
                  'Select Family Type',
                  familyTypeCodes,
                      (String? newValue) {
                    if (newValue != null) {
                      controller.selectedFamilyType.value = newValue;
                    }
                  },
                ),
                buildDropdownFormField(
                  controller.selectedConfirmationType,
                  'Select Confirmation Type',
                  confirmationTypes,
                      (String? newValue) {
                    if (newValue != null) {
                      controller.selectedConfirmationType.value = newValue;
                    }
                  },
                ),
                buildTextFormField(
                  controller.confirmationNumber,
                  'Confirmation No',
                ),
                SizedBox(height: 10),
                buildTextFormField(
                  controller.addressDetail,
                  'Address Detail',
                ),
                SizedBox(height: 10),
                Obx(() {
                  return buildCheckbox(
                    controller.povertyStatus.value,
                        (bool? value) {
                      controller.povertyStatus.value = value!;
                    },
                    'poverty_status'.tr,
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Dropdown Form Field Widget
  Widget buildDropdownFormField(
      RxString controllerValue,
      String labelText,
      Map<String, String> items,
      ValueChanged<String?> onChanged,
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
          items: items.keys.map<DropdownMenuItem<String>>((String key) {
            return DropdownMenuItem<String>(
              value: items[key], // The value will be the code ("C", "G", etc.)
              child: Text(key), // The display will be the label ("Council", etc.)
            );
          }).toList(),
        );
      }),
    );
  }

  // TextFormField Widget
  Widget buildTextFormField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        controller: controller,
      ),
    );
  }

  // Checkbox Widget
  Widget buildCheckbox(bool value, ValueChanged<bool?> onChanged, String label) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Expanded(child: Text(label)),
      ],
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
        border: Border.all(color: Colors.grey.shade300),
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
