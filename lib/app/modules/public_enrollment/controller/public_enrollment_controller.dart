import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:openimis_app/app/data/remote/dto/customer/national_id.dto.dart';
import 'package:openimis_app/app/data/remote/repositories/public_enrollment/public_enrollment_repository.dart';
import 'package:openimis_app/app/modules/enrollment/controller/LocationDto.dart';
import 'package:openimis_app/app/modules/enrollment/controller/MembershipDto.dart';
import 'package:openimis_app/app/modules/policy/views/widgets/qr_view.dart';
import 'package:openimis_app/app/modules/public_enrollment/controller/HospitalDto.dart'; // Correct import path

import '../../../data/remote/base/status.dart';
import '../../../di/locator.dart';
import '../../../utils/database_helper.dart';
import '../../../utils/functions.dart';
import '../../../utils/public_database_helper.dart';
import '../../../widgets/snackbars.dart';
import '../views/widgets/enrollment_members.dart';
import '../views/widgets/paypal_service.dart';
import '../views/widgets/public_enrollment_list.dart';
import '../views/widgets/qr_view.dart';
import '../views/widgets/submit_botton_sheet.dart';
import 'DropdownDto.dart';
import 'EnrollmentDto.dart';


class Instruction {
  String text;
  bool isAcknowledged;

  Instruction({required this.text, this.isAcknowledged = false});
}
class PublicEnrollmentController extends GetxController with SingleGetTickerProviderMixin {
  final GlobalKey<FormState> enrollmentFormKey = GlobalKey<FormState>();
  final GetStorage _storage = GetStorage(); // Use GetStorage for local storage

  final _public_enrollmentRepository = getIt.get<PublicEnrollmentRepository>();
  final chfidController = TextEditingController();
  final eaCodeController = TextEditingController();
  final lastNameController = TextEditingController();
  final nationalIdController = TextEditingController();
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

  RxBool hasExistingRecords = false.obs;

  final RxString nationalId = ''.obs;
  final _enrollmentScrollController = ScrollController();
  final Rx<Status<EnrollmentDto>> _rxEnrollmentState = Rx(const Status.idle());

  Status<EnrollmentDto> get enrollmentState => _rxEnrollmentState.value;

  final Rx<Status<MemberShipCard>> _rxMemberShipCard = Rx(const Status.idle());

  Status<MemberShipCard> get membershipState => _rxMemberShipCard.value;


  final Rx<Status<NationalID>> _rxNationalID = Rx(const Status.idle());

  Status<NationalID> get getNationalId => _rxNationalID.value;

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

  // This function checks if records exist in the database
  Future<void> _checkIfRecordsExist() async {
    bool exists = await PublicDatabaseHelper().hasRecords();
    hasExistingRecords.value = exists;
  }
  void toggleSelectAll(bool selectAll) {
    isAllSelected.value = selectAll;
    selectedEnrollments.clear();
    if (selectAll) {
      selectedEnrollments.addAll(
        filteredEnrollments.map<int>((enrollment) => enrollment['id'] as int),
      );
    }
  }


