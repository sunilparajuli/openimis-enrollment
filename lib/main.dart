import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:openimis_app/app/language/languages.dart';
import 'package:openimis_app/app/modules/root/controllers/root_controller.dart';

import 'app/core/theme/app_theme.dart';
import 'app/core/theme/theme_service.dart';
import 'app/di/locator.dart';
import 'app/language/language_service.dart';
import 'app/modules/auth/bindings/auth_binding.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/auth/views/login/login_view.dart';
import 'app/modules/root/views/root_view.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  String? token = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $token");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  setupLocator();
  await GetStorage.init();
  await CountryCodes.init();
  final languageService = Get.put(LanguageService());
  final themeService = Get.put(ThemeService());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Get.put(AuthController());
  final rootController = Get.put(RootController());
  await Future.delayed(Duration(milliseconds: 100));
  await rootController.fetchConfigurations(); // Fetch configurations here
  await rootController.fetchSupportedPartners();


  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => GetMaterialApp(
        translations: Languages(),
        fallbackLocale: const Locale('en', 'US'),
        locale: languageService.currentLocale ?? const Locale('en', 'US'),//Get.locale,
        debugShowCheckedModeBanner: false,
        initialBinding: AuthBinding(),
        home: Obx(
              () => AuthController.to.currentUser != null
              ? const RootView()
              : const LoginView(),
        ),
        getPages: AppPages.routes,
        theme: themeService.isDarkTheme.value ? AppTheme.darkTheme : AppTheme.lightTheme,
        defaultTransition: Transition.cupertino,
      ),
    ),
  );
}
