import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:openimis_app/app/data/remote/repositories/root/root_repository.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../../data/remote/base/status.dart';
import '../../../di/locator.dart';
import '../../../language/language_service.dart';
import '../../../widgets/dialogs.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../search/controllers/search_controller.dart';

class RootController extends GetxController {
  static RootController get to => Get.find();
  final persistentTabController = PersistentTabController(initialIndex: 0);
  final GetStorage _storage = GetStorage(); // Use GetStorage for local storage

  final _rootRepository = getIt.get<RootRepository>();

  final Rx<Status> _configStatus = Rx(const Status.idle());

  Status get configStatus => _configStatus.value;

  var notices = <Map<String, String>>[].obs;

  RxList<Map<String, String>> supportedPartners = <Map<String, String>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchConfigurations();
    fetchSupportedPartners();
    fetchDummyNotices();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    persistentTabController.dispose();
  }

  void onHomeDoubleClick() {
    HomeController.to.animateToStart();
  }

  // Method to fetch dummy notices
  void fetchDummyNotices() {
    notices.value = [
      {
        'title': 'System Maintenance',
        'description': 'Our system will undergo maintenance on 25th September from 12:00 AM to 2:00 AM.',
        'date': '2024-09-20',
      },
      {
        'title': 'New Policy Update',
        'description': 'We have updated our insurance policies. Please review the changes on the policy page.',
        'date': '2024-09-18',
      },
      {
        'title': 'Holiday Notice',
        'description': 'Our office will remain closed on 1st October due to a public holiday.',
        'date': '2024-09-15',
      },
      {
        'title': 'Insurance Claim Process Change',
        'description': 'We have simplified the claim process. Kindly refer to the updated steps on our website.',
        'date': '2024-09-10',
      },
    ];
  }
  void onSearchDoubleClick() {
    CSearchController.to.clear();
  }
  
  void logout() {
    Dialogs.warningDialog(
      title: "logout_message".tr,
      btnOkText: "Logout".tr,
      btnOkOnPress: AuthController.to.logout,
    );
  }

  Future<void> fetchConfigurations() async { // Change return type to Future<void>
    _configStatus.value = Status.loading();
    try {
      final configStatus = await _rootRepository.fetchConfig();
      configStatus.whenOrNull(
        success: (data) {
          _configStatus.value = Status.success(data: data);

          // Assuming the languages are part of the data
          supportedPartners.value = List<Map<String, String>>.from(data['supported_partners'] ?? []);

          // Update the language if it's part of the config
          final languageService = Get.find<LanguageService>();
          if (data['language'] != null) {
            final parts = (data['language'] as String).split('_');
            final locale = Locale(parts[0], parts.length > 1 ? parts[1] : '');
            languageService.updateLocale(locale);
          }
        },
        failure: (error) {
          _configStatus.value = Status.success();
        },
      );
    } catch (e) {
      _configStatus.value = Status.success();
    }
  }


  Future<void> fetchSupportedPartners() async {
    try {
      final configData = await _storage.read('configurations') as Map<String, dynamic>?;
      if (configData != null) {
        final partnersList = configData['supported_partners'] as List<dynamic>;
        supportedPartners.value = partnersList
            .map((item) => Map<String, String>.from(item as Map<dynamic, dynamic>))
            .toList();
      }
    } catch (e) {
      print('Error reading supported partners: $e');
      supportedPartners.value = [];
    }
  }

  onSavedDoubleClick() {}


}
