import 'dart:async';
import 'dart:developer';
import 'package:alarm/alarm.dart';
import 'package:awakn/models/alarm_feed_response.dart';
import 'package:awakn/models/alarm_response.dart';
import 'package:awakn/services/alarm_service.dart';
import 'package:awakn/utils/global.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/alarm_trigger/action_helpers/phone_rotator_helper.dart';
import 'package:awakn/views/alarm_trigger/action_helpers/phrase_repeater_helper.dart';
import 'package:awakn/views/alarm_trigger/action_helpers/smile_detector_helper.dart';
import 'package:awakn/views/alarm_trigger/alarm_trigger_view_model.dart';
import 'package:awakn/views/alarm_trigger/reels/reel_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

class ReelsController extends GetxController with GetTickerProviderStateMixin {
  // late final AnimationController animationController;
  AlarmObject? alarm;
  final phraseVisibilityTime = 2;
  final likedislikeVisibilityTime = 2;

  ActionItem? currentAction;

  // AnimationController? currentReelController;
  StoryController storyController = StoryController();

  // Get the current time of the reel
  RxDouble currentTime = 0.0.obs;

  // Action progress
  RxDouble smileProgress = 0.0.obs;
  Timer? actionTimer;

  // Set a fraction between 0 and 1, which indicates the degree of similarity
  // between the two strings.
  // 0 indicates completely different strings,
  // 1 indicates identical strings. T
  // he comparison is case and diacritic sensitive.
  final similarityPercentage = 0.6;
  late ConfettiController confetticontroller;

  // RxList<Story> stories = <Story>[].obs;
  RxInt currentIndex = 0.obs;

  // RxInt timerSeconds = 5.obs;
  RxBool isLoading = false.obs;
  RxBool isListeningFailed = false.obs;
  RxBool taskCompleted = false.obs;
  RxBool isAlarmPaused = false.obs;

  RxList<AlarmFeed> userAlarmsList = RxList<AlarmFeed>();
  RxList<StoryItem> storyList = RxList<StoryItem>();

  // AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();
  final reelStoryPlayer = AudioPlayer();
  final player2 = AudioPlayer();

  late PhraseRepeater phraseRepeater;
  late PhoneRotator _phoneRotator;
  late SmileDetector _smileDetector;

  final SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false;
  AnimationController? currentReelController;

  // RxBool phraseTextVisible = true.obs;
  // RxBool likedislikeVisible = false.obs;
  // RxBool actionVisible = false.obs;
  RxBool subliminalVisible = false.obs;

  double get getReadabilityTime {
    double defaultTime = 20;
    if (userAlarmsList.isNotEmpty) {
      defaultTime =
          userAlarmsList[currentIndex.value].readabilityTime ?? defaultTime;
    }
    return defaultTime;
  }

  double get getQuoteTime => (getReadabilityTime * 1.5) / 2;

  double get getLikeDislikeShowTime => 2;

  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    confetticontroller =
        ConfettiController(duration: const Duration(seconds: 3));

    _speechToText
        .initialize(onError: (error) => isListeningFailed(true))
        .then((value) {
      speechEnabled = value;
    });

    phraseRepeater = PhraseRepeater(
      speechToText: _speechToText,
      onPhraseDetected: (phrase) {
        _startCelebration();
        // player.play();

        // changePage();
      },
      onListeningFailed: () {
        isListeningFailed(true);
      },
      similarityPercentage: similarityPercentage,
    );

    _phoneRotator = PhoneRotator(onRotationDetected: () {
      _startCelebration();
      // changePage();
    });

    _smileDetector = SmileDetector(
        smileProgress: smileProgress,
        onSmileDetected: () {
          _startCelebration(completed: () {
            smileProgress.value = 0;
          });
          // changePage();
        });

