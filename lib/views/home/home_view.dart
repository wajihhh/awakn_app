import 'package:awakn/utils/app_colors.dart';
import 'package:awakn/utils/global.dart';
import 'package:awakn/views/home/alarm_card.dart';
import 'package:awakn/views/home/home_view_model.dart';
import 'package:awakn/views/profile/profile_screen.dart';
import 'package:awakn/widgets/feature_tour_icon.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../widgets/dialogUtils.dart';
import '../create_alarm/create_alarm_view.dart';
import '../theming/theme.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Get.put(HomeViewModel());

    return Obx(
      () => CustomLoaderWidget(
        isTrue: model.isLoading.value,
        child: SafeArea(
            child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Theme.of(context).brightness == Brightness.light
                    ? 'assets/images/bg main l.png'
                    : 'assets/images/bg main d.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 40),
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                // color: Theme.of(context).brightness == Brightness.light
                //     ? Colors.white
                //     : const Color(0xff6B46F6),
                child: Column(
                  children: [
                    SvgPicture.asset('assets/images/Asset 1 2.svg',height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          // margin: const EdgeInsets.all(10),
                          // height: 80,
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text("Hello",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontSize: 16,
                                      )),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(model.userProfile.value?.fullName ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: const FeatureTour(),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFCFAFD),
                                  borderRadius: BorderRadius.circular(44),
                                  border: Border.all(
                                      color: const Color(0xff9B9EE7))),
                              height: 44,
                              width: 44,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => const ProfileScreen());
                                },
                                child: CachedNetworkImage(
                                  imageUrl:
                                      globalCache.userProfile?.profilePicture ??
                                          '',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    // width: 40.0,
                                    // height: 40.0,
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
                                //  CircleAvatar(
                                //   backgroundColor: const Color(0xff1F1743),
                                //   child: Image.asset(
                                //     "assets/images/Mask-removebg-preview.png",
                                //   ),
                                // ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       // TODO (Junaid): temp navigation
                    //
                    //       model.navigateToRingScreen(null);
                    //       // Get.to(() => const FaceDetectorView());
                    //     },
                    //     child: Text(
                    //       "Trigger Alarm",
                    //       style: Theme.of(context)
                    //           .textTheme
                    //           .titleLarge!
                    //           .copyWith(fontSize: 14,color: Colors.white),
                    //     )),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My Alarms",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: model.userAlarmsList.isEmpty &&
                              model.isLoading.value == false
                          ? Center(
                              child: Text(
                                  "You don't have any alarm set in your list.\n Please click on the '+' button below to add a new alarm.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                            )
                          : RefreshIndicator(
                              backgroundColor: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              onRefresh: () =>
                                  model.getUserAlarms(showLoader: true),
                              child: ListView.builder(
                                  itemCount: model.userAlarmsList.length,
                                  itemBuilder: (context, index) {
                                    // String day = card[index].day;
                                    // int time = card[index].time;
                                    // String task = card[index].task;
                                    // String action = card[index].action;

                                    return AlarmCardWidget(
                                        alarm: model.userAlarmsList[index]);
                                  }),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.to(() => const CreateAlarmView()),
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        )),
      ),
    );
  }
}
