import 'package:get/get.dart';

import '../../../data/remote/base/status.dart';
import '../../../data/remote/repositories/customer/customer_repository.dart';
import '../../../di/locator.dart';
import '../../../widgets/dialogs.dart';
import '../../auth/controllers/auth_controller.dart';

class CustomerProfileController extends GetxController {
  final customerRepository = getIt.get<CustomerRepository>();


  @override
  void onInit() {
    super.onInit();
    loadPage();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getProfile() async {
    final state = await customerRepository.getProfile(
        customerUuid: AuthController.to.currentUser!.id!);
  }

  void loadPage() async {
    await getProfile();
    showDialogOnFailure();
  }

  void onRetry() async {
    await getProfile();
    showDialogOnFailure();
  }

  void showDialogOnFailure() {

  }
}
