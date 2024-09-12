import 'package:awakn/views/forgot_password/otp.dart';
import 'package:awakn/views/sign_in/sign_in_view.dart';
import 'package:awakn/widgets/snackbar_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../services/user_service.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpCodeController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
  TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> forgetPassword() async {
    if (emailController.text.isEmpty) {
      SnackbarManager().showInfoSnackbar(Get.context!,'Please enter your email address.');

      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    if (await UserService().forgotPassword(
      emailController.text.toLowerCase().trim(),
    )) {
      // DialogUtils.showSuccessDialog();
      SnackbarManager().showSuccessSnackbar(Get.context!,"Email Sent Successfully");
      Get.to(() => OTPScreen());
    } else {
      SnackbarManager().showAlertSnackbar(Get.context!,"Invalid email");
    }
    isLoading.value = false;
  }

  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      SnackbarManager().showInfoSnackbar(Get.context!,'Please enter your email address.');

      return;
    }
    if(otpCodeController.text.isEmpty){
      SnackbarManager().showInfoSnackbar(Get.context!,"Please enter otp");
      return;
    }
    final otpRegex = RegExp(r'^\d{4}$'); // Regex to match 4 digits
    if (!otpRegex.hasMatch(otpCodeController.text.trim())) {
      SnackbarManager().showInfoSnackbar(Get.context!,"Please enter a 4-digit OTP");
      return;
    }
    if(newPasswordController.text.trim().length <= 6 ){

      SnackbarManager().showInfoSnackbar(Get.context!,"Password should be greater than 6 digits");
      return;
    }
    if(confirmNewPasswordController.text.trim().length <= 6 ){

      SnackbarManager().showInfoSnackbar(Get.context!,"Password should be greater than 6 digits");
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    if (await UserService().resetPassword(
        token: otpCodeController.text.trim(),
        email: emailController.text.trim(),
        pass: newPasswordController.text.trim(),
        confirmPass: confirmNewPasswordController.text.trim())) {
      SnackbarManager().showSuccessSnackbar(Get.context!,"Password changed Successfully");
      Get.offAll(() =>  SignInView());
    } else {
      // SnackbarManager().showAlertSnackbar(Get.context!,"Invalid email");
    }
    isLoading.value = false;
  }
}