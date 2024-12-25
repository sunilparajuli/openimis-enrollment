import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openimis_app/app/modules/Insuree/views/profile.dart';
import 'package:openimis_app/app/modules/Insuree/views/insuree_header.dart';
import 'insuree_address.dart';
import 'insuree_info.dart';

class PatientDetailsScreen extends StatelessWidget {
  final FHIRPatient? patient;

  const PatientDetailsScreen({Key? key, this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0), // Consistent padding for the entire widget
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          ProfileHeader(
            name: "${patient?.givenNames?.join(" ")} ${patient?.familyName}",
            photoUrl: "https://avatars.githubusercontent.com/u/20227254?v=4",
            gender: patient?.gender ?? "N/A",
            birthDate: patient?.birthDate ?? "N/A",
          ),
          SizedBox(height: 20.h),

          // Info Cards Section
          PatientInfoCard(
            title: "Identifier (Code)",
            value: patient?.identifierCode ?? "N/A",
          ),
          SizedBox(height: 10.h),
          PatientInfoCard(
            title: "Identifier (UUID)",
            value: patient?.identifierUUID ?? "N/A",
          ),
          SizedBox(height: 10.h),
          PatientInfoCard(
            title: "Marital Status",
            value: patient?.maritalStatus ?? "N/A",
          ),
          SizedBox(height: 10.h),

          // Address Section
          PatientAddressCard(
            addressText: patient?.addressText ?? "N/A",
            city: patient?.city ?? "N/A",
            district: patient?.district ?? "N/A",
            state: patient?.state ?? "N/A",
          ),
          SizedBox(height: 20.h),

          // Other Details Section
          PatientInfoCard(
            title: "Is Head of Household",
            value: "Yes", // Static value, replace with dynamic logic if needed
          ),
          SizedBox(height: 10.h),
          PatientInfoCard(
            title: "Card Issued",
            value: "Yes", // Static value, replace with dynamic logic if needed
          ),
        ],
      ),
    );
  }
}
