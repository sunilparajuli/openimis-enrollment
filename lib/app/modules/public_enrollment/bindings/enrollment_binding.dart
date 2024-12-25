import 'package:get/get.dart';

import '../controller/public_enrollment_controller.dart';



class EnrollmentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PublicEnrollmentController>(
          () => PublicEnrollmentController(),
    );
  }
}
