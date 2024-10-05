import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:openimis_app/app/data/remote/repositories/enrollment/enrollment_repository.dart';
import 'package:openimis_app/app/modules/enrollment/controller/LocationDto.dart';
import 'package:openimis_app/app/modules/enrollment/controller/MembershipDto.dart';
import 'package:openimis_app/app/modules/policy/views/widgets/qr_view.dart';

import '../../../data/remote/base/status.dart';
import '../../../di/locator.dart';
import '../../../utils/database_helper.dart';
import '../../../utils/functions.dart';
import '../../../widgets/snackbars.dart';
import '../views/widgets/enrollment_form.dart';
import '../views/widgets/enrollment_members.dart';
import '../views/widgets/qr_view.dart';
import '../views/widgets/submit_botton_sheet.dart';
import 'DropdownDto.dart';
import 'EnrollmentDto.dart';
import 'HospitalDto.dart';

class EnrollmentController extends GetxController with SingleGetTickerProviderMixin {
  final GlobalKey<FormState> enrollmentFormKey = GlobalKey<FormState>();
  final _enrollmentRepository = getIt.get<EnrollmentRepository>();
  final chfidController = TextEditingController();
  final eaCodeController = TextEditingController();
  final lastNameController = TextEditingController();
  final givenNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final identificationNoController = TextEditingController();
  final birthdateController = TextEditingController();
  final headChfidController = TextEditingController();
  var gender = ''.obs;
  var maritalStatus = ''.obs;
  var relationShip = ''.obs;
  var isHead = false.obs;
  var povertyStatus = false.obs;
  var newEnrollment = true.obs;
  var photo = Rx<XFile?>(null);
  var selectedTabIndex = 0.obs;

  var selectedHealthFacilityLevel = ''.obs;
  var selectedHealthFacility = ''.obs;
  var selectedFamilyType = ''.obs;
  var selectedConfirmationType = ''.obs;
  final  confirmationNumber = TextEditingController();
  final  addressDetail = TextEditingController();

  final _enrollmentScrollController = ScrollController();
  final Rx<Status<EnrollmentDto>> _rxEnrollmentState = Rx(const Status.idle());

  Status<EnrollmentDto> get enrollmentState => _rxEnrollmentState.value;

  final Rx<Status<MemberShipCard>> _rxMemberShipCard = Rx(const Status.idle());

  Status<MemberShipCard> get membershipState => _rxMemberShipCard.value;

  ScrollController get enrollmentScrollController =>
      _enrollmentScrollController;
  final ImagePicker _picker = ImagePicker();
  var shouldHide = false.obs;
  bool dev = true;

  var filteredEnrollments = <Map<String, dynamic>>[].obs;
  var searchText = ''.obs;
  var enrollments = <Map<String, dynamic>>[].obs;


  var selectedEnrollments = <int>[].obs;
  var isAllSelected = false.obs;


  void toggleSelectAll(bool selectAll) {
    isAllSelected.value = selectAll;
    selectedEnrollments.clear();
    if (selectAll) {
      selectedEnrollments.addAll(
        filteredEnrollments.map<int>((enrollment) => enrollment['id'] as int),
      );
    }
  }


  void toggleEnrollmentSelection(int id, bool isSelected) {
    if (isSelected) {
      selectedEnrollments.add(id);
    } else {
      selectedEnrollments.remove(id);
    }
    isAllSelected.value = selectedEnrollments.length == filteredEnrollments.length;
  }


  final Rx<Status<List<LocationDto>>> _rxLocationState = Rx(const Status.idle());

  Status<List<LocationDto>> get locationState => _rxLocationState.value;

  final Rx<Status<List<HealthServiceProvider>>> _rxHospitalState = Rx(const Status.idle());

  Status<List<HealthServiceProvider>> get hospitalState => _rxHospitalState.value;



  var selectedRegion = Rxn<LocationDto>();

