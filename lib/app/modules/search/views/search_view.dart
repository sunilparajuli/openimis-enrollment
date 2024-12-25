import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/root/controllers/root_controller.dart';
import 'package:openimis_app/app/widgets/openimis_appbar.dart';

import '../controllers/search_controller.dart';
import 'widgets/body.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RootController _rootController = Get.put(RootController());
    return SafeArea(
      child: Scaffold(
        backgroundColor: Get.theme.backgroundColor,
        resizeToAvoidBottomInset: true,
        appBar: OpenIMISAppBar(
            title: 'search'.tr,
            showActions: false,
        ),
        body: Column(
          children: [
            // Display connection status
            // Obx(() => Text(
            //   _rootController.connectionType == MConnectivityResult.wifi
            //       ? "Wifi Connected"
            //       : _rootController.connectionType == MConnectivityResult.mobile
            //       ? 'Mobile Data Connected'
            //       : 'No Internet Available',
            //   style: const TextStyle(fontSize: 20),
            // )),
            // Add your Body() widget below the status
            Expanded(child: Body()),
          ],
        ),
      ),
    );
  }
}
