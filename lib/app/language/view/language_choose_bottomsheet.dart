import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../modules/auth/controllers/auth_controller.dart';
import '../../widgets/custom_bottom_sheet.dart';
import '../language_service.dart';
import '../languages.dart';

void showLanguageSelectionBottomSheet(BuildContext context) {
  final languageService = Get.find<LanguageService>(); // Get the existing instance

  Get.bottomSheet(
    Padding(
      padding: EdgeInsets.only(
        left: 29.w,
        right: 29.w,
        bottom: Get.mediaQuery.viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Optional handle for the bottom sheet
          Container(
            margin: EdgeInsets.only(top: 28.h, bottom: 50.h),
            width: 30.w,
            height: 4.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              color: Get.theme.colorScheme.onBackground,
            ),
          ),
          // ListView to display language options
          Container(
            width: double.infinity,
            height: Get.height * 0.5, // Half of the screen height
            padding: EdgeInsets.symmetric(horizontal: 2.w), // Horizontal padding
            child: ListView(
              children: Languages().keys.entries.map((entry) {
                final key = entry.key;
                final languageName = entry.value['selected_language'] ?? key;

                return GestureDetector(
                  onTap: () {
                    AuthController.to.updateIsFirstTime(false);
                    final parts = key.split('_');
                    final locale = Locale(parts[0], parts.length > 1 ? parts[1] : '');
                    languageService.updateLocale(locale); // Now works with the instance
                    Get.back(); // Close the bottom sheet after selection
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                    ),
                    child: Text(
                      languageName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Get.theme.colorScheme.onBackground,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true, // Ensures bottom sheet size is controlled
    backgroundColor: Get.theme.scaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
  );
}
