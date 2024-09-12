import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../theming/theme.dart';
import 'forgot_password_view_model.dart';

class ForgotPasswordView extends StatelessWidget {
  // final ForgotPasswordController forgotPasswordController = Get.put(Forgo tPasswordController());

  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    final model = Get.put(ForgotPasswordController());

    return Obx(() => CustomLoaderWidget(
        isTrue: model.isLoading.value,
        child: Container(
          decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: ReusableAppBar(
              title: '',
            ),
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Forgot Password",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  )),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                            "Forgot your password? No problem. Just enter your email, and we'll guide you through resetting it.",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                )),
                      ),
                      SizedBox(
                        height: 30.sp,
                      ),
                      CustomTextField(
                        controller: model.emailController,

                        labeltext: 'Email Address',
                        placeholdertext: "joshluis@gmail.com",
                        // labelText: 'EmailAddress',
                      )
                    ],
                  ),
                  CustomButton(
                    text: "Recover Password",
                    // width: 300.sp,
                    height: 55.sp,
                    width: 330.sp,
                    onTap: () {
                      // Get.to(PasswordResetScreen());
                      // successDialog(context);

                      model.forgetPassword();
                      // forgotPasswordController.sendForgotPasswordRequest(emailController.text);
                    },
                  ),
                  // Obx(() {
                  //   if (forgotPasswordController.isLoading.value) {
                  //     return Padding(
                  //       padding: EdgeInsets.only(top: 16),
                  //       child: CircularProgressIndicator(),
                  //     );
                  //   } else {
                  //     return SizedBox.shrink();
                  //   }
                  // }),
                ],
              ),
            ),
          ),
        )));
  }
}

Future<dynamic> successDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // stops: [0.0,0.1],
              // #6D3FFF, #9878FF
              // #6D3FFF, #9878FF
              colors: [
            // #6D3FFF, #9878FF
            Color(0xff1F1743),
            Color(0xff110D28),
            Color(0xff110D28),
            Color(0xff1F1743),
          ])),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actionsAlignment: MainAxisAlignment.center,
        backgroundColor: Colors.transparent,
        title: Column(
          children: [
            // SizedBox(height: 10,),
            SizedBox(
              height: 60,
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
                  color: Colors.white),
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
        actions: [
          ElevatedButton(
            child: const Text("OK"),
            onPressed: () {
              Get.back();
              // Get.close(2);
            },
          ),
        ],
        // content:Text("Success! A password reset email has been sent to your inbox. Please check your email and follow the instructions to reset your password.",textAlign: TextAlign.center),
      ),
    ),
  );
}
