import 'dart:io';
import 'package:awakn/services/user_service.dart';
import 'package:awakn/utils/global.dart';
import 'package:awakn/views/home/home_view_model.dart';
import 'package:awakn/views/sign_in/sign_in_view.dart';
import 'package:awakn/widgets/snackbar_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileViewModel extends GetxController {
  RxBool isLoading = false.obs;

  File? pickedFile;
  ImagePicker imagePicker = ImagePicker();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    fullNameController.text = globalCache.userProfile?.fullName ?? '';
    countryController.text = globalCache.userProfile?.country ?? '';
    cityController.text = globalCache.userProfile?.city ?? '';
    phoneNumberController.text = globalCache.userProfile?.phoneNo ?? '';
  }

  Future<void> takePhoto(ImageSource source) async {
    final pickedImage =
        await imagePicker.pickImage(source: source, imageQuality: 100);
    pickedFile = File(pickedImage!.path);
    update();
    Get.back();
  }

  Future<void> updateProfile() async {
    // if (!pageFormKey.currentState!.validate()) {
    //   SnackbarManager().showInfoSnackbar('Please enter valid credentials.');

    //   return;
    // }
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    if (await UserService().updateProfile(
        file: pickedFile,
        fullName: fullNameController.text.trim(),
        country: countryController.text.trim(),
        city: cityController.text.trim(),
        phoneNumber: phoneNumberController.text.trim())) {
      SnackbarManager().showSuccessSnackbar(Get.context!,'Profile updated successfully.');
      await Get.find<HomeViewModel>().getUserProfile();
      update();
    }
    isLoading.value = false;
  }

  Future<void> logout() async {
    // if (!pageFormKey.currentState!.validate()) {
    //   SnackbarManager().showInfoSnackbar('Please enter valid credentials.');

    //   return;
    // }
    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;
    if (await UserService().logout()) {
      SnackbarManager().showSuccessSnackbar(Get.context!,'User logged out successfully.');
      Get.offAll(() =>  SignInView());
    }
    isLoading.value = false;
  }
}
