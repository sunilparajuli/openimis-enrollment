import 'dart:async';

import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:openimis_app/app/data/local/config/app_config.dart';
import 'package:local_auth/local_auth.dart';

import '../../../data/local/entities/app_config_entity.dart';
import '../../../data/local/entities/user_entity.dart';
import '../../../data/remote/base/status.dart';
import '../../../data/remote/dto/auth/login_in_dto.dart';
import '../../../data/remote/dto/auth/login_out_dto.dart';
import '../../../data/remote/dto/auth/register_company_dto.dart';
import '../../../data/remote/dto/auth/register_company_out_dto.dart';
import '../../../data/remote/dto/auth/register_customer_dto.dart';
import '../../../data/remote/dto/auth/register_customer_out_dto.dart';
import '../../../data/remote/repositories/auth/auth_repository.dart';
import '../../../di/locator.dart';
import '../../../domain/enums/user_type.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/functions.dart';
import '../../../widgets/snackbars.dart';
import '../views/login/widgets/choose_bottom_sheet.dart';

class AuthController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  final GetStorage storage = GetStorage();
  var isBiometricEnabled = false.obs;

  static AuthController get to => Get.find();
  final _authRepository = getIt.get<AuthRepository>();
  final CountryDetails details = CountryCodes.detailsForLocale();

  /*
  * Customer Form Fields.
  * */
  final GlobalKey<FormState> customerFormKey = GlobalKey<FormState>();
  final customerFullNameController = TextEditingController();
  final customerPhoneNumController = TextEditingController();
  final customerEmailController = TextEditingController();
  final customerPasswordController = TextEditingController();

  /*
  * Company Form Fields
  * */
  final GlobalKey<FormState> companyFormKey = GlobalKey<FormState>();
  final companyNameController = TextEditingController();
  final companyBusinessNumberController = TextEditingController();
  final companyBusinessEmailController = TextEditingController();
  final companyAddressController = TextEditingController();
  final companyCountryController = TextEditingController();
  final companyPasswordController = TextEditingController();


  final Rx<Status> _configStatus = Rx(const Status.idle());

  Status get configStatus => _configStatus.value;


  /*
  * Login Form Fields
  * */
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  /*
  * Rx
  * */

  late final RxString _rxCountry;

  String get country => _rxCountry.value;

  final Rxn<UserEntity> _rxnCurrentUser = Rxn<UserEntity>();

  UserEntity? get currentUser => _rxnCurrentUser.value;

  final Rxn<AppConfigEntity> _rxnAppConfig = Rxn<AppConfigEntity>();

  AppConfigEntity? get appConfig => _rxnAppConfig.value;

  final Rx<Status<RegisterCustomerOutDto>> _rxRegisterCustomerState =
      Rx(const Status.idle());

  Status<RegisterCustomerOutDto> get registerCustomerState =>
      _rxRegisterCustomerState.value;

  final Rx<Status<RegisterCompanyOutDto>> _rxRegisterCompanyState =
      Rx(const Status.idle());

  Status<RegisterCompanyOutDto> get registerCompanyState =>
      _rxRegisterCompanyState.value;

  final Rx<Status<AppConfig>> _rxConfigState = Rx(const Status.idle());

  Status<AppConfig> get ConfigState => _rxConfigState.value;

  final Rx<Status<LoginOutDto>> _rxLoginState = Rx(const Status.idle());

  Status<LoginOutDto> get loginState => _rxLoginState.value;

  final RxBool _rxIsObscure = RxBool(true);

  bool get isObscure => _rxIsObscure.value;

  final Rx<RegisterType> _rxRegisterType = Rx(RegisterType.NOTSELECTED);

  RegisterType get registerType => _rxRegisterType.value;


  // OTP
  var isVerified = false.obs;
  var canResend = false.obs;
  var timeLeft = 60.obs;


  void verifyOtp(String otp) {
    // Perform OTP verification here
    // For now, let's just simulate a success response
    Future.delayed(Duration(seconds: 2), () {
      isVerified.value = true;
    });
  }

  void startTimer() {
    canResend.value = false;
    timeLeft.value = 60;

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }
  void resendOtp() {
    // Handle OTP resend logic here
    startTimer();
  }
  //
  @override
  void onInit() {
    super.onInit();
    _getCurrentUser();
    _rxCountry = RxString(details.dialCode!);
    isBiometricEnabled.value = storage.read('biometricEnabled') ?? false;
    onCountryChanged(Country(
        name: 'Nepal',
        dialCode: "977",
        flag: "",
        maxLength: 10,
        minLength: 10,
        code: 'NP'));
    // _rxCountry.value =  "977";//Country(name: 'Nepal', dialCode: "977",flag: "",maxLength: 10, minLength: 10);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    customerFullNameController.dispose();
    customerPhoneNumController.dispose();
    customerEmailController.dispose();
    customerPasswordController.dispose();
    companyNameController.dispose();
    companyBusinessEmailController.dispose();
    companyBusinessNumberController.dispose();
    companyCountryController.dispose();
    companyAddressController.dispose();
    companyPasswordController.dispose();
  }

  void _getCurrentUser() async {
    final result = await _authRepository.readStorage(key: 'user');
    result.whenOrNull(
        success: (data) => _rxnCurrentUser.value = UserEntity.fromMap(data));
  }

  void getAppConfig() async {
    final result = await _authRepository.readStorage(key: 'appconfig');
    result.whenOrNull(
        success: (data) => _rxnAppConfig.value = AppConfigEntity.fromMap(data));
  }

  void onCountryChanged(Country country) {
    _rxCountry.value = "+${country.dialCode}";
  }

  Future<void> onLoginSubmit() async {
    if (loginFormKey.currentState!.validate()) {
      await _login();
    }
  }

  Future<void> onRegisterSubmit() async {
    if (registerType == RegisterType.CUSTOMER &&
        customerFormKey.currentState!.validate()) {
      //await _registerCustomer(); registering insuree
    } else if (registerType == RegisterType.COMPANY &&
        companyFormKey.currentState!.validate()) {
      //other
    }
  }

  bool isFaculty() {
    return currentUser?.status == "FACULTY";
  }

  void logout() async {
    final result = await _authRepository.removeStorage(key: 'user');
    AuthController.to.currentUser!.token = null;
    AuthController.to.currentUser!.refresh = null;
    result.whenOrNull(success: (data) => Get.offAllNamed(Routes.LOGIN));
  }

  Future<void> _login() async {
    _rxLoginState.value = await _authRepository.login(
      dto: LoginInDto(
        username: loginEmailController.text,
        password: loginPasswordController.text,
      ),
    );
    loginState.whenOrNull(
      success: (data) {
        _saveUserInStorage(
            id: data!.username,
            email: data.email,
            name: "${data.firstName}  ${data.lastName}",
            // token: data.token!.access,
            token: data!.access,
            role: data.userType,
            refresh: data.refresh);
        storage.write('loginUsername', loginEmailController.text);
        storage.write('loginPassword',
            loginPasswordController.text); // Consider encryption here
        _getCurrentUser();
        Get.offAllNamed(Routes.ROOT);
        _clearTextControllers();
      },
      failure: showSnackBarOnFailure,
    );
  }


  void toggleBiometric(bool value) async {
    isBiometricEnabled.value = value;
    storage.write('biometricEnabled', value);
    if (value) {
      await enableBiometricAuthentication();
    }
  }

  Future<void> enableBiometricAuthentication() async {
    try {
      final canCheckBiometrics = await auth.canCheckBiometrics;
      final isBiometricAvailable =
          canCheckBiometrics || await auth.isDeviceSupported();

      if (isBiometricAvailable) {
        final isAuthenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to enable biometrics',
          options: AuthenticationOptions(biometricOnly: true),
        );

        if (isAuthenticated) {
          storage.write('biometricEnabled', true);
        } else {
          // Revert the toggle if authentication fails
          isBiometricEnabled.value = false;
          storage.write('biometricEnabled', false);
        }
      } else {
        // Handle case where biometric authentication is not available
        Get.snackbar('Biometric Unavailable',
            'Biometric authentication is not available on this device.');
      }
    } catch (e) {
      // Handle errors if necessary
      Get.snackbar('Biometric Error',
          'An error occurred during biometric authentication.');
    }
  }

  Future<void> tryBiometricAuthentication() async {
    final isEnabled = storage.read('biometricEnabled') ?? false;

    if (isEnabled) {
      try {
        final isAuthenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to login',
          options: AuthenticationOptions(biometricOnly: true),
        );

        if (isAuthenticated) {
          // Retrieve saved credentials
          final username = storage.read('loginUsername');
          final password = storage.read('loginPassword');

          if (username != null && password != null) {
            // Perform login with saved credentials
            await _loginWithSavedCredentials(username, password);
          } else {
            Get.snackbar('Error', 'No saved credentials found.');
          }
        } else {
          Get.snackbar(
              'Authentication Failed', 'Biometric authentication failed.');
        }
      } on PlatformException catch (e) {
        Get.snackbar('Authentication Error',
            'An error occurred during biometric authentication.');
        print(e);
      }
    }
  }

  Future<void> _loginWithSavedCredentials(
      String username, String password) async {
    _rxLoginState.value = await _authRepository.login(
      dto: LoginInDto(
        username: username,
        password: password,
      ),
    );
    loginState.whenOrNull(
      success: (data) {
        _saveUserInStorage(
            id: data!.username,
            email: data.email,
            name: "${data.firstName}  ${data.lastName}",
            token: data!.access,
            role: data.userType,
            refresh: data.refresh);
        _getCurrentUser();
        Get.offAllNamed(Routes.ROOT);
      },
      failure: showSnackBarOnFailure,
    );
  }

  void _saveUserInStorage(
      {String? id,
      String? email,
      String? name,
      String? phone,
      String? token,
      String? role,
      String? status,
      String? refresh}) async {
    await _authRepository.writeStorage(
      key: 'user',
      entity: UserEntity(
          id: id,
          name: name,
          email: email,
          phoneNumber: phone,
          token: token,
          role: role,
          status: status,
          refresh: refresh),
    );
  }

  void _saveConfigInStorage(
      {String? domainName,
      String? appVersion,
      String? supportEmail,
      String? apiBaseUrl}) async {
    await _authRepository.writeStorage(
      key: 'appconfig',
      entity: AppConfigEntity(
          domainName: domainName,
          appVersion: appVersion,
          apiBaseUrl: apiBaseUrl,
          supportEmail: supportEmail),
    );
  }

  void toggleObscurePassword() {
    _rxIsObscure.value = !isObscure;
  }

  void _clearTextControllers() {
    loginEmailController.clear();
    loginPasswordController.clear();
    customerFullNameController.clear();
    customerPhoneNumController.clear();
    customerEmailController.clear();
    customerPasswordController.clear();
    companyNameController.clear();
    companyBusinessEmailController.clear();
    companyBusinessNumberController.clear();
    companyCountryController.clear();
    companyAddressController.clear();
    companyPasswordController.clear();
  }

  void onSignUp() {
    popupBottomSheet(
      bottomSheetBody: const ChooseBottomSheetBody(),
      isDismissible: true,
      enableDrag: true,
    );
  }

  void onSelectRegisterType(RegisterType type) {
    if (type != RegisterType.NOTSELECTED) {
      _rxRegisterType.value = type;
      Get.offAllNamed(Routes.REGISTER);
    }
  }

  void showSnackBarOnFailure(String? err) {
    Get.closeAllSnackbars();
    SnackBars.failure("Oops!", err.toString());
  }
}
