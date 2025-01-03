import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/company_profile_controller.dart';
import 'about_us.dart';


class CompanyTabView extends GetView<CompanyProfileController> {
  const CompanyTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller.tabController,
      children: const [
        AboutUs(),

      ],
    );
  }
}
