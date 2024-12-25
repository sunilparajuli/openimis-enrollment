import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:openimis_app/app/modules/Insuree/controllers/customer_profile_controller.dart';
import 'package:openimis_app/app/modules/Insuree/views/claim_body.dart';

import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_bottom_sheet.dart';


class ClaimView extends GetView<CustomerProfileController> {
  const ClaimView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerProfileController controller = Get.put(CustomerProfileController());
    controller.loadPage(isProfilePage: false);
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      resizeToAvoidBottomInset: false,

      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Get.theme.colorScheme.background,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child:  SafeArea(child: ClaimBody()),
      ),
    );
  }
}
