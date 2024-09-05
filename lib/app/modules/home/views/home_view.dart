import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import '../../../widgets/custom_appbar.dart';
import '../controllers/home_controller.dart';
import 'widgets/body.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Get.theme.backgroundColor,
        appBar: CustomAppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 16.w, bottom: 8.w, top: 8.w),
            child: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child:  HeroIcon(
                HeroIcons.bars4,
                size: 70,
                color: Colors.teal.shade900,
                style: HeroIconStyle.solid, // Use solid style for a filled icon
              ),
            ),
          ),
          //title: "Dashboard",
        ),
        body: const Body(),
      ),
    );
  }
}
