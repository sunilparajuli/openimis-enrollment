import 'package:get_storage/get_storage.dart';


class ApiRoutes {
  static final storage = GetStorage();
  static const BASE_URL = "http://10.0.2.2:8000";
  //static const BASE_URL = "http://192.168.4.136:8000";
  static const _API = "/api/membership";
  static const APP_CONFIG = "$_API/config";
  static const ENROLLMENT = "$_API/enrollment/";
  static const LOCATIONS = "$_API/locations";
  static const HOSPITALS = "$_API/hospitals";
  static const MEMBERSHIP_CARD = "$_API/membership/card/";
  static const SEARCH = "$_API/insuree-information/";
  static const LOGIN = "$_API/login";
  static const CUSTOMERS = "$_API/profile";
  static const TOGGLE_SAVE = "$CUSTOMERS/save/";



}
