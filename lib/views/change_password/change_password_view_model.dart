import 'package:awakn/services/user_service.dart';
import 'package:awakn/views/sign_in/sign_in_view.dart';
import 'package:awakn/widgets/snackbar_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty) {
      SnackbarManager().showAlertSnackbar(Get.context!,"Please Enter Your password");
      return;
    }
    if (newPasswordController.text.isEmpty) {
      SnackbarManager().showAlertSnackbar(Get.context!,"Please Enter New Password");
      return;
    }
    if (currentPasswordController.text.isEmpty) {
      SnackbarManager().showAlertSnackbar(Get.context!,"Please Confirm your password");
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

    if (newPasswordController.text.trim() != confirmNewPasswordController.text.trim()) {
      SnackbarManager().showAlertSnackbar(Get.context!,"New Password and Confirm New Password must match");
      return;
    }


    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;
    if (await UserService().changePassword(
      currentPass: currentPasswordController.text.trim(),
      newPass: newPasswordController.text.trim(),
      confirmNewPass: confirmNewPasswordController.text.trim(),
    )) {
      SnackbarManager().showSuccessSnackbar(Get.context!,"Password Change Successfully");
      Get.to(const SignInView());
    } else {


      SnackbarManager().showAlertSnackbar(Get.context!,"Current password is incorrect");

    }
    isLoading.value = false;

  }
}
