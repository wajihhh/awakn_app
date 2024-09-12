import 'package:awakn/views/sign_up/sign_up_view_model.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../sign_in/sign_in_view.dart';
import '../theming/theme.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Get.put(SignUpViewModel());
    // final model = SignInViewModel();
    return Obx(() => CustomLoaderWidget(
        isTrue: model.isLoading.value,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            // color: Colors,
            decoration: Theme.of(context).brightness == Brightness.dark
                ? BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/sky.png'),
                        fit: BoxFit.fill))
                : BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/sky register.png'),
                        fit: BoxFit.fill)),
            child: Column(children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  decoration: Theme.of(context).brightness == Brightness.dark
                      ? const BoxDecoration(
                          image: DecorationImage(
                              alignment: Alignment.bottomRight,
                              image: AssetImage("assets/images/sky.png")),
                          // color: Color(0xFFF791AFC),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40)))
                      : BoxDecoration(
                          image: DecorationImage(
                              alignment: Alignment.bottomRight,
                              image:
                                  AssetImage("assets/images/sky register.png")),
                          // color: Color(0xFFF791AFC),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40))),
                  height: 125.sp,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                      child: Text(
                    "Register",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  color: Color(0xff472EC9),
                  child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      gradient: CustomTheme.getLinearGradient(context),

                      // color: Colors.yellow,
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Theme.of(context).colorScheme.primary,
                      //     Theme.of(context).colorScheme.secondary,
                      //     Theme.of(context).colorScheme.onPrimary,
                      //     Theme.of(context).colorScheme.onSecondary,
                      //   ],
                      //   begin: Alignment.topRight,
                      //   end: Alignment.bottomLeft,
                      // ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                      ),
                    ),
                    child: Form(
                      key: model.pageFormKey,
                      child: signUpForm(model, context),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        )));
  }

  Widget signUpForm(SignUpViewModel model, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.sp,
            ),
            Text("Sign Up To Get Started!",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.w600, fontSize: 20)),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              labeltext: 'Full name',
              placeholdertext: 'Josh Luis',
              controller: model.fullNameController,
            ),
            const SizedBox(
              height: 10,
            ),

            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              // textInputType: TextInputType.emailAddress,
              labeltext: 'Email Address',
              placeholdertext: 'joshluis@gmail.com',
              controller: model.emailController,
            ),
            const SizedBox(
              height: 10,
            ),

            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              textInputType: TextInputType.number,
              labeltext: 'Phone Number',
              placeholdertext: '23456789',
              controller: model.phoneNumberController,
            ),
            const SizedBox(
              height: 10,
            ),

            CustomTextField(
              textInputType: TextInputType.text,
              labeltext: 'Password',
              placeholdertext: '*********',
              sufixIcon: true,
              controller: model.passwordController,
            ),
            SizedBox(
              height: 25.sp,
            ),
            CustomButton(
              onTap: () => model.signUp(),
              height: 55.sp,
              width: 330.sp,
              text: "Register Account",
            ),
            SizedBox(
              height: 10.sp,
            ),
            CustomButton(
              text: "Continue as Guest",
              // width: 300.sp,
              height: 55.sp,
              width: 330.sp,
              onTap: () => model.guestSignIn(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 15),
                ),
                SizedBox(
                  width: 5.sp,
                ),
                GestureDetector(
                  onTap: () => Get.off(() => const SignInView()),
                  child: Text(
                    "Sign In",
                    style: Theme.of(context).brightness == Brightness.dark
                        ? TextStyle(
                            color: Color(
                              0xff6B46F6,
                            ),
                            decorationColor: Color(0xff6B46F6),
                            decoration: TextDecoration.underline,
                          )
                        : TextStyle(
                            color: Color(
                              0xffFFC100,
                            ),
                            decorationColor: Color(0xffFFC100),
                            decoration: TextDecoration.underline,
                          ),
                  ),
                ),
              ],
            ),
            // SizedBox(
            //   height: 30.sp,
            // ),
            GestureDetector(
              onTap: () {},
              child:
                  Center(child: SvgPicture.asset("assets/images/icon (5).svg")),
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Text(
                "sign up with google",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 15),
              ),
            )
            // SizedBox(height: 10,),
            // Text("Sign Up With Google")
          ],
        ),
      ),
    );
  }
}