  Future<void> fetchPublicEnrollmentDetails() async {
    try {
      isLoading(true);
      var data = await PublicDatabaseHelper().retrieveAllMembers();
      if (data.isNotEmpty) {
        members.value = List<Map<String, dynamic>>.from(data);
        // If you want to get head member or handle separately
        var headMember = data.firstWhere((member) => member['isHead'] == 1);
        if (headMember != null) {
          family.value = headMember; // If the family data comes from the head member, you can use it here
        }
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

  final Rx<Status<List<PublicHealthServiceProvider>>> _rxHospitalState = Rx(const Status.idle());

  Status<List<PublicHealthServiceProvider>> get hospitalState => _rxHospitalState.value;



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
    //clearAllDataExample();
    //fetchPublicEnrollments();
    _checkIfRecordsExist();
    tabController = TabController(length: 1, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });
    if (tabController.index == 1) {
      //getAllHospitals(); // Call this method when the second tab is selected
    }
    fetchPublicEnrollments();
    getAllLocations();
    getAllHospitals();
    fetchContributionRequirements();
    if (!dev) {
      initializeDummyData();
    }
    ever(newEnrollment, handleNewEnrollmentChange);


    debounce<String>(nationalId, (value) {
      if (value.isNotEmpty) {
        getNationalIdInformation(value);
      }
    }, time: const Duration(milliseconds: 800));
  }

  var isAcknowledged = 0.obs;
  var familyTypeCodes = <FamilyType>[].obs;
  var confirmationTypes = <ConfirmationType>[].obs;


  final instructions = <Instruction>[
    Instruction(text: "Read and understand the terms and conditions."),
    Instruction(text: "Provide accurate and complete information."),
    Instruction(text: "Ensure all required documents are ready."),
  ].obs;

  final showForm = false.obs;

  bool get allInstructionsAcknowledged =>
      instructions.every((instruction) => instruction.isAcknowledged);

  void updateInstructionStatus(int index, bool status) {
    instructions[index].isAcknowledged = status;
    instructions.refresh(); // Ensure the UI reacts to changes
  }

  void updateAllInstructionsStatusToTrue() {
    for (var instruction in instructions) {
      instruction.isAcknowledged = true;
    }
    instructions.refresh(); // Ensure the UI updates
  }

  void proceedToForm() {
    if (allInstructionsAcknowledged) {
      showForm.value = true;
    } else {
      Get.snackbar("Notice", "Please acknowledge all instructions.");
    }
  }


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
    final Status<List<LocationDto>> state = await _public_enrollmentRepository.getLocations();
    state.whenOrNull(
      success: (data) {
        _rxLocationState.value = state;
      }
    );
  }

  Future<void> getAllHospitals() async {
    _rxHospitalState.value = Status.loading();  // Set loading state initially

    // Fetch data from repository
    final Status<List<PublicHealthServiceProvider>> state = await _public_enrollmentRepository.getHospitals();
    state.whenOrNull(
      success: (data) {
        _rxHospitalState.value = Status.success(data: data);  // Set the data in the state
      },
      failure: (reason) {
        _rxHospitalState.value = Status.failure(reason: reason);  // Set the failure reason
      },
    );
  }

  Future<void> getMembershipCard(String uuid) async {
    _rxMemberShipCard.value = Status.loading();
    final Status<MemberShipCard> state = await _public_enrollmentRepository.getMembershipCard(uuid: uuid);
    state.whenOrNull(
        success: (data) {
          _rxMemberShipCard.value = state;
        }
    );
  }



  Future<void> getNationalIdInformation(String nationalID) async {
    _rxNationalID.value = Status.loading();  // Set loading state initially
    // Fetch data from repository
    final Status<NationalID> state = await _public_enrollmentRepository.getNationalId(nationalID);
    state.whenOrNull(
      success: (data) {
        _rxNationalID.value = Status.success(data: data);
        if (data != null) {
          chfidController.text = data.nationalId ?? '';
          givenNameController.text = data.firstname ?? '';
          lastNameController.text = data.lastname ?? ''; // If last name is separate, set it here
          identificationNoController.text = data.nationalId ?? '';
          birthdateController.text = data.birthdate ?? '';
          gender.value = data.gender ?? '';
          eaCodeController.text = data.address ?? '';
          phoneController.text = data.phone ?? '';
          emailController.text = data.email ?? '';
          isHead.value = data.isHead ?? false;
        }
      },
      failure: (reason) {
        _rxNationalID.value = Status.failure(reason: reason);
        resetForm();
      },
    );
  }


  void clearAllDataExample() async {
    final dbHelper = PublicDatabaseHelper();

    await dbHelper.deleteAllData();

    print('All data from family and members tables has been deleted.');
  }




