import 'package:awakn/views/onboarding/onboarding_screen2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/theme.dart';

class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  final controller = PageController();
  final List<Widget> pages = [
    const OnBoardingScreen1(),
    const OnBoardingScreen2(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/OB1.png',
              height: 300,
              // width: width,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 30.sp,
            ),
            Text(
              "Planner, Reminder, Motivator",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et adipiscing elit",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: 15

                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40.sp,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Expanded(
                  //   flex: 2,
                  //   child: Custom_Button(
                  //       height: 50.sp,
                  //   width : 100.sp,
                  //     text: "Skip",
                  //     backgroundColor: Colors.white,
                  //     textColor: Colors.black,
                  //   ),
                  // ),
                  SizedBox(
                    width: 20,
                  ),
                  // Expanded(
                  //   flex: 2,
                  //   child: Custom_Button(
                  //
                  //     height: 50.sp,
                  //     width : 100.sp,
                  //     ontap: () {
                  //       Page_Navigation.getInstance.Page(
                  //         context,
                  //         OnBoardingScreen2(),
                  //       );
                  //     },
                  //     text: "Next",
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 60.sp,
            ),
          ],
        ),
      ),
    );
  }
}
