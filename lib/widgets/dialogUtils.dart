import 'package:awakn/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DialogUtils {
  static Future<dynamic> showSuccessDialog(BuildContext context) async {
    Get.dialog(
      Container(
        decoration: Theme.of(context).brightness == Brightness.dark
            ? BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.onPrimary,
                Theme.of(context).colorScheme.onSecondary,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ))
            : BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff7456DA),
              Color(0xff47459F ),
              Color(0xff2C4386),
            ],
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.transparent,
          title: Column(
            children: [
              SizedBox(
                height: 60,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset("assets/images/Union.png"),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                          "assets/images/disable-alarm copy 1 (2).png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Email Has been sent",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Success! A password reset email has been sent to your inbox. Please check your email and follow the instructions to reset your password.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );

    // Delay for 3 seconds and then close the dialog
    await Future.delayed(const Duration(seconds: 1));

    // Close the dialog after the delay
    Get.back();
  }

  static Future<dynamic> showFeatureTourDialog(BuildContext context) {
    return Get.dialog(
      Container(
        decoration: Theme.of(context).brightness == Brightness.dark
            ? BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.onSecondary,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ))
            : BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff7456DA),
              Color(0xff47459F ),
              Color(0xff2C4386),
            ],
          ),
        ),
        child: AlertDialog(
          titlePadding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.transparent,
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Feature Tour",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xff040112)
                          : Colors.black12,
                      borderRadius: BorderRadius.circular(10)),
                  height: 250,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.   Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 15,
                                  )),
                    ),
                  )),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6B46F6)),
              child: const Text(
                "Got it",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  static Future<dynamic> subscriptionSuccessDialog(BuildContext context) {
    return Get.dialog(
      Container(
        decoration: Theme.of(context).brightness == Brightness.dark
            ? BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.onSecondary,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ))
            : BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff7456DA),
              Color(0xff47459F ),
              Color(0xff2C4386),
            ],
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.transparent,
          title: Column(
            children: [
              SizedBox(
                height: 60,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset("assets/images/Union.png"),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset("assets/images/confirm copy 2.png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Great! You’re subscribed now",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Fantastic news! You're now officially subscribed, and exciting updates are on their way to your inbox",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 12),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 40.sp,
                width: 293.sp,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    // border: Border.all(color: Color(0xff8990A1)),
                    color: const Color(0xff6B46F6)),
                child: const Center(
                  child: Text("Go Back To Home",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<dynamic> reviewSuccessDialog(BuildContext context) {
    return Get.dialog(
      Container(
        decoration: Theme.of(context).brightness == Brightness.dark
            ? BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.onSecondary,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ))
            : BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff7456DA),
              Color(0xff47459F ),
              Color(0xff2C4386),
            ],
          ),
        ),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),

          title: Column(
            children: [
              // SizedBox(height: 10,),
              SizedBox(
                height: 60,
                // color: Colors.black12,
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset("assets/images/Union.png"),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                          "assets/images/disable-alarm copy 1 (3).png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Review has been Submitted",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Thank you for your review! Your feedback is valuable to us.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 12),
              )
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6B46F6)),
                child: const Text(
                  "Ok",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<dynamic> historyCompleteDialog(BuildContext context) {
    return Get.dialog(
      Container(
        decoration: Theme.of(context).brightness == Brightness.dark
            ? BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.onPrimary,
                  Theme.of(context).colorScheme.onSecondary,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ))
            : const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xff7456DA),
              Color(0xff47459F ),
              Color(0xff2C4386),
            ],
          ),
        ),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          title: Column(
            children: [
              // SizedBox(height: 10,),
              SizedBox(
                height: 60,
                // color: Colors.black12,
                child: Stack(
                  // alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset("assets/images/Union.png"),
                    ),
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                          "assets/images/disable-alarm copy 1 (3).png"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("You Have Done A Great Job!",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: 16,
                        // color: Colors.black,
                        fontWeight: FontWeight.w500,
                      )),
              const SizedBox(
                height: 10,
              ),
              Text(
                  "Outstanding! Your dedication and effort have paid off, and you've successfully completed the task. Keep up the great work!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 12))
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff6B46F6)),
                child: const Text(
                  "Go Back To Home",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Get.offAll(() => const HomeView());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
