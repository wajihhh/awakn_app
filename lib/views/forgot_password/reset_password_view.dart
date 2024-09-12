import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../theming/theme.dart';
import 'forgot_password_view_model.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Get.find<ForgotPasswordController>();

    return Obx(
      () => CustomLoaderWidget(
          isTrue: model.isLoading.value,
          child: Container(
            decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: ReusableAppBar(
                title: "Reset Password",
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextField(
                          textInputType: TextInputType.number,
                          controller: model.newPasswordController,
                          labeltext: "New Password",
                          placeholdertext: "**********2as",
                          sufixIcon: true,
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        CustomTextField(
                          textInputType: TextInputType.number,
                          controller: model.confirmNewPasswordController,
                          labeltext: "Confirm Password",
                          placeholdertext: "**********2as",
                          sufixIcon: true,
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                      ],
                    ),
                    CustomButton(
                      height: 55.sp,
                      text: "Reset Password",
                      width: 300,
                      onTap: () {
                        model.resetPassword();
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
