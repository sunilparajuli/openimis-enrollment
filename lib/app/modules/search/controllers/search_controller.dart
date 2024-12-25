import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/remote/base/status.dart';
import '../../../data/remote/dto/search/search_out_dto.dart';
import '../../../data/remote/repositories/search/search_repository.dart';
import '../../../di/locator.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../policy/views/widgets/qr_view.dart';

class CSearchController extends GetxController {
  static SearchController get to => Get.find();
  final _searchRepository = getIt.get<SearchRepository>();
  final searchController = TextEditingController();
  final AuthController authController = AuthController.to;
  final Rx<Status<List<InsureeDetailsDto>>> _rxResults =
      Rx<Status<List<InsureeDetailsDto>>>(const Status.idle());

  Status<List<InsureeDetailsDto>> get rxResults => _rxResults.value;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getSearchResult();
  }

  @override
  void onClose() {
    super.onClose();
    searchController.dispose();
  }

  getSearchResult() async {
    _rxResults.value = Status.loading();

    // Check if there is any search text; otherwise, pass an empty query.
    authController.isInsuree() ? searchController.text = authController!.insureeInfo()!.chfid! : "";
    final searchQuery = searchController.text;

    final Status<List<InsureeDetailsDto>> results =
    await _searchRepository.getAll(q: searchQuery);
    _rxResults.value = results;
  }


  Future<void> scanQRCode(TextEditingController controller) async {
    final result = await Get.to(QRViewExample(controller: controller));
    if (result != null) {
      controller.text = result;
    }
  }

  clearSearch() {
    searchController.clear();
    _rxResults.value = const Status.idle();
  }

  void onRetry() {
    getSearchResult();
  }

}
