import 'package:autostart_settings/autostart_settings.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/theming/theme.dart';
import 'package:awakn/widgets/custom_switch.dart';
import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/customtheme_button.dart';
import 'package:awakn/widgets/feature_tour_icon.dart';
import 'package:awakn/widgets/volume_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../widgets/snackbar_manager.dart';
import 'autostart.dart';
import 'autostart2.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: ReusableAppBar(
          actions: [
            FeatureTour(),
            const SizedBox(
              width: 10,
            )
          ],
          title: 'General Setting',
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                  decoration: Theme.of(context).brightness == Brightness.light
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Color(0xff4023AB),
                          boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(4, 2),
                              )
                            ])
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xff040112),
                        ),
                  height: 70,
                  width: 343,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/Icon (1).svg",
                              height: 40,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 260,
                                      // color: Colors.pink,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("General Alarm Volume",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                          // SizedBox(width: 90,),
                                          SvgPicture.asset(
                                            "assets/images/Icon (2).svg",
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                    height: 20,
                                    // width: 100,
                                    child: Row(
                                      children: [
                                        VolumeControlWidget(),
                                      ],
                                    )),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 20.sp,
              ),
              ListTile(
                trailing: Column(
                  children: [
                    SizedBox(
                      height: 10.sp,
                    ),
                    CustomThemeSwitch()
                  ],
                ),
                title: const Text(
                  'Color Mode',
                ),
                subtitle: const Text(
                  'Switch to dark mode or light mode',
                ),
                onTap: () {
                  // Handle onTap for Item 1
                  debugPrint('Item 1 tapped');
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                trailing: Column(
                  children: [
                    SizedBox(
                      height: 10.sp,
                    ),
                    CustomSwitchWithText(
                      value: true,
                      onTap: () {},
                    ),
                  ],
                ),
                title: const Text(
                  'Smooth Wake Up',
                  style: TextStyle(),
                ),
                subtitle: const Text(
                  'Initial smoothing time: 10 seconds',
                ),
                onTap: () {
                  // Handle onTap for Item 1
                  debugPrint('Item 1 tapped');
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                trailing: Column(
                  children: [
                    SizedBox(
                      height: 10.sp,
                    ),
                    CustomSwitchWithText(
                      value: true,
                      onTap: () {},
                    ),
                  ],
                ),
                title: const Text(
                  'Block Alarm During Calls',
                ),
                subtitle: const Text(
                  'This feature will block alarm during calls and games',
                ),
                onTap: () {
                  // Handle onTap for Item 1
                  debugPrint('Item 1 tapped');
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                trailing: Column(
                  children: [
                    SizedBox(
                      height: 10.sp,
                    ),
                    CustomSwitchWithText(
                      value: true,
                      onTap: () {},
                    ),
                  ],
                ),
                title: const Text(
                  'Sticky Alarm Until Task Completes',
                ),
                subtitle: const Text(
                  'Alarm wont disappear until tasks are done',
                ),
                onTap: () {
                  // Handle onTap for Item 1
                  debugPrint('Item 1 tapped');
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                trailing: Column(
                  children: [
                    SizedBox(
                      height: 10.sp,
                    ),
                    CustomSwitchWithText(
                      value: true,
                      onTap: () {},
                    ),
                  ],
                ),
                title: const Text(
                  'Do Not Disturb Mode',
                ),
                subtitle: const Text(
                  'Alarm wont ring in do not phone’s disturb mode',
                ),
                onTap: () {
                  // Handle onTap for Item 1
                  debugPrint('Item 1 tapped');
                },
              ),
              SizedBox(
                height: 20.sp,
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward_ios,color: Colors.white,),
                title: const Text(
                  'Background Auto start',
                ),
                subtitle: const Text(
                  'Enable background auto start for Awakn app',
                ),
                onTap: () async {
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
                      // Get.offAll(() => const SignInView());
                    } else {
                      // Get.offAll(() => const SignInView());

                      // Handle the case where both initAutoStart() and openSettings() fail
                      // For example, show an error message or take some other action
                      print(
                          'Both initAutoStart and openSettings failed');
                      SnackbarManager().showInfoSnackbar(
                          Get.context!, 'Autostart not available');
                    }
                  }
                }
              ),


              // Add more ListTiles as needed
            ],
          ),
        ),
      ),
    );
  }
}
