import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/remote/base/status.dart';




class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final _homeScrollController = ScrollController();

  ScrollController get homeScrollController => _homeScrollController;

  final RxInt _indicatorIndex = 0.obs;

  int get indicatorIndex => _indicatorIndex.value;

  final RxString _rxChipTitle = RxString("All");

  String? get chipTitle => _rxChipTitle.value;


  final Rx<Status<String>> _rxCustomerAvatar =
      Rx<Status<String>>(const Status.loading());

  Status<String> get customerAvatar => _rxCustomerAvatar.value;

  var currentStep = 0.obs;

  void nextStep() {
    if (currentStep.value < 2) { // 2 because we have 3 pages (0, 1, 2)
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void restartHelp() {
    currentStep.value = 0;
  }

  @override
  void onInit() {
    super.onInit();
    _loadHome();
  }





  updateIndicatorValue(newIndex, _) {
    _indicatorIndex.value = newIndex;
  }



  void animateToStart() {
    _homeScrollController.animateTo(0.0,
        duration: const Duration(seconds: 1), curve: Curves.easeOut);
  }


  void _loadHome() async {

  }




}
