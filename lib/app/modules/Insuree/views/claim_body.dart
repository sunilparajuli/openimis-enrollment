import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/core/values/strings.dart';
import 'package:openimis_app/app/modules/Insuree/controllers/customer_profile_controller.dart';
import '../../../widgets/custom_text_field.dart';
import 'claim_lists.dart';

class ClaimBody extends GetView<CustomerProfileController> {
  const ClaimBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // No need for Expanded here
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
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
                    //onChanged: (_) => controller.getSearchResult(),
                    //onSuffixTap: () => controller.clearSearch(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            ClaimResults(), // Your ClaimResults widget here
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
