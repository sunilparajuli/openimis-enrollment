import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/database_helper.dart';
import '../views/widgets/qr_view.dart';
import 'dart:io';

class PolicyController extends GetxController with SingleGetTickerProviderMixin {
  final GlobalKey<FormState> policyFormKey = GlobalKey<FormState>();
  final headInsureeChfidController = TextEditingController();
  final receiptNoController = TextEditingController();
  final noOfFamilyController = TextEditingController();
  final amountController = TextEditingController();
  final enrolledDateController = TextEditingController();
  var selectedTabIndex = 0.obs;
  late TabController tabController;

  RxString attachmentName = ''.obs;

  var selectedFile = Rxn<File>();
  var selectedFileName = ''.obs;
  File? attachment;

  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      selectedFile.value = File(result.files.single.path!);
      selectedFileName.value = result.files.single.name;
    }
  }

  void removeAttachment() {
    selectedFile.value = null;
    selectedFileName.value = '';
  }

  RxList<Map<String, dynamic>> policies = <Map<String, dynamic>>[].obs;

  PolicyController() {
    enrolledDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    noOfFamilyController.addListener(_updateAmount);
    fetchPolicies(); // Initial fetch to load policies
  }

  void setAttachment(File file) {
    attachment = file;
    attachmentName.value = file.path.split('/').last;
  }

  void resetForm() {
    headInsureeChfidController.clear();
    receiptNoController.clear();
    noOfFamilyController.clear();
    amountController.clear();
    enrolledDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    policyFormKey.currentState?.reset();
  }

  void _updateAmount() {
    int noOfFamily = int.tryParse(noOfFamilyController.text) ?? 0;
    int amount = 0;

    if (noOfFamily > 0 && noOfFamily <= 5) {
      amount = 3500;
    } else if (noOfFamily > 5) {
      amount = 3500 + ((noOfFamily - 5) * 700);
    }

    amountController.text = amount.toString();
  }

  Future<void> scanQRCode(TextEditingController controller) async {
    final result = await Get.to(QRViewExample(controller: controller));
    if (result != null) {
      controller.text = result;
    }
  }

  Future<void> savePolicy() async {
    if (policyFormKey.currentState!.validate()) {
      final policyData = {
        'headInsureeChfid': headInsureeChfidController.text,
        'receiptNo': receiptNoController.text,
        'noOfFamily': int.parse(noOfFamilyController.text),
        'amount': int.parse(amountController.text),
        'enrolledDate': enrolledDateController.text,
      };

     // await DatabaseHelper().insertPolicy(policyData);
      fetchPolicies(); // Refresh policies list
      Get.snackbar('Success', 'Policy saved successfully');
      resetForm();
    }
  }

  Future<void> savePolicyOffline() async {
    if (policyFormKey.currentState!.validate()) {
      final policyData = {
        'headInsureeChfid': headInsureeChfidController.text,
        'receiptNo': receiptNoController.text,
        'noOfFamily': int.parse(noOfFamilyController.text),
        'amount': int.parse(amountController.text),
        'enrolledDate': enrolledDateController.text,
      };

      //await DatabaseHelper().insertPolicy(policyData);
      fetchPolicies(); // Refresh policies list
      Get.snackbar('Offline Save', 'Policy saved offline successfully');
      resetForm();
    }
  }

  Future<List<Map<String, dynamic>>> fetchPolicies() async {
    // final List<Map<String, dynamic>> fetchedPolicies = await DatabaseHelper().queryAllPolicies();
    // policies.value = fetchedPolicies; // Update the RxList
    //return fetchedPolicies; // Return the list
    return [{}];
  }
  @override
  void onClose() {
    headInsureeChfidController.dispose();
    receiptNoController.dispose();
    noOfFamilyController.dispose();
    amountController.dispose();
    enrolledDateController.dispose();
    super.onClose();
  }
}