  Future<void> fetchPublicEnrollments() async {
    final dbHelper = PublicDatabaseHelper();
    final data = await dbHelper.retrieveAllMembers();
    enrollments.value =  data;

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
    final dbHelper = PublicDatabaseHelper();
    await dbHelper.deleteMember(id);
    fetchPublicEnrollments();
    filteredEnrollments();

    SnackBars.success("Success", "Member Deleted");
  }


  Widget buildPlaceholder() {
    return Container(
      width: 40,
      height: 40,
      color: Colors.grey[300], // Background color for placeholder
      child: const Icon(
        Icons.person, // Placeholder icon
        color: Colors.white,
        size: 24,
      ),
    );
  }

  // Helper method to decode and display the image
  Widget buildImageFromBase64(String base64String) {
    try {
      Uint8List imageBytes = base64Decode(base64String);
      return Image.memory(
        imageBytes,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      );
    } catch (e) {
      // If decoding fails, show a placeholder
      return buildPlaceholder();
    }
  }
  Future<void> onEnrollmentSubmit() async {
    // if (hasExistingRecords.value==true) {
    //   SnackBars.failure("cannot add more", "Cannot add more than one enrollment for family");
    //   return;
    // }

    final db = await PublicDatabaseHelper().database;

    // Convert photo to Base64 if available
    String? photoBase64;
    if (photo.value != null) {
      photoBase64 = await _encodePhotoToBase64(photo.value!);
    }

    // Enrollment data preparation
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
      //'chfid': headChfidController.text,
      'photo': photoBase64 ?? "",
      'remarks': "",
      'healthFacilityLevel': selectedHealthFacilityLevel.value,
      'healthFacility': selectedHealthFacility.value,
      'familyType': selectedFamilyType.value,
      'confirmationType': selectedConfirmationType.value,
      'confirmationNumber': confirmationNumber.text,
      'addressDetail': addressDetail.text,
      'relationShip': relationShip.value,
      'povertyStatus': povertyStatus.value,
    };

    // Family data for insertion
    Map<String, dynamic> familyData = {
      //'chfid' : enrollmentData['chfid'],
      'familyType': enrollmentData['familyType'] ?? '',
      'confirmationType': enrollmentData['confirmationType'] ?? '',
      'confirmationNumber': enrollmentData['confirmationNumber'] ?? '',
      'addressDetail': enrollmentData['addressDetail'] ?? '',
      'povertyStatus' : enrollmentData['povertyStatus'] ?? ''
    };

    // Serialize family data
    String familyJsonContent = jsonEncode(familyData);

    // Insert the family and capture its ID
     await db.insert('family', {
      'json_content': familyJsonContent,
    });

    // Member data preparation
    Map<String, dynamic> memberData = {
      'phone': enrollmentData['phone'],
      'birthdate': enrollmentData['birthdate'],
      'chfid': enrollmentData['chfid'],
      'eaCode': enrollmentData['eaCode'],
      'email': enrollmentData['email'],
      'gender': enrollmentData['gender'],
      'givenName': enrollmentData['givenName'],
      'identificationNo': enrollmentData['identificationNo'],
      'isHead': enrollmentData['isHead'],
      'lastName': enrollmentData['lastName'],
      'maritalStatus': enrollmentData['maritalStatus'],
      'headChfid': enrollmentData['headChfid'],
      'photo': enrollmentData['photo'],
      'remarks': enrollmentData['remarks'],
      'healthFacilityLevel': enrollmentData['healthFacilityLevel'],
      'healthFacility': enrollmentData['healthFacility'],
      'relationShip': enrollmentData['relationShip'],
    };

    // Serialize member data
    String memberJsonContent = jsonEncode(memberData);

