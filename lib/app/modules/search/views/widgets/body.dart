import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/core/values/strings.dart';

import '../../../../widgets/custom_text_field.dart';
import '../../../auth/controllers/auth_controller.dart';
import '../../../enrollment/controller/enrollment_controller.dart';
import '../../controllers/search_controller.dart';
import 'search_items.dart';

class Body extends GetView<CSearchController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController =
        AuthController.to; // Access the AuthController
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  authController.isInsuree()
                      ? SizedBox()
                      : Expanded(
                          child: Column(
                            children: [
                              // The Search Field
                              !authController.isInsuree() ? TextField(
                                controller: controller.searchController,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: '${AppStrings.SEARCH_HINT}'.tr,
                                  prefixIcon:
                                      HeroIcon(HeroIcons.magnifyingGlass),
                                  suffixIcon: GestureDetector(
                                    onTap: () => controller.clearSearch(),
                                    child: HeroIcon(HeroIcons.xMark),
                                  ),
                                ),
                                maxLines: 1,
                                onChanged: (_) => controller.getSearchResult(),
                              ) : SizedBox(),
                              // The QR Code IconButton
                              IconButton(
                                icon: HeroIcon(HeroIcons.qrCode),
                                onPressed: () async {
                                  await controller
                                      .scanQRCode(controller.searchController);
                                  controller.getSearchResult();
                                },
                              ),
                            ],
                          ),
                        )
                ],
              ),
              SizedBox(height: 20.h),
              const SearchResults(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
