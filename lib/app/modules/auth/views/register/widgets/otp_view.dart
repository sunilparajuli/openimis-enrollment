import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../../../../routes/app_pages.dart';
import '../../../../../widgets/openimis_appbar.dart';
import '../../../controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  OtpScreen() {
    authController.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OpenIMISAppBar(
        title: 'verify_otp'.tr,
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.back(); // Go back to the previous screen
            },
          ),
        ],
      ),
      backgroundColor: Get.theme.backgroundColor,
      resizeToAvoidBottomInset: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Get.theme.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  height: 150.0,
                  reverse: true,
                  'assets/otp.json'
                ),
                OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 40,
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (otp) async{
                    print("otp");
                    print(otp);
                    authController.customerOTPController.value =
                        TextEditingValue(text: otp);
                    authController.verifyOtp();
                  },
                ),
                SizedBox(height: 20),
                Obx(() {
                  return authController.otpVerifyState.when(
                    idle: () => Container(),
                    loading: () => ElevatedButton(
                      onPressed: null, // Disable button while loading
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Set color for indicator
                      ),
                    ),
                    failure: (reason) => Text(""),
                    success: (data) {
                      Timer(Duration(seconds: 1), () {
                        Get.toNamed(Routes.LOGIN); // Navigate to the OTP route after the delay
                      });
                      return Column(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 100),
                          SizedBox(height: 20),
                          Text('Verification Successful',
                              style: TextStyle(fontSize: 18, color: Colors.green)),
                        ],
                      ); // Return an empty container as a placeholder
                    },
                  );
                }),

                SizedBox(height: 20),
                Obx(() {
                  return authController.canResend.value
                      ?
                  TextButton(
                    onPressed: authController.resendOtp,
                    child: Text('Resend OTP'),
                  )
                      : Text('Resend OTP in ${authController.timeLeft.value}s');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