  var selectedDistrict = Rxn<District>();
  var selectedMunicipality = Rxn<Municipality>();
  var selectedVillage = Rxn<Village>();

  var districts = <District>[].obs;
  var municipalities = <Municipality>[].obs;
  var villages = <Village>[].obs;
  late TabController tabController;


  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });
    fetchEnrollments();
    getAllLocations();
    getAllHospitals();
    if (dev) {
      initializeDummyData();
    }
    ever(newEnrollment, handleNewEnrollmentChange);
    debounce(searchText, (_) => filterEnrollments(),
        time: Duration(milliseconds: 300));
  }


  var familyTypeCodes = <FamilyType>[].obs;
  var confirmationTypes = <ConfirmationType>[].obs;
  final GetStorage _storage = GetStorage(); // Use GetStorage for local storage


  Future<void> fetchConfigData() async {
    try {
      final configData = await _storage.read('configurations') as Map<String, dynamic>?;
      if (configData != null) {
        // Retrieve family_type_codes
        final familyTypes = configData['family_type_codes'] as Map<String, dynamic>;
        familyTypeCodes.value = familyTypes.entries
            .map((entry) => FamilyType(name: entry.key, code: entry.value))
            .toList();

        // Retrieve confirmation_types
        final confirmationTypesData = configData['confirmation_types'] as Map<String, dynamic>;
        confirmationTypes.value = confirmationTypesData.entries
            .map((entry) => ConfirmationType(name: entry.key, code: entry.value))
            .toList();
      }
    } catch (e) {
      print('Error reading config data: $e');
      familyTypeCodes.value = [];
      confirmationTypes.value = [];
    }
  }



  Future<void> getAllLocations() async {
    final Status<List<LocationDto>> state = await _enrollmentRepository.getLocations();
    state.whenOrNull(
      success: (data) {
        _rxLocationState.value = state;
      }
    );
  }

  Future<void> getAllHospitals() async {
    _rxHospitalState.value = Status.loading();
    final Status<List<HealthServiceProvider>> state = await _enrollmentRepository.getHospitals();
    state.whenOrNull(
        success: (data) {
          _rxHospitalState.value = state;
        }
    );
  }

  Future<void> getMembershipCard(String uuid) async {
    _rxMemberShipCard.value = Status.loading();
    final Status<MemberShipCard> state = await _enrollmentRepository.getMembershipCard(uuid: uuid);
    state.whenOrNull(
        success: (data) {
          _rxMemberShipCard.value = state;
        }
    );
  }

  void filterEnrollments() {
    final query = searchText.value.toLowerCase();
    if (query.isEmpty) {
      filteredEnrollments.value = enrollments;
    } else {
      filteredEnrollments.value = enrollments.where((enrollment) {
        final chfid = enrollment['chfid'].toString().toLowerCase();
        return chfid.contains(query);
      }).toList();
    }
    print('Filtered enrollments: ${filteredEnrollments.length}');
  }

  Future<void> deleteEnrollment(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteEnrollment(id);
    fetchEnrollments();
  }

  Future<void> fetchEnrollments() async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.retrieveAllEnrollments();
    enrollments.value =  data;
    filterEnrollments();
    print('Fetched enrollments: ${enrollments.length}');
  }

  void editEnrollment(Map<String, dynamic> enrollment) {
    chfidController.text = enrollment['chfid'];
    eaCodeController.text = enrollment['eaCode'] ?? '';
    lastNameController.text = enrollment['lastName'];
    givenNameController.text = enrollment['givenName'];
    phoneController.text = enrollment['phone'];
    emailController.text = enrollment['email'] ?? '';
    identificationNoController.text = enrollment['identificationNo'] ?? '';
    birthdateController.text = enrollment['birthdate'];
    gender.value = enrollment['gender'] ?? '';
    maritalStatus.value = enrollment['maritalStatus'] ?? '';
    isHead.value = enrollment['isHead'] == 1;
    headChfidController.text = enrollment['headChfid'] ?? '';
    newEnrollment.value = enrollment['newEnrollment'] == 1;
  }


  Future<void> updateEnrollment(enrollment) async {
    final dbHelper = DatabaseHelper();
    return;
    // final existingEnrollment = await dbHelper. .queryEnrollmentByChfid(
    //     chfidController.text);
    //
    // if (existingEnrollment != null &&
    //     existingEnrollment['id'] != enrollment['id']) {
    //   SnackBars.failure("Error", "CHFID already exists.");
    //   return;
    // }
    //
    // final updatedData = {
    //   'phone': phoneController.text,
    //   'birthdate': birthdateController.text,
    //   'chfid': chfidController.text,
    //   'eaCode': eaCodeController.text,
    //   'email': emailController.text,
    //   'gender': gender.value,
    //   'givenName': givenNameController.text,
    //   'identificationNo': identificationNoController.text,
    //   'isHead': isHead.value ? 1 : 0,
    //   'lastName': lastNameController.text,
    //   'maritalStatus': maritalStatus.value,
    //   'headChfid': headChfidController.text,
    //   'newEnrollment': newEnrollment.value ? 1 : 0,
    // };
    //
    // await dbHelper.updateEnrollment(updatedData);
    // fetchEnrollments();
    // SnackBars.success("Success", "Enrollment updated successfully.");
  }

  Future<void> onEnrollmentSubmit({bool offlineTrue = true}) async {
    try {
      _rxEnrollmentState.value = Status.loading();

      handleNewEnrollmentChange(newEnrollment.value);

      final dbHelper = DatabaseHelper();
      //final existingEnrollment = '1';
      //await dbHelper.queryEnrollmentByChfid(
      //    chfidController.text);

      // if (existingEnrollment != null) {
      //   SnackBars.failure("Error", "CHFID already exists.");
      //   return;
      // }

      String? photoBase64;
      if (photo.value != null) {
        photoBase64 = await _encodePhotoToBase64(photo.value!);
      }

      final enrollmentData = {
        'phone': phoneController.text,
        'birthdate': birthdateController.text,
        'chfid': chfidController.text,
        'eaCode': eaCodeController.text,
        'email': emailController.text,
        'gender': gender.value,
        'givenName': givenNameController.text,
        'identificationNo': identificationNoController.text,
        'isHead': isHead.value ? 1 : 0,
        'lastName': lastNameController.text,
        'maritalStatus': maritalStatus.value,
        'headChfid': headChfidController.text,
        'newEnrollment': newEnrollment.value ? 1 : 0,
        'photo': photoBase64 ?? "",
        'remarks': "",
        // Additional fields to save
        'healthFacilityLevel': selectedHealthFacilityLevel.value,
        'healthFacility': selectedHealthFacility.value,
        'familyType': selectedFamilyType.value,
        'confirmationType': selectedConfirmationType.value,
        'confirmationNumber': confirmationNumber.text,
        'addressDetail': addressDetail.text,
        'relationShip': relationShip.value,
      };

      if (offlineTrue) {
        await dbHelper.insertEnrollment(enrollmentData);
        SnackBars.success("Success", "Enrollment saved locally.");
        fetchEnrollments();
      } else {
        final response = await _enrollmentRepository.create(
          dto: EnrollmentDto(
            phone: phoneController.text,
            birthdate: birthdateController.text,
            chfid: chfidController.text,
            eaCode: eaCodeController.text,
            email: emailController.text,
            gender: gender.value,
            givenName: givenNameController.text,
            identificationNo: identificationNoController.text,
            isHead: isHead.value,
            lastName: lastNameController.text,
            maritalStatus: maritalStatus.value,
            headChfid: headChfidController.text,
            newEnrollment: newEnrollment.value,
            photo: photoBase64 ?? "",
            healthFacilityLevel: selectedHealthFacilityLevel.value,
            healthFacility: selectedHealthFacility.value,
            familyType: selectedFamilyType.value,
            confirmationType: selectedConfirmationType.value,
            confirmationNumber: confirmationNumber.text,
            addressDetail: addressDetail.text,
            relationShip: relationShip.value,
          ),
        );
        if (!response.error) {
          FocusManager.instance.primaryFocus?.unfocus();
          resetForm();
          Get.back();
          popupBottomSheet(bottomSheetBody: const SubmitBottomSheet());
        } else {
          SnackBars.failure("Oops!", response.message);
        }
      }
    } catch (error) {
      SnackBars.failure("Error", "An error occurred: $error");
    } finally {
      _rxEnrollmentState.value = Status.idle();
    }
  }

  String generateRandomChfid() {
    final random = Random();
    return List.generate(10, (_) => random.nextInt(10)).join();
  }

  void initializeDummyData() {
    chfidController.text = generateRandomChfid();
    eaCodeController.text = 'EA12345';
    lastNameController.text = 'Doe';
    givenNameController.text = 'John';
    phoneController.text = '+1234567890';
    emailController.text = 'john.doe@example.com';
    identificationNoController.text = 'ID123456789';
    birthdateController.text = '1980-01-01';
    gender.value = 'Male';
    isHead.value = false;
    headChfidController.text = chfidController.text;
    newEnrollment.value = false;
  }

  Future<String> _encodePhotoToBase64(XFile photo) async {
    final bytes = await File(photo.path).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> scanQRCode(TextEditingController controller) async {
    try {
      // Navigate to a page that uses QRView widget to scan the QR code
      final result = await Get.to(() => QRViewEnrollment(controller: controller));

      if (result != null) {
        controller.text = result;
      } else {
        SnackBars.failure("Failed", "QR code scan was unsuccessful.");
      }
    } catch (e) {
      SnackBars.failure("Error", "An error occurred while scanning the QR code.");
    }
  }
  void resetForm() {
    chfidController.clear();
    eaCodeController.clear();
    lastNameController.clear();
    givenNameController.clear();
    phoneController.clear();
    emailController.clear();
    identificationNoController.clear();
    birthdateController.clear();
    gender.value = '';
    maritalStatus.value = '';
    isHead.value = false;
    photo.value = null;
    newEnrollment.value = true;
    enrollmentFormKey.currentState?.reset();
  }

  Future<void> pickAndCropPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      );

      if (croppedFile != null) {
        photo.value = XFile(croppedFile.path);
      }
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      birthdateController.text = "${picked.toLocal()}".split(' ')[0];
    }
  }

  void handleNewEnrollmentChange(bool value) {
    if (value) {
      isHead.value = true;
      headChfidController.text = chfidController.text;
    } else {
      isHead.value = false;
      headChfidController.clear();
    }
  }

  void showSnackBarOnFailure(String? err) {
    Get.closeAllSnackbars();
    SnackBars.failure("Oops!", err.toString());
    _rxEnrollmentState.value = Status.idle();
  }


  Future<void> confirmAddMember(int enrollmentId) async {
    Get.defaultDialog(
        title: "Add Member",
        middleText: "Are you sure you want to add a new member?",
        textCancel: "No",
        textConfirm: "Yes",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();  // Close the dialog
          openMemberForm(enrollmentId); // Call the form creation logic
        }
    );
  }

  void openMemberForm(int enrollmentId) {
    // Set newEnrollment to true and update the form as needed
    newEnrollment.value = false;
    isHead.value = false; // Set default to false if needed
    // Pass enrollmentId to update in database later when saved
    Get.to(() => EnrollmentDetailsPage(enrollmentId: enrollmentId));
  }

  @override
  void onClose() {
    chfidController.dispose();
    eaCodeController.dispose();
    lastNameController.dispose();
    givenNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    identificationNoController.dispose();
    birthdateController.dispose();
    super.onClose();
  }
}


