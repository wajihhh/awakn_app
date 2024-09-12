import 'package:awakn/views/forgot_password/reset_password_view.dart';
import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/snackbar_manager.dart';
import '../theming/theme.dart';
import 'forgot_password_view_model.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final model = Get.find<ForgotPasswordController>();

    return Obx(() => CustomLoaderWidget(

        isTrue: model.isLoading.value,
        child: Container(
          decoration:BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),

          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: ReusableAppBar(
              title: "",
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Please Enter Code",style: Theme.of(context).textTheme.titleLarge,),
                      SizedBox(height: 10,),
                      TextField(
                        controller: model.otpCodeController,
                        decoration:  InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(60.0),
                              borderSide: const BorderSide(
                                  color: Color(0xff949FBB)
                              )

                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                            // labelText: 'Reset Code',
                          hintText: "Reset Code",
                          hintStyle: const TextStyle(
                            color: Colors.grey
                          ),

                        ),
                        style: TextStyle(
                        color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black
                      ),
                      ),
                      // CodeInput(),

                    ],
                  ),
                  CustomButton(
                    height: 55.sp,
                    text: "Next",
                    width: 300,
                    onTap: () {
                      final otp = model.otpCodeController.text.trim();
                      final otpRegex = RegExp(r'^\d{4}$'); // Regex to match exactly 4 digits
                      final onlyNumbersRegex = RegExp(r'^\d+$'); // Regex to match only numbers

                      if (otp.isEmpty) {
                        SnackbarManager().showInfoSnackbar(Get.context!,"Please Enter OTP");
                      } else if (!onlyNumbersRegex.hasMatch(otp)) {
                        SnackbarManager().showInfoSnackbar(Get.context!,"OTP should contain only numbers");
                      } else if (!otpRegex.hasMatch(otp)) {
                        SnackbarManager().showInfoSnackbar(Get.context!,"OTP should contain exactly 4 digits");
                      } else {
                        Get.to(ResetPasswordScreen());
                      }
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

