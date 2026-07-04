import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class SnackBars {
  static failure(String title, String message) {
    Get.snackbar(
      "",
      "",
      backgroundColor: Get.theme.colorScheme.error.withValues(alpha: 0.85),
      icon: HeroIcon(
        HeroIcons.exclamationCircle,
        color: Get.theme.colorScheme.surface,
        size: 24.w,
        style: HeroIconStyle.solid,
      ),
      margin: EdgeInsets.all(8.w),
      borderRadius: 14.r,
      colorText: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      padding: EdgeInsets.all(16.w),
      titleText: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Get.theme.colorScheme.surface,
        ),
      ),
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: Get.theme.colorScheme.surface,
        ),
      ),
    );
  }

  static info(String title, String message) {
    Get.snackbar(
      "",
      "",
      backgroundColor: Get.theme.primaryColor.withValues(alpha: 0.85),
      icon: HeroIcon(
        HeroIcons.informationCircle,
        color: Get.theme.colorScheme.surface,
        size: 24.w,
        style: HeroIconStyle.solid,
      ),
      margin: EdgeInsets.all(8.w),
      borderRadius: 14.r,
      colorText: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      padding: EdgeInsets.all(16.w),
      titleText: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Get.theme.colorScheme.surface,
        ),
      ),
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: Get.theme.colorScheme.surface,
        ),
      ),
    );
  }

  static warning(String title, String message) {
    Get.snackbar(
      "",
      "",
      backgroundColor: Colors.orange.withValues(alpha: 0.85),
      icon: HeroIcon(
        HeroIcons.exclamationTriangle,
        color: Get.theme.colorScheme.surface,
        size: 24.w,
        style: HeroIconStyle.solid,
      ),
      margin: EdgeInsets.all(8.w),
      borderRadius: 14.r,
      colorText: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      padding: EdgeInsets.all(16.w),
      titleText: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Get.theme.colorScheme.surface,
        ),
      ),
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: Get.theme.colorScheme.surface,
        ),
      ),
    );
  }

  static success(String title, String message) {
    Get.snackbar(
      "",
      "",
      backgroundColor: Colors.green.withValues(alpha: 0.85),
      icon: HeroIcon(
        HeroIcons.checkCircle,
        color: Get.theme.colorScheme.surface,
        size: 24.w,
        style: HeroIconStyle.solid,
      ),
      margin: EdgeInsets.all(8.w),
      borderRadius: 14.r,
      colorText: Colors.white,
      snackStyle: SnackStyle.FLOATING,
      padding: EdgeInsets.all(16.w),
      titleText: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Get.theme.colorScheme.surface,
        ),
      ),
      messageText: Text(
        message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
          color: Get.theme.colorScheme.surface,
        ),
      ),
    );
  }
}
