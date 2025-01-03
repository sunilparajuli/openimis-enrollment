import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:openimis_app/app/core/values/strings.dart';
import 'package:openimis_app/app/modules/auth/controllers/auth_controller.dart';

import '../../../../../widgets/custom_text_field.dart';

class LoginForm extends GetView<AuthController> {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: controller.loginEmailController,
            hintText: AppStrings.emailHint,
            title: AppStrings.emailLabel,
            autofocus: false,
            maxLines: 1,
          ),
          SizedBox(height: 15.h),
          Obx(
                () => CustomTextField(
              controller: controller.loginPasswordController,
              hintText: AppStrings.password,
              title: AppStrings.password,
              autofocus: false,
              isPassword: true,
              suffixIcon: controller.isObscure ? HeroIcons.eyeSlash : HeroIcons.eye,
              obscureText: controller.isObscure,
              onSuffixTap: controller.toggleObscurePassword,
            ),
          ),
          SizedBox(height: 20.h),

        ],

      ),
    );
  }
}
