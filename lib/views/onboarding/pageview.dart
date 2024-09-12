import 'package:autostart_settings/autostart_settings.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/onboarding/onboarding_screen2.dart';
import 'package:awakn/views/sign_in/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/snackbar_manager.dart';
import 'onboarding_screen1.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  final List<Widget> pages = [
    const OnBoardingScreen1(),
    const OnBoardingScreen2(),
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: pages,
            onPageChanged: (int page) {
              // Handle page changes if needed
              debugPrint("Current Page: $page");
              setState(() {
                // Update the current page index
                currentPageIndex = page;
              });
            },
          ),
          Positioned(
            top: 600.sp,
            child: Visibility(
              visible: currentPageIndex == 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      height: 50.sp,
                      width: 120.sp,
                      text: "Skip",
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
                            print('Both initAutoStart and openSettings failed');
                            SnackbarManager().showInfoSnackbar(
                                Get.context!, 'Autostart not available');
                          }
                        }
                      },
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    CustomButton(
                      height: 50.sp,
                      width: 120.sp,
                      text: "Next",
                      onTap: () {
                        // Increment the current page index to move to the next page
                        if (currentPageIndex < pages.length - 1) {
                          setState(() {
                            currentPageIndex++;
                          });
                          _pageController.animateToPage(
                            currentPageIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: pages.length,
                effect:
                    const ExpandingDotsEffect(), // Choose your preferred effect
              ),
            ),
          ),
        ],
      ),
    );
  }
}
