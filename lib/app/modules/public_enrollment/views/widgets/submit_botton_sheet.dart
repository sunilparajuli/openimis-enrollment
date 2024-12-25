import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import '../../../../widgets/custom_button.dart';

class SubmitBottomSheet extends StatelessWidget {
  final String titleText;
  final String descriptionText;
  final String buttonText;
  final Future<void> Function()? onTap; // Future callback

  const SubmitBottomSheet({
    Key? key,
    this.titleText = "Enrollment Successful", // Default title
    this.descriptionText =
    "You can check the enrollment by searching the Insuree in the search screen.",
    this.buttonText = "Back To Home", // Default button text
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeroIcon(
            HeroIcons.checkBadge,
            size: 100.w,
            color: Get.theme.primaryColor,
            style: HeroIconStyle.solid,
          ),
          SizedBox(height: 25.h),
          Text(
            titleText,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Get.theme.colorScheme.onBackground,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            descriptionText,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Get.theme.colorScheme.secondary,
            ),
          ),
          SizedBox(height: 50.h),
          CustomButton(
            title: buttonText,
            onTap: () async {
              if (onTap != null) {
                await onTap!(); // Execute the passed function if provided
              } else {
                 Get.close(2); // Default action
              }
            },
          ),
        ],
      ),
    );
  }
}
