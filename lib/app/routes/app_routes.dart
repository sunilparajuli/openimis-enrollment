part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const WAITTING = _Paths.WAITTING;
  static const SEARCH = _Paths.SEARCH;
  static const SAVED = _Paths.SAVED;
  static const ROOT = _Paths.ROOT;
  static const CUSTOMER_PROFILE = _Paths.CUSTOMER_PROFILE;
  static const OTP = _Paths.OTP;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const WAITTING = '/waiting';
  static const ENROLLMENT = '/enrollment';
  static const SEARCH = '/search';
  static const SAVED = '/saved';
  static const COMPANY_PROFILE = '/company-profile';
  static const ROOT = '/root';
  static const CUSTOMER_PROFILE = '/customer-profile';
  static const OTP = '/otp';
  static const PARTNERS = '/partners';


}
