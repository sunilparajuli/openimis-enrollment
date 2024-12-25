import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/data/remote/dto/customer/claim_is_dto.dart';
import 'package:openimis_app/app/modules/Insuree/views/profile.dart';

import '../../../data/remote/base/idto.dart';
import '../../../data/remote/base/status.dart';
import '../../../data/remote/dto/customer/claim_out_dto.dart';
import '../../../data/remote/repositories/customer/customer_repository.dart';
import '../../../di/locator.dart';


class CustomerProfileController extends GetxController {
  final customerRepository = getIt.get<CustomerRepository>();
  final searchController = TextEditingController();


  final Rx<Status<List<Claim>>> _rxClaimResults =
  Rx<Status<List<Claim>>>(const Status.idle());

  Status<List<Claim>> get claimResults => _rxClaimResults.value;


  final Rx<Status<InsureeClaimResponse>> _rxClaimServItemResults =
  Rx<Status<InsureeClaimResponse>>(const Status.idle());

  Status<InsureeClaimResponse> get claimServItemResults => _rxClaimServItemResults.value;


  final Rx<Status<FHIRPatient>> _rxFHIRPatient =
  Rx<Status<FHIRPatient>>(const Status.idle());

  Status<FHIRPatient> get fhirPatient => _rxFHIRPatient.value;

  final Rx<Status> _rxFcmToken =
  Rx<Status>(const Status.idle());

  Status get getFcmToken => _rxFcmToken.value;

  @override
  void onInit() {
    super.onInit();
    // getProfile();
    final isProfilePage = Get.currentRoute == '/profile'; // Example route check
    loadPage(isProfilePage: isProfilePage);

  }


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  var _notificationsEnabled = false.obs; // Reactive bool for idle state

  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled.value = value;
    // Add logic for enabling/disabling notifications
  }
  Future<String?> getFcmDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("FCM Token: $token");
      return token;
    } catch (e) {
      print("Error getting FCM Token: $e");
      return null;
    }
  }

   getProfile() async {
    _rxFHIRPatient.value = Status.loading();
    final Status<FHIRPatient> results = await customerRepository.getProfile();
    _rxFHIRPatient.value = results;
  }


  getClaimResults() async {
    _rxClaimResults.value = Status.loading();
    if (true) {
      final Status<List<Claim>> results =
      await customerRepository.getAllCalims(customerUuid: "112112");
      _rxClaimResults.value = results;
    }
  }

  getClaimServItemsResults(int claimID) async {
    _rxClaimServItemResults.value = Status.loading();
    if (true) {
      final Status<InsureeClaimResponse> results =
      await customerRepository.getServItems(claimID: claimID);
      _rxClaimServItemResults.value = results;
    }
  }

  saveFcmToken() async {
    _rxFcmToken.value = Status.loading();
    if (true) {
      final token = await getFcmDeviceToken();
      final Status results =
      await customerRepository.postDeviceToken(fcmToken: token!);
      _rxFcmToken.value = results;
    }
  }
  void loadPage({required bool isProfilePage}) {
    if (isProfilePage) {
      getProfile();
    } else {
      getClaimResults();
    }
    showDialogOnFailure();
  }

  void onRetry() async {
    await getClaimResults();
    showDialogOnFailure();
  }

  void showDialogOnFailure() {

  }
}
