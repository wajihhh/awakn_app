import 'package:awakn/utils/app_colors.dart';
import 'package:awakn/views/forgot_password/forgot_password_view.dart';
import 'package:awakn/views/sign_up/sign_up_view.dart';
import 'package:awakn/views/sign_in/sign_in_view_model.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../theming/theme.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = Get.put(SignInViewModel());

    // final model = SignInViewModel();
    return Obx(() => CustomLoaderWidget(
          isTrue: model.isLoading.value,
          child: Container(
            decoration:
                BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Form(
                  key: model.pageFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(
                          Theme.of(context).brightness == Brightness.dark
                              ? 'assets/images/sky.png'
                              : 'assets/images/skylight.png',
                          fit: BoxFit.fitWidth,
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/Frame 39780.svg',
                                // width: 60,
                                height: 30,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text("Welcome Back!",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text("Sign in to continue",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  CustomTextField(
                                    placeholdertext: "joshluis@mail.com",
                                    labeltext: "Email Address",
                                    controller: model.emailController,
                                  ),
                                  SizedBox(
                                    height: 10.sp,
                                  ),
                                  CustomTextField(
                                    textInputType: TextInputType.text,
                                    labeltext: "Password",
                                    placeholdertext: "********",
                                    sufixIcon: true,
                                    controller: model.passwordController,
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  height: 20.sp,
                                  alignment: Alignment.center,
                                  child: !model.invalidCreds.value
                                      ? null
                                      : Text('Invalid e-mail or password',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                              )),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        side: const BorderSide(
                                            color: Color(0xffA188FF)),
                                        activeColor: const Color(0xffA188FF),
                                        value: model.rememberMe.value,
                                        onChanged: (bool? value) =>
                                            model.rememberMe(value),
                                      ),
                                      Text(
                                        "Remember me",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                // fontSize: 14,
                                                // fontWeight: FontWeight.w400,
                                                ),
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        Get.to(() => ForgotPasswordView()),
                                    child: Text(
                                      "Forgot password?",
                                      style: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? TextStyle(
                                              color: Color(
                                                0xff6B46F6,
                                              ),
                                              decorationColor:
                                                  Color(0xff6B46F6),
                                              decoration:
                                                  TextDecoration.underline,
                                            )
                                          : TextStyle(
                                              color: Color(
                                                0xffFFC100,
                                              ),
                                              decorationColor:
                                                  Color(0xffFFC100),
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   height: 5,
                                  // ),
                                  // const Text(
                                  //   "sign up with google",
                                  //   style: TextStyle(color: Colors.white),
                                  // )
                                ],
                              ),
                              SizedBox(
                                height: 20.sp,
                              ),
                              CustomButton(
                                text: "Sign In",
                                // width: 300.sp,
                                height: 55.sp,
                                width: 330.sp,
                                onTap: () => model.signIn(),
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
                              SizedBox(
                                height: 20.sp,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don’t have an account?",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  SizedBox(
                                    height: 50.sp,
                                  ),
                                  SizedBox(
                                    width: 5.sp,
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        Get.off(() => const SignUpView()),
                                    child: Text(
                                      "Sign Up",
                                      style: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? TextStyle(
                                              color: Color(
                                                0xff6B46F6,
                                              ),
                                              decorationColor:
                                                  Color(0xff6B46F6),
                                              decoration:
                                                  TextDecoration.underline,
                                            )
                                          : TextStyle(
                                              color: Color(
                                                0xffFFC100,
                                              ),
                                              decorationColor:
                                                  Color(0xffFFC100),
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              GestureDetector(
                                  onTap: () => model.handleGoogleSignIn(),
                                  child: SvgPicture.asset(
                                      "assets/images/icon (5).svg")),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "sign up with google",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
