import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../../core/values/strings.dart';
import '../../../../../utils/validators.dart';
import '../../../../../widgets/custom_text_field.dart';
import '../../../controllers/auth_controller.dart';

class EmployeeForm extends GetView<AuthController> {
  EmployeeForm({Key? key}) : super(key: key);
  Timer? _debounce;

  void _onUsernameChanged(String value) {
    // Cancel any active debounce timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Set a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await controller.verifyUsername(value); // Call the async API function
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.customerFormKey,
      child: Column(
        children: [
          CustomTextField(
            controller: controller.customerChfidController,
            title: AppStrings.InsuranceNo,
            hintText: AppStrings.InsuranceNo,
            autofocus: false,
            maxLines: 1,
            isRequired: true,
            validator: Validators.name,
            onChanged: (value) => controller.validateForm(),
          ),
          CustomTextField(
            controller: controller.customerHeadChfidController,
            title: AppStrings.HeadInsuracneNo,
            hintText: AppStrings.HeadInsuracneNo,
            autofocus: false,
            maxLines: 1,
            isRequired: true,
            validator: Validators.name,
            onChanged: (value) => controller.validateForm(),
          ),
          SizedBox(height: 15.h),
          CustomTextField(
            controller: controller.customerPhoneNumberController,
            title: AppStrings.phoneNumber,
            hintText: AppStrings.phoneNumberHint,
            autofocus: false,
            maxLines: 1,
            isRequired: true,
            textInputType: TextInputType.phone,
            validator: Validators.phoneNumber,
            isPhoneNumber: true,
            onCountryChanged: controller.onCountryChanged,
            onChanged: (value) => controller.validateForm(),
          ),
          CustomTextField(
            controller: controller.companyBusinessEmailController,
            title: "email",
            hintText: "email",
            autofocus: false,
            maxLines: 1,
            isRequired: true,
            isEmailField: true,
            onChanged: (value) => controller.validateForm(),
          ),
          Obx(() {
            // Observe the `usernameExists` value to update the icon
            HeroIcons? suffixIcon;
            Color iconColor;
            if (controller.usernameExists.value) {
              suffixIcon = HeroIcons.xCircle; // Block icon
              iconColor = Colors
                  .red; // Red color when username exists// Block icon when username exists
            } else {
              suffixIcon =
                  HeroIcons.checkCircle; // Tick icon when username is available
              iconColor = Colors.green;
            }

            return CustomTextField(
              controller: controller.customerUsernameController,
              title: "Username",
              hintText: "Enter your username",
              autofocus: false,
              maxLines: 1,
              isRequired: true,
              isUsernameField: true,
              textInputType: TextInputType.text,
              isPhoneNumber: false,
              onChanged: _onUsernameChanged, // Debounced onChanged callback
              suffixIcon: suffixIcon, // Pass the enum value directly
              suffixIconColor: iconColor,
              suffixIconSize: 24, // Optional: Adjust size if needed

            );
          }),
          SizedBox(height: 15.h),
          Obx(
            () => CustomTextField(
              controller: controller.customerPasswordController,
              hintText: AppStrings.password,
              title: AppStrings.password,
              autofocus: false,
              isPassword: true,
              obscureText: controller.isObscure,
              onSuffixTap: controller.toggleObscurePassword,
              isRequired: true,
              validator: Validators.password,
              suffixIcon:
                  controller.isObscure ? HeroIcons.eyeSlash : HeroIcons.eye,
              onChanged: (value) => controller.validateForm(),
            ),
          ),
          Obx(
            () => CustomTextField(
              controller: controller.customerConfirmPasswordController,
              hintText: AppStrings.password,
              title: AppStrings.password,
              autofocus: false,
              isPassword: true,
              obscureText: controller.isObscure,
              onSuffixTap: controller.toggleObscurePassword,
              isRequired: true,
              validator: controller.confirmPasswordValidator,
              suffixIcon:
                  controller.isObscure ? HeroIcons.eyeSlash : HeroIcons.eye,
              onChanged: (value) => controller.validateForm(),
            ),
          ),
        ],
      ),
    );
  }
}