    super.onInit();
  }

  startListening() {
    final alarm = userAlarmsList[currentIndex.value];
    final targetPhrase = alarm.phrase ?? alarm.quote ?? '';
    // if (player.playing) {
    //   player.stop();
    // }
    phraseRepeater.startListening(targetPhrase);
  }

  Future<bool> getAlarmData() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      isLoading.value = true;
      final response = await AlarmService().getAlarmFeedList(
        alarm?.objectiveId! ??
            [
              // '65dcca99f81a836542b4d470',
              '65dcdb09f81a836542b4d7c0'
            ],
      );
      if (response.isNotEmpty) {
        userAlarmsList(response);
        var storyItemId = 0;
        storyList(response.map(
          (alarmFeed) {
            if (kDebugMode) {
              print(alarmFeed.toJson().toString());
            }
            return StoryItem(
              ReelItem(
                key: ValueKey(storyItemId++),
                actionItem: getCurrentActionEnum(alarmFeed.action),
                imageUrl: alarmFeed.image!,
                quote: alarmFeed.quote,
                phrase: alarmFeed.phrase,
                readabilityTime: alarmFeed.readabilityTime,
                sound: alarmFeed.sound,
                subliminalMessage: alarmFeed.subliminalMessage,
                smileDetected: Get.find<AlarmTriggerViewModel>().smileDetected,
                isAlarmPaused: isAlarmPaused,
                pauseStory: () {
                  if (kDebugMode) {
                    print("Pause Story");
                  }
                  storyController.pause();
                },
                resumeStory: () {
                  storyController.previous();
                },
                nextStory: () {
                  if (kDebugMode) {
                    print("Next Story");
                  }
                  storyController.next();
                },
                playMusic: () {
                  if (!reelStoryPlayer.playing) {
                    reelStoryPlayer.play();
                  }
                },
                pauseMusic: () {
                  reelStoryPlayer.pause();
                },
                setMusicVolume: (volumeValue) {
                  reelStoryPlayer.setVolume(volumeValue);
                },
              ),
              duration: Duration(seconds: alarmFeed.readabilityTime!.toInt()),
            );
          },
          // StoryItem.pageImage(
          //   url: alarmFeed.image!,
          //   controller: storyController,
          //   // backgroundColor: Colors.black..withOpacity(0.8),
          //   // title: '',
          //   imageFit: BoxFit.cover,
          //   duration:
          //       Duration(seconds: alarmFeed.readabilityTime!.toInt() + 5),
          //   loadingWidget: const CircularProgressIndicator(),
          // ),
        ).toList());
        // initiateReels();
      }

      isLoading.value = false;
      return true;
    } catch (error) {
      isLoading.value = false;

      debugPrint(error.toString());
      return false;
    }
  }

  checkRetriggerAlarm() {
    try {
      final box = GetStorage();
      final alarmId = Helper().getAlarmId(alarm!.sId!);
      final existing = box.read(alarmId.toString());
      if ((alarm!.interval!.isNotEmpty || alarm!.repeat!) && alarm != null) {
        if (existing != null && existing != alarm!.sId) {
          box.write(alarmId.toString(), alarm!.sId);
        }
        Alarm.set(
            alarmSettings: buildAlarmSettings(
          alarmId,
          alarm!,
          isRepeat: true,
        )).then((res) {
          log('alarm add success: $res');
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _startCelebration({VoidCallback? completed}) {
    // storyController.play();
    confetticontroller.play();
    Future.delayed(const Duration(seconds: 3), () {
      confetticontroller.stop();
      completed?.call();
      // storyController.next();
      // if (storyController.playbackNotifier.value == PlaybackState.pause) {
      //   storyController.play();
      // }
    });
  }

  @override
  void onClose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   // DeviceOrientation.portraitDown,
    // ]);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    storyController.dispose();

    confetticontroller.dispose();

    // audioPlayer.stop();
    // player.stop();
    // player.dispose();
    player2.stop();
    player2.dispose();
    reelStoryPlayer.stop();
    reelStoryPlayer.dispose();

    // currentReelController?.dispose();
    actionTimer?.cancel(); // Cancel the action timer to avoid memory leaks

    // stopSensing();
    super.onClose();
  }

  Future<void> handleChangeStory() async {
    try {
      // player.setVolume(0.1);
      //
      // // Define the total duration for increasing the volume
      // const int volumeIncreaseDuration = 10; // Total duration in seconds to reach the target volume
      // const int volumeStepDuration = 800; // Duration of each step in milliseconds
      // const double targetVolume = 1; // Target volume level
      // double volumeStep = targetVolume / (volumeIncreaseDuration * 1000 / volumeStepDuration);
      //
      // Timer.periodic(Duration(milliseconds: volumeStepDuration), (Timer t) {
      //   if (player.volume < targetVolume) {
      //     player.setVolume((player.volume + volumeStep).clamp(0.0, targetVolume));
      //   } else {
      //     player.setVolume(targetVolume); // Ensure the final volume is set exactly to the target
      //     t.cancel(); // Stop the timer
      //   }
      // });
      //
      // Future.delayed(
      //   Duration(seconds: phraseVisibilityTime),
      //       () {
      //     player.setVolume(1);
      //   },
      // );

//  player.setVolume(0.0);
//
//       // Define the duration over which to increase the volume
//       const int volumeIncreaseDuration = 3; // in seconds
//       const double volumeStep = 0.1; // the step by which to increase volume
//       // int volumeSteps = (volumeIncreaseDuration / 0.3).ceil(); // Calculate the number of steps needed
//
//       Timer.periodic(const Duration(milliseconds: 300), (Timer t) {
//         if (player.volume < 0.5) {
//           player.setVolume(player.volume + volumeStep);
//         } else {
//           player.setVolume(0.5); // Set to final volume
//           t.cancel(); // Stop the timer
//         }
//       });

      // player.setVolume(0.5);

      Future.delayed(
        Duration(
          seconds: phraseVisibilityTime,
        ),
        () {
          // player.setVolume(1);
        },
      );
      // checkMusic();
      // handleLikeDislike();
      log("Current Index on start: ${currentIndex.value}");
      int storyTime = getReadabilityTime.toInt();

      // TODO(Junaid): check currentReelController
      // probability to handle each timer
      // if (currentReelController != null) {
      //   currentReelController!.dispose();
      // }
      // currentReelController = AnimationController(
      //   vsync: this,
      //   duration: Duration(seconds: storyTime), // Set the reel window duration
      // );
      Timer? timer;
      timer = Timer.periodic(const Duration(milliseconds: 300), (Timer t) {
        // setState(() {
        if (currentTime.value < storyTime) {
          currentTime.value += 0.3;

          // log('Subliminal Value: t ${currentTime.value.toString()}');
          shouldShowText();
        } else {
          currentTime(0.0);
          shouldShowText();
          // Story completed, you can stop the timer or perform any other action
          timer?.cancel();
        }
        // update();
        // });
      });

      // currentReelController!.forward(); // Start the animation

      // currentTime.value = currentReelController!.value.floor() % storyTime;

      // log('Subliminal Value: ${currentTime.value.toString()}');

      final actionFunctionAvailable = checkAction();
      if (actionFunctionAvailable)
      // Delay for 1 second before starting the animation for the first story
      {
        // Future.delayed(
        //   const Duration(
        //     seconds: 1,
        //   ),
        //   () => storyController.pause(),
        // );
      }
    } catch (e) {
      log(e.toString());
    }
  }

  initiateReels() async {
    // SystemChrome.setPreferredOrientations([
    //   // DeviceOrientation.portraitUp,
    //   // DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   // DeviceOrientation.landscapeRight,
    // ]);
    handleChangeStory();
    checkMusic();

    // final url = alarm?.tune?.url ??
    //     'https://awakn.s3.us-east-2.amazonaws.com/tunes/chime.mp3';
    // await player.setSource(AssetSource(Helper.backgroundTunePath('galaxy')));
    // await player.setSource(UrlSource(url));
    // await player.play(UrlSource(url), volume: 1, mode: PlayerMode.lowLatency);

    double eyeStopProgress = 0;
    Timer? eyeTimer;

    final eyesStream = Get.find<AlarmTriggerViewModel>().bothEyesOpen;
    eyesStream.listen((value) {
      if (!value) {
        eyeTimer = Timer.periodic(const Duration(milliseconds: 150), (Timer t) {
          log('Eyes Stop Progress: $eyeStopProgress');
          //TODO(Junaid): Eyestop needs to be reviewed
          if (eyeStopProgress >= 3 && taskCompleted.isFalse) {
            log('Eyes Stop');
            // currentReelController!.stop();
            // currentReelController!.reset();
            // if (currentAction == null) {
            //   storyController.pause();
            // }
            isAlarmPaused(true);

            // player.stop();
            playLoudMusic();

            eyeStopProgress = 0;
            eyeTimer?.cancel(); // Stop the timer after condition met
          } else {
            eyeStopProgress += 0.05;
          }
        });
      } else {
        if (isAlarmPaused.isTrue) {
          // if (currentAction == null) {
          //   storyController.play();
          // } else if (currentAction != ActionItem.repeatPhrase) {
          //   player.play();
          // }
          player2.stop();
          // currentReelController!.forward();
          isAlarmPaused(false);
        }
        // Reset progress when eyes are open
        eyeStopProgress = 0;
        // Check if timer is active before cancelling
        eyeTimer?.cancel();
        // player.play();
      }
    });
  }

  bool checkAction() {
    final action = userAlarmsList[currentIndex.value].action;
    currentAction = getCurrentActionEnum(action);
    if (action != null && currentAction != null) {
      switch (currentAction) {
        case ActionItem.smile:
          Future.delayed(
              const Duration(
                seconds: 1,
              ),
              () => _smileDetector.startDetection());
          // _smileDetector.startDetection();
          return true;
        case ActionItem.repeatPhrase:
          Future.delayed(
              const Duration(
                seconds: 1,
              ),
              () => startListening());
          // startListening();
          return true;
        case ActionItem.tiltPhone:
          Future.delayed(
              const Duration(
                seconds: 1,
              ),
              () => _phoneRotator.startSensing());
          // _phoneRotator.startSensing();
          return true;
        case null:
          return false;
      }
    }
    return false;
  }

  shouldShowText() {
    double firstShowTime = getReadabilityTime / 3;
    double secondShowTime = getReadabilityTime * 2 / 3;

    final value = currentTime.value >= firstShowTime &&
            currentTime.value < firstShowTime + 1 ||
        currentTime.value >= secondShowTime &&
            currentTime.value < secondShowTime + 1;
    // log('Subliminal Value: $value');
    if (value != subliminalVisible.value) {
      subliminalVisible(value);
    }
  }

  Future<void> checkMusic() async {
    // if (isAlarmPaused.isTrue) {
    //   return;
    // }
    // if (player.playing) {
    //   player.stop();
    // }
    // final url = userAlarmsList[currentIndex.value].sound ??
    //     'https://awakn.s3.us-east-2.amazonaws.com/tunes/chime.mp3';
    // await player.setSource(AssetSource(Helper.backgroundTunePath('galaxy')));
    // await player.setSource(UrlSource(url));
    // await player.play(UrlSource(url), volume: 1, mode: PlayerMode.lowLatency);

    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      //  await player2.setAudioSource(
      //   AudioSource.asset(tunesMap[alarm?.tune?.name ?? 'Galaxy']!));
      // await player.setAudioSource(AudioSource.asset(
      //     Helper.backgroundTunePath(alarm?.tune?.url ?? 'galaxy')));
      // await player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      // await player.setAudioSource(AudioSource.uri(Uri.parse(alarm?.tune?.url ??
      //     'https://awakn.s3.us-east-2.amazonaws.com/tunes/chime.mp3')));
      //
      await reelStoryPlayer.setAudioSource(AudioSource.uri(Uri.parse(
          alarm?.tune?.url ??
              'https://awakn.s3.us-east-2.amazonaws.com/tunes/chime.mp3')));

      reelStoryPlayer.setLoopMode(LoopMode.all);
      reelStoryPlayer.setVolume(0.5);
      reelStoryPlayer.play();
    } catch (e) {
      debugPrint("Error loading audio source: $e");
    }
  }

  playLoudMusic() async {
    if (!player2.playing) {
      try {
        // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
        await player2.setAudioSource(AudioSource.asset(tunesMap[
            // alarm?.tune?.name ??
            'Galaxy']!));
        player2.setLoopMode(LoopMode.all);
        player2.setVolume(1);
        player2.play();
      } catch (e) {
        debugPrint("Error loading audio source: $e");
      }
    }
  }
}
