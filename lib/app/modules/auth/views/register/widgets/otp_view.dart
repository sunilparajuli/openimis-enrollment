import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../../../../widgets/openimis_appbar.dart';
import '../../../controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  OtpScreen() {
    // Start the timer when the screen is loaded
    authController.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OpenIMISAppBar(
        title: 'verify_otp'.tr,
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
                OTPTextField(
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 40,
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (otp) {
                    authController.verifyOtp(otp);
                  },
                ),
                SizedBox(height: 20),
                Obx(() {
                  if (authController.isVerified.value) {
                    return Column(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green, size: 100),
                        SizedBox(height: 20),
                        Text('Verification Successful',
                            style: TextStyle(
                                fontSize: 18, color: Colors.green)),
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
                SizedBox(height: 20),
                Obx(() {
                  return authController.canResend.value
                      ? TextButton(
                    onPressed: authController.resendOtp,
                    child: Text('Resend OTP'),
                  )
                      : Text(
                      'Resend OTP in ${authController.timeLeft.value}s');
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
