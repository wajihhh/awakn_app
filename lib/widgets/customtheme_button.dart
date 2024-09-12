import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomThemeSwitchController extends GetxController {
  late SharedPreferences _prefs;
  RxBool isSwitched = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
    isSwitched.value = _prefs.getBool('isDarkMode') ?? false;
    // Apply the saved theme on app start
    Get.changeThemeMode(isSwitched.value ? ThemeMode.dark : ThemeMode.light);
  }

  void switchTheme(bool isDarkMode) {
    _prefs.setBool('isDarkMode', isDarkMode);
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleSwitch(bool value) {
    isSwitched.value = value;
    switchTheme(value);
  }
}

class CustomThemeSwitch extends StatelessWidget {
  final CustomThemeSwitchController controller = Get.find<CustomThemeSwitchController>();


  CustomThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.toggleSwitch(!controller.isSwitched.value);
          },
          child: Obx(() {
            return Container(
              width: 50.sp,
              height: 25.sp,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                  color: controller.isSwitched.value
                      ? const Color(0xff6B46F6)
                      : const Color(0xffF59C30),
                ),
                color: controller.isSwitched.value
                    ? Colors.white.withOpacity(0.3)
                    : Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!controller.isSwitched.value)
                    const Center(
                        child: Icon(
                      CupertinoIcons.brightness,
                      size: 20,
                      color: Color(0xffF59C30),
                    )),
                  Container(
                    width: 22.sp,
                    height: 22.sp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: controller.isSwitched.value
                            ? Colors.white
                            : const Color(0xffF59C30),
                      ),
                      color: controller.isSwitched.value
                          ? Colors.white
                          : Colors.pink.withOpacity(0.1),
                    ),
                  ),
                  if (controller.isSwitched.value)
                    const Icon(
                      CupertinoIcons.moon_stars,
                      size: 20,
                      color: Colors.white,
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
