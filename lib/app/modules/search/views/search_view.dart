import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/widgets/openimis_appbar.dart';

import '../controllers/search_controller.dart';
import 'widgets/body.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Get.theme.backgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: OpenIMISAppBar(
            title: 'search'.tr,
            showActions: false,
        ),
        body: Body(),
      ),
    );
  }
}
