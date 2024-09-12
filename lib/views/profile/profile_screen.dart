import 'package:awakn/utils/global.dart';
import 'package:awakn/views/change_password/change_password_screen.dart';
import 'package:awakn/views/profile/profile_settings_view.dart';
import 'package:awakn/views/profile/profile_view_model.dart';
import 'package:awakn/widgets/customappbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../widgets/feature_tour_icon.dart';
import '../general_setting/general_settings_view.dart';
import '../likesandinterests/like_and_interest_view.dart';
import '../rate_app.dart';
import '../subscriptions/subscription_view.dart';
import '../theming/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileViewModel>(
      init: Get.put(ProfileViewModel()),
      initState: (_) {},
      builder: (model) {
        return Container(
          decoration:
              BoxDecoration(gradient: CustomTheme.getLinearGradient(context)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: ReusableAppBar(title: "My Profile ",actions: [
              FeatureTour(),
              const SizedBox(
                width: 10,
              )
            ],),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Centered Circular Image and Text
                  Center(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              globalCache.userProfile?.profilePicture ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/Oval.png',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(globalCache.userProfile?.fullName ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // List of Full-width Cards
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            CustomProfileCard(
                              title: 'General Settings',
                              icon: Icons.arrow_forward_ios,
                              onTap: () {
                                Get.to(() => const GeneralSettings());
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomProfileCard(
                              title: 'Profile Settings',
                              icon: Icons.arrow_forward_ios,
                              onTap: () =>
                                  Get.to(() => const ProfileSettingsView()),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomProfileCard(
                              onTap: () {
                                Get.to(() => const LikeView());
                              },
                              title: 'Likes And Interests',
                              icon: Icons.arrow_forward_ios,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomProfileCard(
                              onTap: () {
                                Get.to(() => const SubscriptionScreen());
                              },
                              title: 'My Subscription',
                              icon: Icons.arrow_forward_ios,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomProfileCard(
                              title: 'Password Reset',
                              icon: Icons.arrow_forward_ios,
                              onTap: () =>
                                  Get.to(() => const PasswordResetScreen()),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomProfileCard(
                              title: 'Rate The App',
                              icon: Icons.arrow_forward_ios,
                              onTap: () {
                                Get.to(() => const RateApplication());
                              },
                            ),
                          ],
                        ),
                        CustomProfileCard(
                          title: 'Logout',
                          icon: Icons.arrow_forward_ios,
                          onTap: () => model.logout(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomProfileCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;

  const CustomProfileCard({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: Theme.of(context).brightness == Brightness.light
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(52),
                color: Color(0xff4023AB),
                border: Border.all(color: Colors.white),
                boxShadow: [
                    // BoxShadow(
                    //   color: Colors.grey.withOpacity(0.2),
                    //   blurRadius: 20,
                    //   offset: const Offset(4, 2),
                    // )
                  ])
            : BoxDecoration(
                borderRadius: BorderRadius.circular(52),
                color: const Color(0xff040112),
              ),
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: Colors.transparent,
        //     width: 1,
        //   ),
        //   borderRadius: BorderRadius.circular(52),
        //   color: const Color(0xff271B56),
        // ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontSize: 15),
              ),
              Icon(
                icon,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
