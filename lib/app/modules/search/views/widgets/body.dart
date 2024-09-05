import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/core/values/strings.dart';

import '../../../../widgets/custom_text_field.dart';
import '../../../enrollment/controller/enrollment_controller.dart';
import '../../controllers/search_controller.dart';
import 'search_items.dart';

class Body extends GetView<CSearchController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use Get.find to get the instance of EnrollmentController
    final EnrollmentController _encontroller = Get.find<EnrollmentController>();
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller.searchController,
                      autofocus: false,
                      hintText: '${AppStrings.SEARCH_HINT}'.tr,
                      isSearchBar: true,
                      maxLines: 1,
                      prefixIcon: HeroIcons.magnifyingGlass,
                      suffixIcon: HeroIcons.xMark,
                      onChanged: (_) => controller.getSearchResult(),
                      onSuffixTap: () => controller.clearSearch(),
                    ),
                  ),
                  IconButton(
                    icon: HeroIcon(HeroIcons.qrCode),
                    onPressed: () async {
                      await controller.scanQRCode(controller.searchController);
                      controller.getSearchResult();
                    },
                  ),
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
