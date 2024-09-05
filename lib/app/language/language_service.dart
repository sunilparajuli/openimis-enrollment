import 'dart:ui';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

class LanguageService {
  final _storage = GetStorage(); // Assuming you're using GetStorage for persistence
  final Rx<Locale?> _selectedLocale = Rx<Locale?>(null);

  LanguageService() {
    _loadCurrentLocale();
  }

  void _loadCurrentLocale() async {

    final localeCode = await _storage.read<String>('language');
    if (localeCode != null) {
      final parts = localeCode.split('_');
      _selectedLocale.value = Locale(parts[0], parts.length > 1 ? parts[1] : '');
      Get.updateLocale(_selectedLocale.value!);
    }
  }

  void updateLocale(Locale locale) async {
    _selectedLocale.value = locale;
    Get.updateLocale(locale);
    final localeString = '${locale.languageCode}_${locale.countryCode}';
    await _storage.write('language', localeString);
    print('Locale written to storage: $localeString');
  }


  Locale? get currentLocale => _selectedLocale.value;
}
