import 'package:get/get.dart';
import 'package:openimis_app/app/language/language_service.dart';
import 'package:openimis_app/app/modules/Insuree/controllers/customer_profile_controller.dart';
import 'package:openimis_app/app/modules/enrollment/controller/enrollment_controller.dart';
import 'package:openimis_app/app/modules/home/controllers/home_controller.dart';
import 'package:openimis_app/app/modules/root/controllers/root_controller.dart';
import '../../../core/theme/theme_service.dart';
import '../../public_enrollment/controller/public_enrollment_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<RootController>(() => RootController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CSearchController>(() => CSearchController());
    Get.lazyPut<EnrollmentController>(() => EnrollmentController());
    Get.lazyPut<PublicEnrollmentController>(() => PublicEnrollmentController());
    Get.lazyPut<CustomerProfileController>(() => CustomerProfileController());
    Get.lazyPut<LanguageService>(() => LanguageService());
    Get.lazyPut<ThemeService>(() => ThemeService());
  }
}
