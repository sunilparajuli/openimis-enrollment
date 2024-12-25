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
  final GetStorage _storage = GetStorage(); // Use GetStorage for local storage

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
  var familyId = 0.obs;
  /* member listing  */
  var family = {}.obs; // Family data observable
  var members = <Map<String, dynamic>>[].obs; // Members list observable
  var voucherNumber = ''.obs;
  var isLoading = false.obs; // Loading state
  var errorMessage = ''.obs; // Error message state


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


  Future<void> fetchEnrollmentDetails(int enrollmentId) async {
    try {
      isLoading(true);
      var data = await DatabaseHelper().getFamilyAndMembers(enrollmentId);
      if (data != null) {
        family.value = data['family'];
        members.value = List<Map<String, dynamic>>.from(data['members']);
      } else {
        errorMessage.value = 'No data found';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
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
    if (tabController.index == 1) {
      getAllHospitals(); // Call this method when the second tab is selected
    }
    fetchEnrollments();
    getAllLocations();
    //getAllHospitals();
    fetchContributionRequirements();
    if (dev) {
      initializeDummyData();
    }
    ever(newEnrollment, handleNewEnrollmentChange);
    debounce(searchText, (_) => filterEnrollments(),
        time: Duration(milliseconds: 300));
  }


  var familyTypeCodes = <FamilyType>[].obs;
  var confirmationTypes = <ConfirmationType>[].obs;



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
        final familyChfid = enrollment['family']['chfid'].toString().toLowerCase();
        return familyChfid.contains(query);
      }).toList();
    }
    print('Filtered enrollments: ${filteredEnrollments.length}');
  }


  Future<void> deleteEnrollment(int id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteFamily(id);
    filterEnrollments();
    await fetchEnrollmentDetails(familyId.value);

  }

  Future<void> fetchEnrollments() async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.getAllFamiliesWithMembers();
    enrollments.value =  data;
    filterEnrollments();
    //print('Fetched enrollments: ${enrollments.length}');
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


  Future<void> deleteFamilyMember(id) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteMember(id);
    fetchEnrollments();
    filteredEnrollments();

    SnackBars.success("Success", "Member Deleted");
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

  Future<void> onEnrollmentSubmit() async {
    final db = await DatabaseHelper().database;

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
    // Extract family data from the enrollment data
    Map<String, dynamic> familyData = {
      'familyType': enrollmentData['familyType'] ?? '',
      'confirmationType': enrollmentData['confirmationType'] ?? '',
      'confirmationNumber': enrollmentData['confirmationNumber'] ?? '',
      'addressDetail': enrollmentData['addressDetail'] ?? ''
    };

    // Extract member data from the enrollment data
    Map<String, dynamic> memberData = {
      'phone': enrollmentData['phone'] ?? '',
      'birthdate': enrollmentData['birthdate'] ?? '',
      'chfid': enrollmentData['chfid'] ?? '',
      'eaCode': enrollmentData['eaCode'] ?? '',
      'email': enrollmentData['email'] ?? '',
      'gender': enrollmentData['gender'] ?? '',
      'givenName': enrollmentData['givenName'] ?? '',
      'identificationNo': enrollmentData['identificationNo'] ?? '',
      'isHead': enrollmentData['isHead'] ?? 0,
      'lastName': enrollmentData['lastName'] ?? '',
      'maritalStatus': enrollmentData['maritalStatus'] ?? '',
      'headChfid': enrollmentData['headChfid'] ?? '',
      'newEnrollment': enrollmentData['newEnrollment'] ?? 0,
      'photo': enrollmentData['photo'] ?? '',
      'remarks': enrollmentData['remarks'] ?? '',
      'healthFacilityLevel': enrollmentData['healthFacilityLevel'] ?? '',
      'healthFacility': enrollmentData['healthFacility'] ?? '',
      'relationShip': enrollmentData['relationShip'] ?? ''
    };
    Map<String, dynamic> voucherData = {
      'voucherNumber' : voucherNumber.value
    };
    // Convert family data to JSON string
    String familyJsonContent = jsonEncode(familyData);
    String memberJsonContent = jsonEncode(memberData);



    // Insert family into the 'family' table

    if (newEnrollment.value)
      // Insert family into the 'family' table and get the family ID
      familyId.value = await db.insert('family', {
        'chfid': enrollmentData['chfid'],
        'json_content': familyJsonContent,
        'photo': enrollmentData['photo'],
        'sync': 0, // Assuming false for initial save
      });

      // Now insert the member into the 'members' table, using the familyId
      final members = await db.insert('members', {
        'chfid': enrollmentData['chfid'], // Unique CHFID for the member
        'name': '${enrollmentData['givenName']} ${enrollmentData['lastName']}',
        'head': enrollmentData['isHead'] ?? 0,
        'json_content': memberJsonContent,
        'photo': enrollmentData['photo'],
        'sync': 0, // Assuming false for initial save
        'family_id':  familyId.value, // Link member to the inserted family using familyId
      });



    SnackBars.success("Success", "Enrollment saved locally.");
    fetchEnrollments();
    fetchEnrollmentDetails(familyId.value);
  }


  var voucherImage = Rxn<XFile>();

  // Method to pick an image
  Future<void> pickVoucherImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        voucherImage.value = pickedImage;
        print('Voucher image selected: ${pickedImage.path}');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Optional: If you want to clear the image
  void clearVoucherImage() {
    voucherImage.value = null;
  }

  // Future<void> onEnrollmentOnline({bool offlineTrue = false}) async {
  //   try {
  //     _rxEnrollmentState.value = Status.loading();
  //
  //     // Prepare the members' data to be included in the DTO
  //     final List<MemberDto> membersData = enrollmentController.members.map((member) {
  //       return MemberDto(
  //         chfid: member['chfid'],
  //         givenName: member['given_name'],
  //         lastName: member['last_name'],
  //         birthdate: member['birthdate'],
  //         gender: member['gender'],
  //         photo: member['photo'] ?? "",
  //         relationShip: member['relationship'],
  //         identificationNo: member['identification_no'] ?? "",
  //         isHead: member['is_head'],
  //       );
  //     }).toList();
  //
  //     // Prepare the family data (including members) for submission
  //     final response = await _enrollmentRepository.create(
  //       dto: EnrollmentDto(
  //         phone: phoneController.text,
  //         birthdate: birthdateController.text,
  //         chfid: chfidController.text,
  //         eaCode: eaCodeController.text,
  //         email: emailController.text,
  //         gender: gender.value,
  //         givenName: givenNameController.text,
  //         identificationNo: identificationNoController.text,
  //         isHead: isHead.value,
  //         lastName: lastNameController.text,
  //         maritalStatus: maritalStatus.value,
  //         headChfid: headChfidController.text,
  //         newEnrollment: newEnrollment.value,
  //         photo: photoBase64 ?? "",
  //         healthFacilityLevel: selectedHealthFacilityLevel.value,
  //         healthFacility: selectedHealthFacility.value,
  //         familyType: selectedFamilyType.value,
  //         confirmationType: selectedConfirmationType.value,
  //         confirmationNumber: confirmationNumber.text,
  //         addressDetail: addressDetail.text,
  //         relationShip: relationShip.value,
  //
  //         // New additions: members and family ID
  //         familyId: family['family_id'], // Assuming family_id is available in your family data
  //         members: membersData, // Pass the members data
  //       ),
  //     );
  //
  //     // Handle the response from the API
  //     if (!response.error) {
  //       FocusManager.instance.primaryFocus?.unfocus();
  //       resetForm();
  //       Get.back();
  //       popupBottomSheet(bottomSheetBody: const SubmitBottomSheet());
  //     } else {
  //       SnackBars.failure("Oops!", response.message);
  //     }
  //   } catch (error) {
  //     SnackBars.failure("Error", "An error occurred: $error");
  //   } finally {
  //     _rxEnrollmentState.value = Status.idle();
  //   }
  // }

  Future<void> onEnrollmentOnline(int enrollmentId) async {
    isLoading.value = true;
    try {
      // Set loading status
      _rxEnrollmentState.value = Status.loading();

      // Step 1: Fetch family and members data using enrollmentId
      await fetchEnrollmentDetails(enrollmentId);

      // Step 2: Get family and members details from the controller
      final familyData = family;
      final membersData = members;

      if (familyData.isNotEmpty && membersData.isNotEmpty) {
        // Step 3: Prepare the request payload

          // Directly send family and members as the payload
          final Map<String, dynamic> requestData = {
            'family': familyData,  // Use familyData directly
            'members': membersData, // Use membersData directly
            'voucherData' : voucherNumber.value,
            'voucherImage' : await _encodePhotoToBase64(voucherImage.value!)
          };

          // You can now use requestData as the payload in your API request
          print(requestData);  // For debugging
          // send requestData to your API


        // Step 4: Submit the requestData to the API
        final response = await _enrollmentRepository.enrollmentSubmit(requestData);

        // Step 5: Handle the API response
        if (!response.error) {
          isLoading.value = false;
          FocusManager.instance.primaryFocus?.unfocus();
          resetForm();
          Get.back();
          popupBottomSheet(bottomSheetBody: const SubmitBottomSheet());
        } else {
          isLoading.value = false;
          SnackBars.failure("Oops!", response.message);
        }
      } else {
        isLoading.value = false;
        SnackBars.failure("Error", "Family or members data is missing");
      }
    } catch (error) {
      isLoading.value = false;
      // Step 6: Handle errors during the process
      SnackBars.failure("Error", "An error occurred: $error");
    } finally {
      // Set the state back to idle
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
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            hideBottomControls: false,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: false,
          ),
        ],
      );

      if (croppedFile != null) {
        // Convert CroppedFile to File
        final croppedFileAsFile = File(croppedFile.path);
        photo.value = XFile(croppedFileAsFile.path);
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


  Future<void> confirmAddMember(dynamic familyId, String FamilyChfid) async {
    Get.defaultDialog(
        title: "Add Member",
        middleText: "Are you sure you want to add a new member?",
        textCancel: "No",
        textConfirm: "Yes",
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back();  // Close the dialog
          openMemberForm(familyId, FamilyChfid); // Call the form creation logic
        }
    );
  }

  void openMemberForm(dynamic familyId, dynamic FamilyChfid) {
    // Set newEnrollment to true and update the form as needed
    newEnrollment.value = false;
    isHead.value = false; // Set default to false if needed
    // Pass enrollmentId to update in database later when saved
    Get.to(() => EnrollmentDetailsPage(enrollmentId: familyId, chfid: FamilyChfid,));
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


  var premiumAmount = 0.obs;
  var perMember = 0.obs;
  var currency = ''.obs;
  var validity = ''.obs;

// Add a method to calculate total contribution
  int calculateTotalContribution() {
    return members.length * perMember.value;
  }

  Future<void> fetchContributionRequirements() async {
    try {
      final configData = await _storage.read('configurations') as Map<String, dynamic>?;
      if (configData != null) {
        final contributionRequirements = configData['contributions_requirements'] as Map<String, dynamic>;
        premiumAmount.value = contributionRequirements['premium_amount'];
        perMember.value = contributionRequirements['per_member'];
        currency.value = contributionRequirements['Currency'];
        validity.value = contributionRequirements['validity'];
      }
    } catch (e) {
      print('Error reading contribution requirements: $e');
      // Set default or empty values if fetching fails
      premiumAmount.value = 0;
      perMember.value = 0;
      currency.value = '';
      validity.value = '';
    }
  }
}




