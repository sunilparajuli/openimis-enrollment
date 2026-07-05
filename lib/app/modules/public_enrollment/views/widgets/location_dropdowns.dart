import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/enrollment/controller/LocationDto.dart';
import '../../../../data/remote/base/status.dart';
import '../../controller/public_enrollment_controller.dart';

class BuildDropdowns extends StatelessWidget {
  final PublicEnrollmentController controller;

  const BuildDropdowns({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    void onChangedRegion(LocationDto? newValue) {
      controller.selectedRegion.value = newValue;
      controller.selectedDistrict.value = null;
      controller.selectedMunicipality.value = null;
      controller.selectedVillage.value = null;

      controller.districts.value = newValue?.district != null ? [newValue!.district!] : [];
      controller.municipalities.value = newValue?.municipality != null ? [newValue!.municipality!] : [];
      controller.villages.value = newValue?.village != null ? [newValue!.village!] : [];
    }

    void onChangedDistrict(District? newValue) {
      controller.selectedDistrict.value = newValue;
      controller.selectedMunicipality.value = null;
      controller.selectedVillage.value = null;

      controller.municipalities.value = [];
      controller.villages.value = [];
    }

    void onChangedMunicipality(Municipality? newValue) {
      controller.selectedMunicipality.value = newValue;
      controller.selectedVillage.value = null;

      controller.villages.value = [];
    }

    void onChangedVillage(Village? newValue) {
      controller.selectedVillage.value = newValue;
    }

    return Obx(() {
      final status = controller.locationState;
      List<LocationDto> locations = [];

      if (status is Success<List<LocationDto>>) {
        locations = status.data ?? [];
      }

      final regions = locations.where((loc) => loc.type == 'R').toList();
      final selectedRegion = controller.selectedRegion.value;
      final selectedDistrict = controller.selectedDistrict.value;
      final selectedMunicipality = controller.selectedMunicipality.value;

      final districts = controller.districts;
      final municipalities = controller.municipalities;
      final villages = controller.villages;

      return Column(
        children: [
          DropdownButtonFormField<LocationDto>(
            value: selectedRegion,
            hint: const Text('Select Region'),
            decoration: const InputDecoration(
              labelText: "Select Region",
              border: OutlineInputBorder(),
            ),
            onChanged: onChangedRegion,
            items: regions.map((LocationDto region) {
              return DropdownMenuItem<LocationDto>(
                value: region,
                child: Text(region.name ?? ''),
              );
            }).toList(),
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<District>(
            value: selectedDistrict,
            hint: const Text('Select District'),
            decoration: const InputDecoration(
              labelText: "Select District",
              border: OutlineInputBorder(),
            ),
            onChanged: onChangedDistrict,
            items: districts.map((District district) {
              return DropdownMenuItem<District>(
                value: district,
                child: Text(district.name ?? ''),
              );
            }).toList(),
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<Municipality>(
            value: selectedMunicipality,
            hint: const Text('Select Municipality'),
            decoration: const InputDecoration(
              labelText: "Select Municipality",
              border: OutlineInputBorder(),
            ),
            onChanged: onChangedMunicipality,
            items: municipalities.map((Municipality municipality) {
              return DropdownMenuItem<Municipality>(
                value: municipality,
                child: Text(municipality.name ?? ''),
              );
            }).toList(),
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<Village>(
            value: controller.selectedVillage.value,
            hint: const Text('Select Village'),
            decoration: const InputDecoration(
              labelText: "Select Village",
              border: OutlineInputBorder(),
            ),
            onChanged: onChangedVillage,
            items: villages.map((Village village) {
              return DropdownMenuItem<Village>(
                value: village,
                child: Text(village.name ?? ''),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
