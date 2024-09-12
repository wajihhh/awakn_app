import 'dart:io';
import 'package:awakn/utils/global.dart';
import 'package:awakn/widgets/customappbar.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/feature_tour_icon.dart';
import '../theming/theme.dart';
import 'profile_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ProfileSettingsView extends StatelessWidget {
  const ProfileSettingsView({super.key});

  @override
  Widget build(BuildContext context) {

    return GetX<ProfileViewModel>(
      init: Get.find<ProfileViewModel>(),
      builder: (model) {
        return CustomLoaderWidget(
          isTrue: model.isLoading.value,
          child: Container(
            decoration: BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),

            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: ReusableAppBar(title: "Profile Setting",actions: [
                FeatureTour(),                const SizedBox(
                  width: 10,
                )
              ],),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25
                    // vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GetBuilder<ProfileViewModel>(
                            init: model,
                            initState: (_) {},
                            builder: (_) {
                              return SizedBox(
                                width: 80.sp,
                                height: 80.sp,
                                child: model.pickedFile != null
                                    ? CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            model.pickedFile != null
                                                ? FileImage(File(model.pickedFile!.path),)as ImageProvider
                                                : null,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: globalCache
                                                .userProfile?.profilePicture ??
                                            '',
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 80.0,
                                          height: 80.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          'assets/images/Oval.png',
                                        ),
                                      ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => bottomSheet(
                                        context,
                                        model,
                                      ));
                            },
                            child:  Text(
                              "Change Picture",
                              style: Theme.of(context).brightness==Brightness.dark
                                  ?const TextStyle(
                                fontSize: 14,
                                color: Color(
                                  0xff6B46F6,
                                ),
                                decorationColor: Color(0xff6B46F6),
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              )
                                  :const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                decorationColor:Colors.white,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      CustomTextField(
                        controller: model.fullNameController,

                        labeltext: "Full Name",
                        placeholdertext: "Stevean@gmail.com",
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(color: Colors.grey)),
                        height: 60,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 17.0, left: 20),
                          child: Text(
                            globalCache.userProfile?.email ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 14,color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      CustomTextField(
                        controller: model.phoneNumberController,
                        labeltext: "Phone Number",
                        placeholdertext: "12012565440",
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      CustomTextField(
                        controller: model.cityController,
                        labeltext: "City",
                        placeholdertext: "Jordan",
                      ),
                      SizedBox(
                        height: 15.sp,
                      ),
                      CustomTextField(
                        controller: model.countryController,
                        labeltext: "Country",
                        placeholdertext: "Petra",
                      ),
                      SizedBox(
                        height: 40.sp,
                      ),
                      CustomButton(
                        text: "Edit Details",
                        height: 55.sp,
                        width: 300.sp,
                        onTap: () => model.updateProfile(),
                      ),

                    ],
                  ),
                ),

              ),
            ),
          ),
        );
      },
    );
  }

  Widget bottomSheet(
    BuildContext context,
    ProfileViewModel profileController,
  ) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: double.infinity,
      height: size.height * 0.2,
      color: Colors.transparent,
      child: Column(
        children: [
          const Text(
            "Choose Profile Photo",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  profileController.takePhoto(ImageSource.gallery);
                  // print("Gallery");
                },
                child: const Column(
                  children: [
                    Icon(Icons.image),
                    Text(
                      "Gallery",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 60,
              ),
              GestureDetector(
                onTap: () {
                  profileController.takePhoto(ImageSource.camera);
                  // print("Camera");
                },
                child: const Column(
                  children: [
                    Icon(Icons.camera),
                    Text(
                      "camera",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
