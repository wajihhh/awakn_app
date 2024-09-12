import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:awakn/models/alarm_feed_response.dart';
import 'package:awakn/utils/app_colors.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/alarm_trigger/alarm_trigger_view_model.dart';
import 'package:awakn/views/alarm_trigger/reels/animation_controller.dart';
import 'package:awakn/views/alarm_trigger/reels/custom_story_view.dart';
import 'package:awakn/views/alarm_trigger/reels/reel_view_model.dart';
import 'package:awakn/views/alarm_trigger/reels/slide_animation.dart';
import 'package:awakn/widgets/custom_button.dart';
import 'package:awakn/widgets/dialogUtils.dart';
import 'package:awakn/widgets/loader_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flare_flutter/base/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:story_view/widgets/story_view.dart';

class ReelsPage extends StatelessWidget {
  const ReelsPage({super.key});

  @override
  Widget build(BuildContext context) {

    const animationDuration = Duration(seconds: 2);
    final alarmTriggerModel = Get.find<AlarmTriggerViewModel>();
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    bool isAnimatedBuilderShown = true;

    return GetX<ReelsController>(
      init: Get.find<ReelsController>(),
      initState: (state) {
        final model = state.controller;
        if (model != null) {
          if (model.userAlarmsList.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              model.getAlarmData().then((value) {
                if (value) {
                  model.initiateReels();
                }
              });
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              model.initiateReels();
            });
          }
        }
      },
      dispose: (state) {
        // final alarmTriggerModel = Get.find<AlarmTriggerViewModel>();
        // debugPrint('Live feed stops');
        // alarmTriggerModel.stopLiveFeed();
        // debugPrint('disposed called on reels page');
        // state.controller?.animationController.dispose();
      },
      builder: (controller) {
        int currentIndex = controller.currentIndex.value;
        AlarmFeed? alarmFeed = controller.userAlarmsList.isEmpty
            ? null
            : controller.userAlarmsList[currentIndex];

        return PopScope(
          canPop: false,
          onPopInvoked: (value) {},
          child: Scaffold(
              backgroundColor: const Color.fromRGBO(6, 31, 255, 0.004),
              body: controller.isLoading.value
                  ? const Center(
                      child: CustomLoaderWidget(
                        isTrue: true,
                        child: SizedBox.shrink(),
                      ),
                    )
                  : controller.userAlarmsList.isEmpty
                      ? SizedBox.expand(
                          child: Text(
                            'No Data',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? const Color(0xff302B4a)
                                    : null),
                          ),
                        )
                      :
                      // GetBuilder<DotAnimationController>(
                      //     init: DotAnimationController(),
                      //     builder: (animationController) {
                      //       final screenSize = MediaQuery.of(context).size;
                      //       animationController.setAnimations(
                      //           screenSize.width, screenSize.height);
                      //       return
                      Stack(
                          children: [
                            if (controller.storyList.isNotEmpty)
                              IgnorePointer(
                                ignoring: false,
                                child: CustomStoryView(
                                  storyItems: controller.storyList,
                                  onStoryShow: (storyItem, index) {
                                    log('Current Index on story: $index');
                                    log('Current Index on storyItem: ${storyItem.shown}');

                                    if (index !=
                                        controller.currentIndex.value) {
                                      // controller.currentIndex.value = index;
                                      // controller.handleChangeStory();
                                      // animationController.initiate();
                                    }
                                    print("Showing a story");
                                    // storyItem.duration;
                                  },
                                  onComplete: () {
                                    controller.taskCompleted(true);
                                    // DialogUtils.historyCompleteDialog(context);
                                  },
                                  progressPosition: ProgressPosition.top,
                                  indicatorForegroundColor:
                                      AppColors.primaryColor,
                                  // repeat: true,
                                  controller: controller.storyController,
                                ),
                                // child: StoryView(
                                //   storyItems: controller.storyList,
                                //   onStoryShow: (storyItem, index) {
                                //     log('Current Index on story: $index');
                                //     log('Current Index on storyItem: ${storyItem.shown}');

                                //     if (index !=
                                //         controller.currentIndex.value) {
                                //       controller.currentIndex.value = index;
                                //       controller.handleChangeStory();
                                //       // animationController.initiate();
                                //     }
                                //     print("Showing a story");
                                //     // storyItem.duration;
                                //   },
                                //   onComplete: () {
                                //     controller.taskCompleted(true);
                                //     // DialogUtils.historyCompleteDialog(context);
                                //   },
                                //   progressPosition: ProgressPosition.top,
                                //   // repeat: true,
                                //   controller: controller.storyController,
                                // ),
                              ),
                            // _backgroundImage(
                            //   controller
                            //           .userAlarmsList[
                            //               controller.currentIndex.value]
                            //           .image ??
                            //       '',
                            // ),
                            // Positioned(
                            //   // top: isPortrait ? 0 : 40,
                            //   child: AnimatedBuilder(
                            //     animation:
                            //         animationController.zoomController,
                            //     builder: (context, child) =>
                            //         AnimatedBuilder(
                            //       animation:
                            //           animationController.slideController,
                            //       builder: (context, child) {
                            //         return Transform.scale(
                            //           scale: animationController
                            //               .zoomAnimation.value,
                            //           child: SlideTransition(
                            //             position: animationController
                            //                 .slideAnimation,
                            //             child: _backgroundImage(
                            //               controller
                            //                       .userAlarmsList[
                            //                           controller
                            //                               .currentIndex
                            //                               .value]
                            //                       .image ??
                            //                   '',
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //     ),
                            //   ),
                            // ),

                            // TODO (Junaid): check overlay color issue

                            // if (animationController.showAnimatedBuilder &&
                            //     controller.currentAction == null &&
                            //     isAnimatedBuilderShown)
                            //   Positioned(
                            //     top: animationController.randomTop < 0.5
                            //         ? 1
                            //         : null,
                            //     bottom:
                            //         animationController.randomBottom >= 0.5
                            //             ? 1
                            //             : null,
                            //     left: animationController.randomTop >= 0.5
                            //         ? 1
                            //         : null,
                            //     right: animationController.randomBottom < 0.5
                            //         ? 1
                            //         : null,
                            //     child: AnimatedBuilder(
                            //       animation: animationController
                            //           .zoomYellowController,
                            //       builder: (context, child) {
                            //         return Transform.scale(
                            //           scale: animationController
                            //               .zoomYellowAnimation.value,
                            //           child: AnimatedBuilder(
                            //             animation: animationController
                            //                 .animationController,
                            //             builder: (context, child) {
                            //               return SizedBox(
                            //                 width: animationController
                            //                     .widthAnimation.value,
                            //                 height: animationController
                            //                     .heightAnimation.value,
                            //                 child: Container(
                            //                   decoration: ShapeDecoration(
                            //                     color: animationController
                            //                         .randomColor
                            //                         .withOpacity(0.8),
                            //                     shape: animationController
                            //                                 .shapeType ==
                            //                             ShapeType.circle
                            //                         ? const CircleBorder()
                            //                         : animationController
                            //                                     .shapeType ==
                            //                                 ShapeType
                            //                                     .rectangle
                            //                             ? const RoundedRectangleBorder()
                            //                             : DiamondBorder(),
                            //                   ),
                            //                 ),
                            //               );
                            //             },
                            //           ),
                            //         );
                            //       },
                            //     ),
                            //   ),
                            Obx(
                              () {
                                return Positioned.fill(
                                  top: 72,
                                  child: Column(
                                    children: [
                                      const ReelHeaderWidget(),
                                      SizedBox(
                                        height: MediaQuery.of(context)
                                                    .orientation ==
                                                Orientation.portrait
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                      ),

                                      //Todo action
                                      if (alarmFeed?.action != null)
                                        Align(
                                          alignment: Alignment.center,
                                          child:
                                              //  AnimatedOpacity(
                                              //   opacity: controller
                                              //           .actionVisible.value
                                              //       ? 1.0
                                              //       : 0.0,
                                              //   duration: animationDuration,
                                              //   child:

                                              Text(
                                            alarmFeed?.action?.toUpperCase() ??
                                                '',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Rowdies',
                                              // decoration:
                                              // TextDecoration.combine([
                                              // TextDecoration.overline,
                                              // TextDecoration.underline
                                              // ]),
                                              decorationColor: Colors.white,
                                              color: Colors.white,
                                              fontSize: 30,
                                            ),
                                          ),
                                          // ),
                                        ),

                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                      ),

                                      if (controller.currentAction ==
                                          ActionItem.smile)
                                        Obx(
                                          () => AnimatedOpacity(
                                            opacity: controller.currentAction ==
                                                    ActionItem.smile
                                                ? 1.0
                                                : 0.0,
                                            duration: animationDuration,
                                            child: CircularPercentIndicator(
                                              radius: 60.0,
                                              lineWidth: 13.0,
                                              circularStrokeCap:
                                                  CircularStrokeCap.round,
                                              animation: true,
                                              animateFromLastPercent: true,
                                              animationDuration: 300,
                                              percent: controller
                                                  .smileProgress.value,
                                              center: Text(
                                                "${(controller.smileProgress * 100).toInt()}%",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.textFieldBorder,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              progressColor:
                                                  AppColors.primaryColor,
                                            ),
                                          ),
                                        ),

                                      //Todo quote
                                      // AnimatedOpacity(
                                      //   opacity: controller.textVisible.value
                                      //       ? 1.0
                                      //       : 0.0,
                                      //   duration: animationDuration,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //         right: 10.0, left: 10),
                                      //     child: Column(
                                      //       children: [
                                      //         SizedBox(
                                      //           height: MediaQuery.of(context)
                                      //                   .size
                                      //                   .height *
                                      //               0.02,
                                      //         ),
                                      //         if (alarmFeed.quote != null &&
                                      //             controller.currentAction !=
                                      //                 ActionItem.repeatPhrase)
                                      //           DefaultTextStyle(
                                      //               style: const TextStyle(
                                      //                 fontSize: 30.0,
                                      //                 fontFamily: 'Bobbers',
                                      //               ),
                                      //               child: AnimatedTextKit(
                                      //                 animatedTexts: [
                                      //                   TyperAnimatedText(
                                      //                     alarmFeed.quote ??
                                      //                         '',
                                      //                     textAlign: TextAlign
                                      //                         .center,
                                      //                   ),
                                      //                 ],
                                      //               )),
                                      //         SizedBox(
                                      //           height: Get.size.height * 0.1,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      // if (alarmFeed?.quote != null &&
                                      //     controller.currentAction !=
                                      //         ActionItem.repeatPhrase
                                      //     && controller.currentAction!=ActionItem.smile && controller.currentAction!=ActionItem.tiltPhone
                                      // )
                                      //   AnimatedBuilder(
                                      //     animation: Listenable.merge([
                                      //       animationController
                                      //           .zoomTextController,
                                      //       animationController
                                      //           .textSlideController
                                      //     ]),
                                      //     builder: (context, child) {
                                      //       return Transform.scale(
                                      //         scale: animationController
                                      //             .zoomTextAnimation
                                      //             .value,
                                      //         child: SlideTransition(
                                      //           position:
                                      //           animationController
                                      //               .textSlideAnimation,
                                      //           child: Center(
                                      //             child: Padding(
                                      //                 padding: isPortrait
                                      //                     ? const EdgeInsets
                                      //                     .symmetric(
                                      //                     horizontal:
                                      //                     100.0)
                                      //                     : const EdgeInsets
                                      //                     .symmetric(
                                      //                     horizontal:
                                      //                     150.0),
                                      //                 child:
                                      //                 Text(alarmFeed
                                      //                     ?.quote ??
                                      //                     '',
                                      //                   textAlign:
                                      //                   TextAlign
                                      //                       .center,style: TextStyle(
                                      //                     shadows: [
                                      //                       Shadow(
                                      //                         offset:
                                      //                         const Offset(
                                      //                             0.0,
                                      //                             3.0),
                                      //                         blurRadius: 2,
                                      //                         color: Colors
                                      //                             .black
                                      //                             .withOpacity(
                                      //                             0.5),
                                      //                       ),
                                      //                     ],
                                      //                     fontSize:
                                      //                     isPortrait
                                      //                         ? 26.0
                                      //                         : 30.0,
                                      //                     fontFamily:
                                      //                     'Rowdies',
                                      //                   ),)
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       );
                                      //     },
                                      //   ),
                                      // if (controller.currentAction ==
                                      //     ActionItem.repeatPhrase)

                                      // if (controller.currentAction !=
                                      //             ActionItem.smile &&
                                      //         controller.currentAction !=
                                      //             ActionItem.tiltPhone
                                      //     // && controller
                                      //     //     .phraseTextVisible.value
                                      //     )
                                      //   AnimatedBuilder(
                                      //     animation: Listenable.merge([
                                      //       animationController
                                      //           .zoomTextController,
                                      //       animationController
                                      //           .textSlideController
                                      //     ]),
                                      //     builder: (context, child) {
                                      //       return Transform.scale(
                                      //         scale: animationController
                                      //             .zoomTextAnimation.value,
                                      //         child: Center(
                                      //           child: Padding(
                                      //               padding: isPortrait
                                      //                   ? const EdgeInsets
                                      //                       .symmetric(
                                      //                       horizontal: 80.0)
                                      //                   : const EdgeInsets
                                      //                       .symmetric(
                                      //                       horizontal:
                                      //                           150.0),
                                      //               child: Text(
                                      //                 alarmFeed?.phrase ?? '',
                                      //                 textAlign:
                                      //                     TextAlign.center,
                                      //                 style: TextStyle(
                                      //                     shadows: [
                                      //                       Shadow(
                                      //                         offset:
                                      //                             const Offset(
                                      //                                 0.0,
                                      //                                 3.0),
                                      //                         blurRadius: 2,
                                      //                         color: Colors
                                      //                             .black
                                      //                             .withOpacity(
                                      //                                 0.5),
                                      //                       ),
                                      //                     ],
                                      //                     fontSize: isPortrait
                                      //                         ? 26.0
                                      //                         : 30.0,
                                      //                     fontFamily:
                                      //                         'Rowdies',
                                      //                     color:
                                      //                         Colors.white),
                                      //               )),
                                      //         ),
                                      //       );
                                      //     },
                                      //   ),

                                      //Todo phrase

                                      // AnimatedOpacity(
                                      //   opacity: controller.actionVisible.value && controller.currentAction ==
                                      //           ActionItem.repeatPhrase
                                      //       ? 1.0
                                      //       : 0.0,
                                      //   duration: animationDuration,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //         left: 10.0, right: 10),
                                      //     child: Text(
                                      //       textAlign: TextAlign.center,
                                      //       alarmFeed.phrase ?? '',
                                      //       style: const TextStyle(
                                      //           fontSize: 28,
                                      //           color: Colors.white,
                                      //           fontWeight: FontWeight.bold),
                                      //     ),
                                      //   ),
                                      // ),

                                      //Todo confetti
                                      if (controller.currentAction != null)
                                        GetBuilder<ReelsController>(
                                            init: controller,
                                            initState: (_) {},
                                            builder: (_) {
                                              return ConfettiWidget(
                                                confettiController: controller
                                                    .confetticontroller,
                                                blastDirectionality:
                                                    BlastDirectionality
                                                        .explosive,
                                                shouldLoop: false,
                                                colors: const [
                                                  Colors.green,
                                                  Colors.blue,
                                                  Colors.pink,
                                                  Colors.orange,
                                                  Colors.purple,
                                                ],
                                              );
                                            }),

                                      //Todo try again button

                                      if (controller.currentAction ==
                                              ActionItem.repeatPhrase &&
                                          controller
                                              .isListeningFailed.isTrue) ...[
                                        Spacer(
                                          flex: isPortrait ? 6 : 10,
                                        ),
                                        CustomButton(
                                          text: "Try Again",
                                          // width: 300.sp,
                                          height: isPortrait ? 40.sp : 20.sp,
                                          width: isPortrait ? 100.sp : 50.sp,
                                          onTap: () {
                                            controller.isListeningFailed
                                                .toggle();
                                            controller.startListening();
                                          },
                                        ),
                                      ],
                                      //Todo smile progress bar

                                      const Spacer(
                                        flex: 10,
                                      ),
                                      //Todo sublimal message
                                      // if (alarmFeed.subliminalMessage != null &&
                                      //     controller.currentAction !=
                                      //         ActionItem.repeatPhrase &&
                                      //     controller.currentReelController !=
                                      //         null)
                                      //   AnimatedOpacity(
                                      //     opacity:
                                      //         controller.subliminalVisible.value
                                      //             ? 1.0
                                      //             : 0.0,
                                      //     duration:
                                      //         const Duration(milliseconds: 500),
                                      //     child: Text(
                                      //       ('${alarmFeed.subliminalMessage?.message} ${alarmFeed.subliminalMessage?.emoji}'),
                                      //       textAlign: TextAlign.center,
                                      //       style: const TextStyle(
                                      //           color: Colors.white,
                                      //           fontWeight: FontWeight.w600,
                                      //           fontSize: 20),
                                      //     ),
                                      //   ),

                                      // const Spacer(
                                      //   flex: 1,
                                      // ),
                                      // _likeDislikeWidgets(controller, context),

                                      if (controller.taskCompleted.value)
                                        AnimatedOpacity(
                                          opacity:
                                              controller.taskCompleted.value
                                                  ? 1.0
                                                  : 0.0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          child: _completeTaskButton(
                                            context,
                                            controller,
                                          ),
                                        ),

                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              top: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? 350
                                  : 150,
                              child: OrientationBuilder(
                                builder: (context, orientation) {
                                  return IconButton(
                                    onPressed: () {
                                      controller.storyController.previous();
                                      print("back button pressed");
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                            // if (controller.currentAction == null)
                            //   newLikeDislike(animationController,
                            //       alarmFeed?.subliminalMessage, context),

                            if (controller.isAlarmPaused.isTrue)
                              userAwayWidget(controller, animationDuration,
                                  alarmTriggerModel, context),
                          ],
                        )
              //     );
              //   },
              // ),
              ),
        );
      },
    );
  }

  Positioned newLikeDislike(animationController, subliminalMessage, context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Positioned.fill(
      child: Column(
        children: [
          SizedBox(
              height: isPortrait
                  ? MediaQuery.of(context).size.height * 0.8
                  : MediaQuery.of(context).size.height * 0.6),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.grey,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                            'You liked this content!'), // Your message here
                        duration: Duration(seconds: 1), // Set the duration
                      ),
                    );
                  },
                  child: SvgPicture.asset('assets/images/like.svg'),
                ),
                SizedBox(
                  width: isPortrait ? 20 : 40,
                ),
                //if (controller.currentAction ==
                //                                                     ActionItem.repeatPhrase &&
                if (subliminalMessage != null)
                  Flexible(
                    child: GetBuilder<DotAnimationController>(
                        init: animationController,
                        builder: (controller) => AnimatedOpacity(
                              opacity: controller.animationController.status ==
                                      AnimationStatus.forward
                                  ? 1.0
                                  : 0.0,
                              duration: const Duration(milliseconds: 2000),
                              child: Text(
                                ('${subliminalMessage?.message} ${subliminalMessage?.emoji}'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Rowdies',
                                    color: Colors.white,
                                    fontSize: isPortrait ? 20 : 25),
                              ),
                            )),
                  ),
                SizedBox(
                  width: isPortrait ? 20 : 40,
                ),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.grey,
                        behavior: SnackBarBehavior.floating,
                        content: Text('You disliked this content!'),
                        duration: Duration(seconds: 1), // Set the duration
                      ),
                    );
                  },
                  child: SvgPicture.asset('assets/images/dislike.svg'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget headerWidget(AlarmTriggerViewModel alarmTriggerModel) {
    return const ReelHeaderWidget();
  }

  userAwayWidget(ReelsController controller, Duration animationDuration,
      AlarmTriggerViewModel alarmTriggerModel, BuildContext context) {
    return Obx(() => AnimatedOpacity(
        opacity: controller.isAlarmPaused.isTrue ? 1.0 : 0.0,
        duration: animationDuration,
        child: !alarmTriggerModel.bothEyesOpen.value
            ? Container(
                color: Colors.black.withOpacity(0.7),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.only(top: 210.0, left: 20, right: 20),
                  child: ColorFiltered(
                    colorFilter:
                        ColorFilter.mode(Colors.black, BlendMode.lighten),
                    child: Text(
                      "Seems like you have slept again. Please look at the camera again to continue the feed",
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            : null));
  }

  Padding _completeTaskButton(
      BuildContext context, ReelsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          DialogUtils.historyCompleteDialog(context);
          controller.checkRetriggerAlarm();
          final alarmTriggerModel = Get.find<AlarmTriggerViewModel>();
          alarmTriggerModel.stopLiveFeed();
          alarmTriggerModel.onClose();
          controller.onClose();
        },
        child: Container(
          height: 40,
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: const Color(0xff6B46F6),
            // border: Border.all(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/images/Frame (4).svg"),
              const SizedBox(width: 2),
              const Text(
                "Complete Task",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _likeDislikeWidgets(ReelsController controller, BuildContext context) {
  //   return AnimatedOpacity(
  //     opacity: controller.likedislikeVisible.value ? 1.0 : 0.0,
  //     duration: const Duration(milliseconds: 700),
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             height: 40,
  //             width: 120,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(30),
  //               color: Colors.transparent,
  //               border: Border.all(
  //                 color: Colors.white,
  //               ),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 20.0, top: 8),
  //                   child: SvgPicture.asset(
  //                     "assets/images/Frame (2).svg",
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   width: 2,
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         backgroundColor: Colors.grey,
  //                         behavior: SnackBarBehavior.floating,
  //                         content: Text('You disliked this content!'),
  //                         // Your message here
  //                         duration: Duration(seconds: 1), // Set the duration
  //                       ),
  //                     );
  //                   },
  //                   child: const Padding(
  //                     padding: EdgeInsets.only(right: 20.0, left: 8),
  //                     child: Text(
  //                       "Dislike",
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //           const SizedBox(
  //             width: 20,
  //           ),
  //           Container(
  //             height: 40,
  //             width: 120,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(30),
  //               color: const Color(0xff6B46F6),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(
  //                     left: 20.0,
  //                   ),
  //                   child: SvgPicture.asset(
  //                     "assets/images/Frame (3).svg",
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   width: 2,
  //                 ),
  //                 InkWell(
  //                   onTap: () {
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         backgroundColor: Colors.grey,
  //                         behavior: SnackBarBehavior.floating,
  //                         content: Text(
  //                             'You liked this content!'), // Your message here
  //                         duration: Duration(seconds: 1), // Set the duration
  //                       ),
  //                     );

  //                     // Handle like action
  //                   },
  //                   child: const Padding(
  //                     padding: EdgeInsets.only(right: 20.0, left: 8),
  //                     child: Text(
  //                       "Like",
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _backgroundImage(String imagePath) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black
            .withOpacity(0.4), // Adjust opacity and color to control dullness
        BlendMode.darken,
      ),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imagePath,
        // _controller.stories[_controller.currentIndex.value].image,
        height: Get.size.height,
        width: Get.size.width,
        useOldImageOnUrlChange: true,
        // colorBlendMode: BlendMode.srcATop,
        placeholder: (context, url) => const CustomLoaderWidget(
          isTrue: true,
          child: ColoredBox(color: Colors.black),
        ),
        // errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}

class ReelHeaderWidget extends StatefulWidget {
  const ReelHeaderWidget({
    super.key,
  });

  @override
  State<ReelHeaderWidget> createState() => _ReelHeaderWidgetState();
}

class _ReelHeaderWidgetState extends State<ReelHeaderWidget>
    with FlareController {
  //ANIMATION RELATED
  String animationName = 'Quiet';
  double _lerpSpeed = 0.33;

  late FlareAnimationLayer _leftEyeAnim;
  late FlareAnimationLayer _rightEyeAnim;
  late FlareAnimationLayer _smileAnim;

  @override
  void initialize(FlutterActorArtboard artboard) {
    _leftEyeAnim =
        FlareAnimationLayer("LeftEye", artboard.getAnimation("LeftEye")!)
          ..mix = 1.0;
    _rightEyeAnim =
        FlareAnimationLayer("RightEye", artboard.getAnimation("RightEye")!)
          ..mix = 1.0;
    _smileAnim = FlareAnimationLayer("Smile", artboard.getAnimation("Smile")!)
      ..mix = 1.0;
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    final alarmTriggerModel = Get.find<AlarmTriggerViewModel>();
    // if (face != null) {
    // _leftEyeAnim.time =
    //     lerpDouble(_leftEyeAnim.time, lastLeftEye, _lerpSpeed);
    // _rightEyeAnim.time =
    //     lerpDouble(_rightEyeAnim.time, lastRightEye, _lerpSpeed);
    _leftEyeAnim.time = lerpDouble(
        _leftEyeAnim.time, alarmTriggerModel.leftBlinked ? 0 : 1, _lerpSpeed)!;
    _rightEyeAnim.time = lerpDouble(_rightEyeAnim.time,
        alarmTriggerModel.rightBlinked ? 0 : 1, _lerpSpeed)!;
    _smileAnim.time = lerpDouble(_smileAnim.time,
        alarmTriggerModel.smileDetected.value ? 1 : 0, _lerpSpeed)!;
    _leftEyeAnim.apply(artboard);
    _rightEyeAnim.apply(artboard);
    _smileAnim.apply(artboard);
    // }
    return true;
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  bool isAnimationRunning = false;
  StreamSubscription<bool>? detectedListener;

  @override
  void initState() {
    super.initState();
    // final alarmTriggerModel = Get.find<AlarmTriggerViewModel>();
    //
    // detectedListener = alarmTriggerModel.smileDetected.listen((detected) {
    //   if (detected && animationName == 'Smile') {
    //     return;
    //   }
    //   if (!detected && animationName == 'Quiet') {
    //     return;
    //   }
    //   if (isAnimationRunning) {
    //     return;
    //   }
    //   isAnimationRunning = true;
    //   setState(() {
    //     if (detected) {
    //       animationName = 'Smile';
    //     } else {
    //       animationName = 'Quiet';
    //     }
    //   });
    //   Future.delayed(const Duration(milliseconds: 1200), () {
    //     isAnimationRunning = false;
    //   });
    // });
  }

  @override
  void dispose() {
    // detectedListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: FlareActor(
                  'assets/animation/SleepToSmile.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.fitWidth,
                  // controller: alarmTriggerModel.flareController, //Flare Controller
                  animation: 'Quite',
                  snapToEnd: true,
                  // animation: 'Quiet',
                  controller: this,
                  //isPaused: true,//faceDetectorController.paused.value,
                ),
              ),

              const SizedBox(
                width: 10,
              ),
              // alarmTriggerModel.eyeBlinked.value

              const Text(
                "Wake Up Alarm",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17),
              )
            ],
          ),
        ],
      ),
    );
  }
}
