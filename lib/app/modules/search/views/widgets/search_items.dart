import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:openimis_app/app/modules/search/views/widgets/pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/core/values/strings.dart';
import 'package:openimis_app/app/modules/enrollment/controller/enrollment_controller.dart';
import 'package:openimis_app/app/widgets/shimmer/insuree_shimmer.dart';
import 'package:openimis_app/app/widgets/shimmer/details_page_shimmer.dart';
import '../../../../widgets/custom_lottie.dart';
import '../../../enrollment/views/widgets/memberlist.dart';
import '../../../enrollment/views/widgets/membership_card.dart';
import '../../../enrollment/views/widgets/policy_detail.dart';
import '../../controllers/search_controller.dart';
import 'instruction_card.dart';

class SearchResults extends GetView<CSearchController> {
  const SearchResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EnrollmentController _encontroller = Get.find<EnrollmentController>();

    void onSuccess(PaymentSuccessModel success) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Payment Successful'),
            actions: [
              SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(Get.context!);
                },
              ),
            ],
          );
        },
      );
    }

    void onFailure(PaymentFailureModel failure) {
      debugPrint(failure.toString());
    }

    void onCancel() {
      debugPrint('Cancelled');
    }

    payWithKhaltiInApp() {
      KhaltiScope.of(Get.context!).pay(
        config: PaymentConfig(
          amount: 1000, // in paisa
          productIdentity: 'Product Id',
          productName: 'Product Name',
          mobileReadOnly: false,
        ),
        preferences: [PaymentPreference.khalti],
        onSuccess: onSuccess,
        onFailure: onFailure,
        onCancel: onCancel,
      );
    }

    return Obx(
          () => controller.rxResults.when(
        idle: () => Column(
          children: [InstructionCard()],
        ),
        loading: () => Center(child: InsureeShimmer()),
        success: (results) => results!.isEmpty
            ? CustomLottie(
          title: AppStrings.NO_RESULT,
          asset: "assets/empty.json",
          description: AppStrings.NO_RESULT_DES,
          assetHeight: 200.h,
        )
            : ListView.builder(
          itemCount: results.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              children: [
                MembershipCard(
                  logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/92/Logo_of_openIMIS.png',
                  dateOfBirth: results[index].data!.insuree!.dateOfBirth ?? 'N/A',
                  firstServicePoint: results[index].data!.insuree!.firstServicePoint ?? 'Unknown',
                  fullName: results[index].data!.insuree!.fullname ?? 'Unknown',
                  gender: results[index].data!.insuree!.insureeGender ?? 'Not specified',
                  photoUrl: 'https://upload.wikimedia.org/wikipedia/commons/9/92/Logo_of_openIMIS.png',
                  policyStatus: results[index].data!.insuree!.policyStatus ?? 'Unknown',
                  qrCodeData: results[index].data!.insuree!.chfId ?? 'N/A',
                ),
                SizedBox(height: 10.0),
                results[index].data?.insuree?.policyStatus?.toLowerCase()=='expired'
                    ?
                ElevatedButton(
                  onPressed: () {
                    final config = PaymentConfig(
                      amount: 3500000, // Amount should be in paisa
                      productIdentity: 'dell-g5-g5510-2021',
                      productName: 'Dell G5 G5510 2021',
                      productUrl: 'https://www.khalti.com/#/bazaar',
                      additionalData: {'vendor': 'Khalti Bazaar'},
                    );
                    KhaltiScope.of(Get.context!).pay(
                      config: config,
                      preferences: [
                        PaymentPreference.khalti,
                        PaymentPreference.connectIPS,
                        PaymentPreference.eBanking,
                        PaymentPreference.sct,
                      ],
                      onSuccess: onSuccess,
                      onFailure: onFailure,
                      onCancel: onCancel,
                    );
                  },
                  child: Text("Khalti"),
                ) : SizedBox(),
                FamilyMemberDetails(families: results[index].data!.families!),
                SizedBox(height: 10.0),
                PolicyDetails(policies: results[index].data!.policy!),
                SizedBox(height: 10.0),
                Obx(() {
                  return _encontroller.membershipState.whenOrNull(
                    idle: () => SizedBox(),
                    failure: (err) => SizedBox(child: Text(err.toString())),
                    loading: () => CircularProgressIndicator(),
                    success: (data) {
                      if (data != null && data.pdfBase64.isNotEmpty) {
                        return ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: Get.context!,
                              builder: (context) => PdfViewerPopup(
                                pdfBase64: data.pdfBase64,
                              ),
                            );
                          },
                          child: Text('Open PDF'),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  ) ?? SizedBox();
                }),
              ],
            ),
          ),
        ),
        failure: (e) => CustomLottie(
          asset: "assets/space.json",
          title: e!,
          onTryAgain: controller.onRetry,
        ),
      ),
    );
  }
}
