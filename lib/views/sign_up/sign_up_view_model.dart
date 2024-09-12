import 'package:awakn/services/user_service.dart';
import 'package:awakn/utils/global.dart';
import 'package:awakn/views/home/home_view.dart';
import 'package:awakn/views/sign_in/sign_in_view.dart';
import 'package:awakn/widgets/snackbar_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpViewModel extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isGoogleSignInLoading = false.obs;
  RxBool isAppleSignInLoading = false.obs;
  RxBool isAgree = false.obs;

  RxBool invalidCreds = false.obs;
  final pageFormKey = GlobalKey<FormState>();

  GetStorage box = GetStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> signUp() async {
    if (!pageFormKey.currentState!.validate()) {
      return;
    }
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      SnackbarManager()
          .showAlertSnackbar(Get.context!, "Please fill in all fields");
      return;
    }
    if (fullNameController.text.isEmpty) {
      SnackbarManager().showInfoSnackbar(Get.context!, "Please enter name");
      return;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      SnackbarManager()
          .showInfoSnackbar(Get.context!, "Please enter valid email");
      return;
    }
    // if (!GetUtils.isPhoneNumber(phoneNumberController.text.trim())) {
    //   SnackbarManager()
    //       .showInfoSnackbar(Get.context!, "Please enter phone number");
    //   return;
    // }
    // if (!RegExp(r'^[0-9]+$').hasMatch(passwordController.text.trim())) {
    //   SnackbarManager().showInfoSnackbar("Password should contain only numbers");
    //   return;
    // }

    if (passwordController.text.trim().length <= 6) {
      SnackbarManager().showInfoSnackbar(
          Get.context!, "Password should be greater than 6 digits");
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;

    if (await UserService().signUp(
      fullName: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.removeAllWhitespace,
      phoneNumber: phoneNumberController.text.trim(),
    )) {
      isLoading.value = false;

      // final user = fullNameController.text.split(' ').first;
      SnackbarManager()
          .showSuccessSnackbar(Get.context!, 'User added successfully.');

      Get.off(() => const SignInView());
    } else {
      invalidCreds(true);
      isLoading.value = false;
    }
    isLoading.value = false;
  }

  Future<void> handleGoogleSignIn() async {
    try {
      isGoogleSignInLoading(true);

      GoogleSignIn googleSignIn = GoogleSignIn(
          // scopes: [
          //   'email',
          // ],
          );
      GoogleSignInAccount? acc = await googleSignIn.signIn();
      if (await UserService().getTokenFromGoogle(acc!)) {
        debugPrint(acc.toString());
      }
      isGoogleSignInLoading(false);
    } catch (error) {
      isGoogleSignInLoading(false);

      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> guestSignIn() async {
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    if (await UserService().guestSignIn()) {
      box.write(
        AppConstants.rememberMeEnabledKey,
        true,
      );

      Get.offAll(() => const HomeView());
    }
    isLoading.value = false;
  }
}
