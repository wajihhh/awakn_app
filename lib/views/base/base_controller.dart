import 'dart:developer';

import 'package:awakn/utils/global.dart';
import 'package:awakn/views/home/home_view.dart';
import 'package:awakn/views/onboarding/pageview.dart';
import 'package:awakn/views/sign_in/sign_in_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class BaseController extends GetxController {
  var isLoading = false.obs;

  GetStorage box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    checkExistanceThenNavigate();
    _requestCameraPermission();
  }

  void checkExistanceThenNavigate() {
    isExisting().then((isExisting) {
      // Future.delayed(const Duration(seconds: 1), () async {
      if (isExisting) {
        isRememberMeEnabled().then((isRememberMeEnabled) {
          if (isRememberMeEnabled) {
            Get.offAll(() => const HomeView());
          } else {
            Get.off(() => const SignInView());
          }
        });
      } else {
        Get.off(() => const OnBoardingScreen());
      }
      // });
    });
  }

  Future<bool> isExisting() async {
    final isExisting = await box.read(AppConstants.existingCheckKey);
    if (isExisting != null) {
      return isExisting;
    } else {
      box.write(AppConstants.existingCheckKey, true);
      return false;
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      final res = await Permission.camera.request();
      log(
        'Camera permission ${res.isGranted ? '' : 'not'}granted.',
      );
    } else {
      log('Camera permission allowed');
    }
  }

  Future<bool> isRememberMeEnabled() async {
    final isExisting = await box.read(AppConstants.rememberMeEnabledKey);
    if (isExisting != null) {
      return isExisting;
    } else {
      return false;
    }
  }
}
