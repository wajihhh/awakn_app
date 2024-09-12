import 'package:autostart_settings/autostart_settings.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/sign_in/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/snackbar_manager.dart';
import '../theming/theme.dart';

class OnBoardingScreen2 extends StatelessWidget {
  const OnBoardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.only(
            top: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/OB2.png',
                height: 300,
                // width: width,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 30.sp,
              ),
              Text("Planner, Reminder, Motivator",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: 20,
                      )),
              SizedBox(
                height: 10.sp,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et adipiscing elit",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40.sp,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomButton(
                        height: 50.sp,
                        onTap: () async {
                          Get.offAll(() => const SignInView());

                          bool initSuccess = await initAutoStart();

                          if (initSuccess) {
                            print('package one success');

                            // If initAutoStart() is successful, navigate to SignInView
                          } else {
                            // If initAutoStart() fails, try openSettings()
                            bool settingsSuccess = await openSettings();

                            if (settingsSuccess) {
                              print('package two success');

                              // If openSettings() is successful, navigate to SignInView
                              Get.offAll(() => const SignInView());
                            } else {
                              Get.offAll(() => const SignInView());

                              // Handle the case where both initAutoStart() and openSettings() fail
                              // For example, show an error message or take some other action
                              print(
                                  'Both initAutoStart and openSettings failed');
                              SnackbarManager().showInfoSnackbar(
                                  Get.context!, 'Autostart not available');
                            }
                          }
                        },
                        text: 'Next',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 60.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
