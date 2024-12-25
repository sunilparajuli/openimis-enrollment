import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/public_enrollment_controller.dart';

class HealthServiceProviderDropdown extends StatelessWidget {
  final PublicEnrollmentController controller = Get.put(PublicEnrollmentController());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => controller.hospitalState.when(
        idle: () => Container(),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: (hospitals) => hospitals == null || hospitals.isEmpty
            ? Container()
            : DropdownButtonFormField<String>(
          value: controller.selectedHealthFacility.value.isEmpty
              ? null
              : controller.selectedHealthFacility.value,
          onChanged: (newValue) {
            controller.selectedHealthFacility.value = newValue!;
            // Handle the selected value
            print('Selected hospital: $newValue');
          },
          decoration: InputDecoration(
            labelText: 'First Service Point',
            border: OutlineInputBorder(),
          ),
          items: hospitals
              .map<DropdownMenuItem<String>>((hospital) {
            return DropdownMenuItem<String>(
              value: hospital.id.toString(), // Ensure unique values
              child: Text(hospital.name ?? 'No Name'),
            );
          }).toList(),
        ),
        failure: (error) => Center(
          child: Text(error ?? 'An error occurred'),
        ),
      ),
    );
  }
}
