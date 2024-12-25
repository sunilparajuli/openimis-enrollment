import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/Insuree/controllers/customer_profile_controller.dart';
import 'package:openimis_app/app/modules/Insuree/views/profile_body.dart';
import 'package:openimis_app/app/widgets/openimis_appbar.dart';


class ProfileView extends GetView<CustomerProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: OpenIMISAppBar(title: "Profile",),

      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Get.theme.colorScheme.background,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child:  SafeArea(child: ProfileBody()),
      ),
    );
  }
}
