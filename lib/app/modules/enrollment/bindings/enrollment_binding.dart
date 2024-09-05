import 'package:get/get.dart';

import '../controller/enrollment_controller.dart';

class EnrollmentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnrollmentController>(
          () => EnrollmentController(),
    );
  }
}
