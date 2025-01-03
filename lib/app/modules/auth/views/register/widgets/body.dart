import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/values/strings.dart';
import '../../../../../domain/enums/user_type.dart';
import '../../../../../routes/app_pages.dart';
import '../../../controllers/auth_controller.dart';
import '../../widgets/button_with_text.dart';
import '../../widgets/header.dart';
import 'employee_form.dart';
import 'employer_form.dart';

class Body extends GetView<AuthController> {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 29.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50.h),
            const Header(title: AppStrings.createAnAccount),
            SizedBox(height: 30.h),
            // if (controller.registerType == RegisterType.CUSTOMER)
            //   const EmployeeForm(),
            if (controller.registerType == RegisterType.COMPANY)
              const EmployerForm(),
            SizedBox(height: 50.h),
            ButtonWithText(
              btnLabel: AppStrings.signup.toUpperCase(),
              firstTextSpan: AppStrings.alreadyHaveAnAccount,
              secondTextSpan: AppStrings.signIn,
              onTap: controller.onRegisterSubmit,
              onTextTap: () => Get.offNamed(Routes.LOGIN),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
