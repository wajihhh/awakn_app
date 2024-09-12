import 'package:awakn/services/user_service.dart';
import 'package:awakn/utils/global.dart';
import 'package:awakn/views/home/home_view.dart';
import 'package:awakn/widgets/snackbar_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInViewModel extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool invalidCreds = false.obs;
  RxBool rememberMe = true.obs;

  RxBool isGoogleSignInLoading = false.obs;
  RxBool isAppleSignInLoading = false.obs;

  GetStorage box = GetStorage();

  // Rxn<GetConfigurations> configurations = Rxn<GetConfigurations>();
  final pageFormKey = GlobalKey<FormState>();

  @override
  Future<void> onInit() async {
    if (!kReleaseMode) {
      // emailController.text = 'shary2725@gmail.com';
      emailController.text = 'junaidkhan046@gmail.com';
      passwordController.text = '12345678';
    }

    super.onInit();
  }

  Future<void> signIn() async {
    if (!pageFormKey.currentState!.validate()) {
      SnackbarManager()
          .showInfoSnackbar(Get.context!, 'Please enter valid credentials.');

      return;
    }
    if (emailController.text.isEmpty) {
      SnackbarManager().showInfoSnackbar(Get.context!, "Please enter email");
      return;
    }
    if (!GetUtils.isEmail(emailController.text.trim())) {
      SnackbarManager()
          .showInfoSnackbar(Get.context!, "Please enter valid email");
      return;
    }

    if (passwordController.text.isEmpty) {
      SnackbarManager().showInfoSnackbar(Get.context!, "Please enter password");
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    if (await UserService().signIn(emailController.text.toLowerCase().trim(),
        passwordController.text.trim())) {
      if (rememberMe.value) {
        box.write(
          AppConstants.rememberMeEnabledKey,
          rememberMe.value,
        );
      }
      Get.offAll(() => const HomeView());
    } else {
      invalidCreds(true);
    }
    isLoading.value = false;
  }

  Future<void> guestSignIn() async {
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    if (await UserService().guestSignIn()) {
      if (rememberMe.value) {
        box.write(
          AppConstants.rememberMeEnabledKey,
          rememberMe.value,
        );
      }
      Get.offAll(() => const HomeView());
    }
    isLoading.value = false;
  }

  Future<void> handleGoogleSignIn() async {
    try {
      isGoogleSignInLoading(true);
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? acc = await googleSignIn.signIn();
      if (await UserService().getTokenFromGoogle(acc!)) {
        debugPrint(acc.toString());
        Get.offAll(() => const HomeView());
      }
      isGoogleSignInLoading(false);
    } catch (error) {
      isGoogleSignInLoading(false);

      if (kDebugMode) {
        print(error);
      }
    }
  }
}
