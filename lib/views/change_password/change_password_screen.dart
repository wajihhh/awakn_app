import 'package:awakn/views/change_password/change_password_view_model.dart';
import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../theming/theme.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Get.put(ChangePasswordController());
    return Obx(() => CustomLoaderWidget(
          isTrue: model.isLoading.value,
          child: Container(
            decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: ReusableAppBar(
                title: "Reset Password",
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25,top: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextField(
                          textInputType: TextInputType.text,
                          controller: model.currentPasswordController,
                          labeltext: "Old Password",
                          placeholdertext: "**********1as",
                          sufixIcon: true,
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        CustomTextField(
                          textInputType: TextInputType.text,
                          controller: model.newPasswordController,
                          labeltext: "New Password",
                          placeholdertext: "**********2as",
                          sufixIcon: true,
                        ),
                        SizedBox(
                          height: 20.sp,
                        ),
                        CustomTextField(
                          textInputType: TextInputType.text,
                          controller: model.confirmNewPasswordController,
                          labeltext: "Confirm Password",
                          placeholdertext: "**********2as",
                          sufixIcon: true,
                        ),
                      ],
                    ),
                    CustomButton(
                      height: 55.sp,
                      text: "Reset Password",
                      width: 300,
                      onTap: () {
                        model.changePassword();
                        // successDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