    // Insert the head member with the captured family ID
    await db.insert('members', {
      'chfid': enrollmentData['chfid'], // Unique CHFID for the member
      'name': '${enrollmentData['givenName']} ${enrollmentData['lastName']}',
      'isHead': enrollmentData['isHead'], // 1 for head, 0 otherwise
      'json_content': memberJsonContent,
      'photo': enrollmentData['photo'],
      'sync': 0, // Unsynced initially
      //'family_id': familyId, // Assign the family ID
    });

    // Notify success
    SnackBars.success("Success", "Enrollment saved locally.");
    fetchPublicEnrollments();
    //fetchPublicEnrollmentDetails(familyId);
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

  Future<void> onEnrollmentOnline() async {
    isLoading.value = true;
    try {
      _rxEnrollmentState.value = Status.loading();

      // Step 1: Prepare the enrollment payload
      final requestData = await prepareEnrollmentPayload();

      // Debugging: Log the request payload
      print("Request Payload: $requestData");

      // Step 2: Submit the payload to the API
      final response = await _public_enrollmentRepository.enrollmentSubmit(requestData);

      if (response.error) {
        throw Exception(response.message);
      }

      // Step 3: Handle success
      resetForm();
      Get.back();
      popupBottomSheet(bottomSheetBody: const SubmitBottomSheet());

      // Step 4: Mark members as synced in the database
      final dbHelper = PublicDatabaseHelper();
      for (var member in requestData['members']) {
        await dbHelper.updateSyncStatus(member['chfid']);
      }
    } catch (error) {
      SnackBars.failure("Error", error.toString());
    } finally {
      isLoading.value = false;
      _rxEnrollmentState.value = Status.idle();
    }
  }


  Future<Map<String, dynamic>> prepareEnrollmentPayload() async {
    final dbHelper = PublicDatabaseHelper();

    // Fetch family and member data
    final List<Map<String, dynamic>> membersData = await dbHelper.retrieveAllMembers();
    final familyData = await dbHelper.retrieveFamily();

    // Validate data
    if (familyData == null) {
      throw Exception("Family data is missing.");
    }
    if (membersData.isEmpty) {
      throw Exception("Members data is missing.");
    }

    // Prepare the payload
    final Map<String, dynamic> requestData = {
      'family': familyData,
      'members': membersData,
      'voucherData': voucherNumber.value,
      'voucherImage': voucherImage.value != null
          ? await _encodePhotoToBase64(voucherImage.value!)
          : null, // Handle optional voucherImage
    };

    return requestData;
  }

  Future<void> postEnrollmentAfterPayment(String url, String payerId, String accessToken) async {
    try {
      // Prepare the enrollment payload
      final requestData = await prepareEnrollmentPayload();

      // Execute the payment API call and get the full response
      final paymentResponse = await PaypalServices().executePayment(url, payerId, accessToken);

      if (paymentResponse == null) {
        throw Exception("Payment execution failed.");
      }

      // Ensure the response contains the necessary payment information
      if (!paymentResponse.containsKey('id')) {
        throw Exception("Payment response is invalid or missing the 'id'.");
      }

      // Include the payment details in the payload
      requestData['payment_id'] = paymentResponse['id'];
      requestData['payments'] = paymentResponse; // Add the full payment response as an array

      // Submit the enrollment data
      final response = await _public_enrollmentRepository.enrollmentSubmit(requestData);

      if (response.error) {
        throw Exception(response.message);
      }

      // Handle success
      resetForm();
      Get.back();
      popupBottomSheet(bottomSheetBody: const SubmitBottomSheet());

      // Mark members as synced
      final dbHelper = PublicDatabaseHelper();
      for (var member in requestData['members']) {
        await dbHelper.updateSyncStatus(member['chfid']);
      }
    } catch (error) {
      SnackBars.failure("Error", error.toString());
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
    final pickedFile = await _picker.pickImage(source: Platform.isIOS ? ImageSource.gallery : ImageSource.camera, maxHeight: 480, maxWidth: 640, imageQuality: 50);
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
    nationalIdController.dispose();
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




