import 'package:awakn/utils/app_colors.dart';
import 'package:awakn/utils/global.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/alarm_trigger/alarm_trigger_view_model.dart';
import 'package:awakn/widgets/shimmer_arrows.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'camera_view.dart';
import 'package:flutter/material.dart';

class FaceDetectorView extends StatefulWidget {
  const FaceDetectorView({required this.model, super.key});

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState(model);

  final AlarmTriggerViewModel model;
}

class _FaceDetectorViewState extends State<FaceDetectorView>
    with SingleTickerProviderStateMixin {
  _FaceDetectorViewState(AlarmTriggerViewModel model) {
    alarmTriggerModel = model;
  }
  late AlarmTriggerViewModel alarmTriggerModel;
  late AnimationController _controller;
  late Animation<double> _animation;

  // final alarmTriggerModel = Get.put(AlarmTriggerViewModel());

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 200, end: 240).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Easing.emphasizedAccelerate,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    // _canProcess = false;
    // _faceDetector.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<AlarmTriggerViewModel>(
      init: alarmTriggerModel,
      initState: (_) {
        Future.delayed(
            const Duration(
              milliseconds: 500,
            ), () {
          if (alarmTriggerModel.isWakeUpAlarm.isTrue) {
            alarmTriggerModel.bothEyesBlinked.listen((value) {
              if (value) {
                alarmTriggerModel.startReels();
              }
            });
          }
        });
      },
      builder: (_) {
        DateTime selectedTime = DateTime.now(); // Example selected time

        return Scaffold(
          body: GestureDetector(
            onVerticalDragUpdate: alarmTriggerModel.isWakeUpAlarm.value
                ? (_) {}
                : (details) {
                    int sensitivity = 8;
                    if (details.delta.dy > sensitivity) {
                      // Down Swipe
                    } else if (details.delta.dy < -sensitivity) {
                      alarmTriggerModel.startReels();
                      // Up Swipe
                    }
                  },
            child: Stack(
              children: [
                const CameraView(),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          // "assets/images/1.png",
                          alarmTriggerModel.daytime.backgroundImage),
                    ),
                  ),
                  height: size.height,
                  width: size.width,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 200),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: [
                              Text(
                                alarmTriggerModel.daytime.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white),
                              ),
                              Text(
                                '${globalCache.userProfile?.fullName}!',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 550,
                        left: 40,
                        right: 40,
                        child: SizedBox(
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  // 'Its bright shiny morning waiting for you to get up and enjoy.',
                                  alarmTriggerModel.daytime.narrative,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                // ElevatedButton(

                      //if (subliminalMessage != null )

                                //   onPressed: () {
                                //     alarmTriggerModel.startReels();
                                //     // Get.to(StoriesPage());
                                //   },
                                //   child: Text("Start Reels",
                                //       style: TextStyle(
                                //           fontWeight: FontWeight.w600,
                                //           fontSize: 16,
                                //           color: Theme.of(context).brightness ==
                                //                   Brightness.light
                                //               ? const Color(0xff302B4a)
                                //               : null)),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Container(
                              width: _animation.value,
                              height: _animation.value,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white38),
                                shape: BoxShape.circle,
                                color: Colors.white10,
                              ),
                            );
                          },
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 165,
                          width: 165,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                fit: BoxFit.fill,
                                image:
                                    AssetImage("assets/images/Subtract.png")),
                            borderRadius: BorderRadius.circular(90),
                            // color: Colors.yellow
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80),
                            color: const Color(0xff171132),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.jm()
                                    .format(selectedTime)
                                    .toLowerCase(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  alarmTriggerModel.isWakeUpAlarm.value
                                      ? 'Wake up'
                                      : 'Excercise now',
                                  style: const TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: alarmTriggerModel.isWakeUpAlarm.value
                              ? [
                                  // Show the message if both eyes have blinked
                                  alarmTriggerModel.bothEyesBlinked.value
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: const Color(0xff424753),
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          height: 30,
                                          width: 140,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color: Color(0xff28D624),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                'Eye Detected',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const Text(
                                          "Please Blink your eyes",
                                          style: TextStyle(color: Colors.white),
                                        ), // Don't show anything if both eyes haven't blinked
                                  const SizedBox(height: 50),
                                ]
                              : [
                                  const Text('Swipe up to notify',
                                      style: TextStyle(color: Colors.white)),
                                  const SizedBox(height: 10),
                                  Container(
                                      height: 40,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50),
                                        ),
                                        color: AppColors.primaryColor,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: ShimmerArrows(),
                                      )),
                                ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
