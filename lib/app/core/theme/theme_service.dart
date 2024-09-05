import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  final _storage = GetStorage();
  final isDarkTheme = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkTheme.value = _loadThemeFromStorage();
    _applyTheme(isDarkTheme.value);
  }

  bool _loadThemeFromStorage() {
    return _storage.read('isDarkTheme') ?? false;
  }

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
    _storage.write('isDarkTheme', isDarkTheme.value);
    _applyTheme(isDarkTheme.value);
  }

  void _applyTheme(bool isDark) {
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
