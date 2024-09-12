import 'dart:async';
import 'dart:math';

import 'package:awakn/models/alarm_feed_response.dart';
import 'package:awakn/utils/app_colors.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/alarm_trigger/action_helpers/phone_rotator_helper.dart';
import 'package:awakn/views/alarm_trigger/action_helpers/phrase_repeater_helper.dart';
import 'package:awakn/views/alarm_trigger/reels/TextAnimationsList.dart';
import 'package:awakn/widgets/custom_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class ReelItem extends StatefulWidget {
  final String imageUrl;
  final String? phrase;
  final String? quote;
  final String? sound;
  final SubliminalMessage? subliminalMessage;
  final double? readabilityTime;
  final ActionItem? actionItem;
  final VoidCallback pauseStory;
  final VoidCallback resumeStory;
  final VoidCallback nextStory;
  final RxBool smileDetected;
  final RxBool isAlarmPaused;
  final VoidCallback playMusic;
  final VoidCallback pauseMusic;
  final Function(double) setMusicVolume;

  const ReelItem({
    required this.imageUrl,
    required this.phrase,
    required this.quote,
    required this.sound,
    required this.subliminalMessage,
    required this.readabilityTime,
    required this.actionItem,
    required this.pauseStory,
    required this.resumeStory,
    required this.nextStory,
    required this.smileDetected,
    required this.isAlarmPaused,
    required this.playMusic,
    required this.pauseMusic,
    required this.setMusicVolume,
    super.key,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  double smileValue = 0.0;
  bool oldSmileValue = false;
  bool smileCompleted = false;
  StreamSubscription? _smileStreamSubs;

  StreamSubscription? _isAlarmPausedStreamSubs;

  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 3));

  bool phraseCompleted = false;

  final _settingsList = TextAnimationsList().getAnimationList();
  final Random _random = Random();

  int randomQuoteTextIndex = 0;
  int randomSubliminalTextIndex = 0;
  int randomBgColorIndex = 0;

  late String phraseText = widget.phrase ?? "";

  final List<Color> bgColors = [
    // Colors.blue.withOpacity(0.9),
    // Colors.deepPurple.withOpacity(0.9),
    Colors.black45,
    const Color(0x55555555),
  ];

  final similarityPercentage = 0.6;

  final SpeechToText _speechToText = SpeechToText();
  late PhraseRepeater _phraseRepeater;
  late PhoneRotator _phoneRotator;

  Timer? smileTimer;
  Timer? phraseListenerTimer;
  Timer? fadeInVolumeTimer;
  Timer? fadeOutVolumeTimer;

  bool isListeningFailed = false;

  final _player = AudioPlayer();
  double _playerVolume = 0.5;

  bool? isLike;

  @override
  void initState() {
    super.initState();

    randomQuoteTextIndex = _random.nextInt(_settingsList.length);
    randomSubliminalTextIndex = _random.nextInt(_settingsList.length);
    randomBgColorIndex = _random.nextInt(bgColors.length);

    // for outgoing text animation in phrase will be triggered
    if (widget.actionItem != ActionItem.repeatPhrase) {
      Future.delayed(
        Duration(
          milliseconds:
              ((((widget.readabilityTime ?? 1) * 1000) / 24) * 19).toInt(),
        ),
        () {
          if (!mounted) return;

          fadeOutVolumeTimer = Timer.periodic(
            const Duration(milliseconds: 200),
            (timer) {
              if (fadeInVolumeTimer?.isActive == true) {
                timer.cancel();
                return;
              }
              _playerVolume = max(_playerVolume - 0.1, 0.5);
              widget.setMusicVolume(_playerVolume);

              if (_playerVolume <= 0.5) {
                timer.cancel();
              }
            },
          );
          setState(() {
            phraseText = "";
          });
        },
      );
      _playMusic();
    } else {
      widget.pauseMusic();
      // if (_player.playing) {
      //   _player.stop();
      // }
    }

    _isAlarmPausedStreamSubs = widget.isAlarmPaused.listen((value) async {
      if (!value) {
        widget.playMusic();
        if (widget.actionItem == null) {
          widget.resumeStory();
        } else {
          _listenActionItems();
        }
        if (widget.actionItem != ActionItem.repeatPhrase) {
          // await _player.play();
        } else {
          if (_player.playing) {
            widget.setMusicVolume(_playerVolume);
            // await _player.stop();
          }
        }
      } else {
        _stopListenActionItems();
        // _player.pause();
        widget.pauseMusic();
        widget.pauseStory();
      }
    });

    if (widget.actionItem != null) {
      widget.pauseStory();

      _listenActionItems();
    }
  }

  _listenActionItems() {
    switch (widget.actionItem!) {
      case ActionItem.smile:
        _startSmileDetection();
        break;
      case ActionItem.tiltPhone:
        _phoneRotator = PhoneRotator(onRotationDetected: () {
          _startCelebration();
        });
        _phoneRotator.startSensing();
        break;
      case ActionItem.repeatPhrase:
        _phraseRepeater = PhraseRepeater(
          speechToText: _speechToText,
          onPhraseDetected: (phrase) {
            phraseCompleted = true;
            _startCelebration();
          },
          onListeningFailed: () {
            setState(() {
              isListeningFailed = true;
            });
          },
          similarityPercentage: similarityPercentage,
        );
        _startPhraseListening();
        break;
    }
  }

  _stopListenActionItems() {
    if (widget.actionItem == null) return;

    switch (widget.actionItem!) {
      case ActionItem.smile:
        _stopSmileDetection();
        break;
      case ActionItem.tiltPhone:
        _phoneRotator.stopSensing();
        break;
      case ActionItem.repeatPhrase:
        _phraseRepeater.stopListening();
        break;
    }
  }

  _startSmileDetection() {
    smileTimer?.cancel();

    smileTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (widget.smileDetected.value) {
        smileValue += 0.01;

        setState(() {
          smileValue = min(1, smileValue);
        });

        if (smileValue >= 1) {
          smileCompleted = true;

          smileTimer?.cancel();

          _smileStreamSubs?.cancel();

          _startCelebration();
        }
      } else {
        smileValue -= 0.01;

        setState(() {
          smileValue = max(0, smileValue);
        });
      }
    });
  }

  _stopSmileDetection() {
    _smileStreamSubs?.cancel();
  }

  _playMusic() async {
    try {
      // await _player.setAudioSource(
      //   AudioSource.uri(
      //     Uri.parse(widget.sound ??
      //         'https://awakn.s3.us-east-2.amazonaws.com/tunes/chime.mp3'),
      //   ),
      // );
      //
      // await _player.setLoopMode(LoopMode.off);
      // await _player.setVolume(1);
      // await _player.play();
      widget.playMusic();
      fadeInVolumeTimer = Timer.periodic(
        const Duration(milliseconds: 300),
        (timer) {
          _playerVolume = min(_playerVolume + 0.1, 1.0);
          widget.setMusicVolume(_playerVolume);

          if (_playerVolume >= 1.0) {
            timer.cancel();
          }
        },
      );
    } catch (e) {
      debugPrint("Error loading audio source: $e");
    }
  }

  _startCelebration() {
    if (_confettiController.state == ConfettiControllerState.playing) {
      return;
    }
    _confettiController.play();

    _confettiController.addListener(confettiListener);
  }

  void confettiListener() {
    if (_confettiController.state == ConfettiControllerState.stopped) {
      widget.nextStory();
      _confettiController.removeListener(confettiListener);
    }
  }

  _startPhraseListening() {
    setState(() {
      isListeningFailed = false;
    });
    phraseListenerTimer?.cancel();
    phraseListenerTimer = Timer(const Duration(seconds: 10), () {
      if (phraseCompleted) {
        return;
      }
      if (isListeningFailed) {
        return;
      }
      _phraseRepeater.stopListening();
      setState(() {
        isListeningFailed = true;
      });
    });
    _phraseRepeater.startListening(widget.phrase ?? '');
  }

  void _stopAll() {
    _isAlarmPausedStreamSubs?.cancel();
    _smileStreamSubs?.cancel();
    smileTimer?.cancel();
    fadeOutVolumeTimer?.cancel();
    fadeInVolumeTimer?.cancel();
    _stopListenActionItems();
  }

  @override
  void dispose() {
    _stopAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue[200]!,
                Colors.purple[200]!,
                Colors.orange[200]!,
              ],
            ),
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
              ).animate().scaleXY(
                    duration: Duration(
                      seconds: widget.readabilityTime?.toInt() ?? 1,
                    ),
                    begin: 1,
                    end: 1.3,
                    curve: Curves.easeInOut,
                  ),
            ),
          ],
        ),

        Container(
          decoration: BoxDecoration(
            color: bgColors[randomBgColorIndex],
          ),
        ),
        // .animate().slide(
        //   duration: const Duration(milliseconds: 600),
        //   begin: Offset(isPortrait ? -1 : 0, isPortrait ? 0 : -1),
        //   end: Offset(isPortrait ? 0 : 0, isPortrait ? 0 : 0),
        //   curve: Curves.ease,
        // ),
        if (widget.actionItem != null)
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: isPortrait ? 80 : 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.actionItem == ActionItem.smile
                        ? "Smile"
                        : widget.actionItem == ActionItem.repeatPhrase
                            ? "Repeat the phrase"
                            : "Tilt the phone",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decorationColor: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

        Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   widget.quote ?? '',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     shadows: const [
                  //       Shadow(
                  //         offset: Offset(0.0, 4),
                  //         blurRadius: 4,
                  //         color: Color(0x33AAAAAA),
                  //       ),
                  //     ],
                  //     fontSize: isPortrait ? 28.0 : 30.0,
                  //     fontFamily: 'Poppins',
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //   ),
                  // ),

                  if (widget.actionItem != ActionItem.smile &&
                      widget.actionItem != ActionItem.tiltPhone)
                    TextAnimator(
                      phraseText,
                      incomingEffect:
                          _settingsList[randomQuoteTextIndex].incomingEffect,
                      outgoingEffect:
                          _settingsList[randomQuoteTextIndex].outgoingEffect,
                      atRestEffect:
                          WidgetRestingEffects.pulse(effectStrength: 0.4),
                      // _settingsList[randomQuoteTextIndex].atRestEffect,
                      style: TextStyle(
                        shadows: const [
                          Shadow(
                            offset: Offset(0.0, 4),
                            blurRadius: 4,
                            color: Colors.black26,
                          ),
                        ],
                        fontSize: isPortrait ? 28.0 : 30.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      initialDelay: Duration(
                        milliseconds:
                            (((widget.readabilityTime ?? 1) * 1000) / 24)
                                .toInt(),
                      ),
                      // const Duration(milliseconds: 600),
                      // _settingsList[randomQuoteTextIndex].initialDelay,
                      spaceDelay:
                          _settingsList[randomQuoteTextIndex].spaceDelay,
                      characterDelay:
                          _settingsList[randomQuoteTextIndex].characterDelay,
                      // maxLines: _settingsList[currentPage].maxLines,
                    ),
                  // .animate(
                  //   delay: Duration(
                  //     milliseconds:
                  //         (((widget.readabilityTime ?? 1) * 1000) / 24)
                  //             .toInt(),
                  //   ),
                  // )
                  // .fadeIn()
                  // .blur(begin: const Offset(4, 4), end: const Offset(0, 0))
                  // .then()
                  // .scaleXY(
                  //   duration: Duration(
                  //     seconds: widget.readabilityTime?.toInt() ?? 1,
                  //   ),
                  //   begin: 0.7,
                  //   curve: Curves.easeInOut,
                  // ),
                  isPortrait
                      ? const SizedBox(height: 80)
                      : const SizedBox(
                          height: 16,
                        ),
                  // Text(
                  //   widget.phrase ?? '',
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     shadows: const [
                  //       Shadow(
                  //         offset: Offset(0.0, 4),
                  //         blurRadius: 4,
                  //         color: Color(0x33AAAAAA),
                  //       ),
                  //     ],
                  //     fontSize: isPortrait ? 28.0 : 30.0,
                  //     fontFamily: 'Poppins',
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  // TextAnimator(
                  //   widget.phrase ?? '',
                  //   incomingEffect:
                  //   _settingsList[randomQuoteTextIndex].incomingEffect,
                  //   outgoingEffect:
                  //   _settingsList[randomQuoteTextIndex].outgoingEffect,
                  //   atRestEffect:
                  //   _settingsList[randomQuoteTextIndex].atRestEffect,
                  //   style: TextStyle(
                  //     shadows: const [
                  //       Shadow(
                  //         offset: Offset(0.0, 4),
                  //         blurRadius: 4,
                  //         color: Color(0x33AAAAAA),
                  //       ),
                  //     ],
                  //     fontSize: isPortrait ? 28.0 : 30.0,
                  //     fontFamily: 'Poppins',
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.white,
                  //   ),
                  //   textAlign: TextAlign.center,
                  //   initialDelay:
                  //   _settingsList[randomQuoteTextIndex].initialDelay,
                  //   spaceDelay:
                  //   _settingsList[randomQuoteTextIndex].spaceDelay,
                  //   characterDelay:
                  //   _settingsList[randomQuoteTextIndex].characterDelay,
                  // ),
                ],
              )
              // .animate(
              //   delay: Duration(
              //     milliseconds:
              //         (((widget.readabilityTime ?? 1) * 1000) / 24).toInt(),
              //   ),
              // )
              // .fadeIn()
              // .blur(begin: const Offset(4, 4), end: const Offset(0, 0))
              // .then()
              // .scaleXY(
              //   duration: Duration(
              //     seconds: widget.readabilityTime?.toInt() ?? 1,
              //   ),
              //   begin: 0.7,
              //   curve: Curves.easeInOut,
              // ),
              ),
        ),

        if (isListeningFailed && isPortrait)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 128),
              child: CustomButton(
                text: "Try Again",
                // width: 300.sp,
                height: isPortrait ? 40 : 20,
                width: isPortrait ? 100 : 50,
                onTap: () {
                  _startPhraseListening();
                },
              ),
            ),
          ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: isPortrait ? 64 : 0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  // decoration: BoxDecoration(
                  //   // color: Colors.lightBlueAccent,
                  //   borderRadius: BorderRadius.circular(0),
                  //   border: Border.all(color: Colors.white),
                  // ),
                  child: Text(
                    '${widget.subliminalMessage?.message ?? ''} ${widget.subliminalMessage?.emoji ?? ''}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      shadows: [
                        Shadow(
                          offset: Offset(0.0, 4),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    .animate(
                      delay: Duration(
                        milliseconds:
                            (((widget.readabilityTime ?? 1) * 1000) / 6)
                                .toInt(),
                      ),
                    )
                    .slide(duration: const Duration(milliseconds: 100))
                    .fade(duration: const Duration(milliseconds: 100))
                    .then(
                      delay: Duration(
                        milliseconds:
                            (((widget.readabilityTime ?? 1) * 1000) / 24)
                                .toInt(),
                      ),
                    )
                    .blur(duration: const Duration(milliseconds: 100))
                    .fadeOut(duration: const Duration(milliseconds: 100))
                    .then(
                      delay: Duration(
                        milliseconds:
                            (((widget.readabilityTime ?? 1) * 1000) / 6)
                                .toInt(),
                      ),
                    )
                    .slide(duration: const Duration(milliseconds: 100))
                    .fade(duration: const Duration(milliseconds: 100))
                    .then(
                      delay: Duration(
                        milliseconds:
                            (((widget.readabilityTime ?? 1) * 1000) / 24)
                                .toInt(),
                      ),
                    )
                    .blur(duration: const Duration(milliseconds: 100))
                    .fadeOut(duration: const Duration(milliseconds: 100))
                    .then()
                    .hide(maintain: true),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.only(
                  left: 32,
                  right: 32,
                  bottom: isPortrait ? 64 : 16,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isLike == false
                        ? FilledButton.icon(
                            label: const Text("Dislike"),
                            icon: const Icon(Icons.thumb_down_rounded),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              fixedSize: const Size(128, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                isLike = null;
                              });
                            },
                          )
                        : OutlinedButton.icon(
                            label: const Text("Dislike"),
                            icon: const Icon(Icons.thumb_down_rounded),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              fixedSize: const Size(128, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                isLike = false;
                              });
                            },
                          ),
                    if (isListeningFailed && !isPortrait)
                      CustomButton(
                        text: "Try Again",
                        // width: 300.sp,
                        height: 40,
                        width: 100,
                        onTap: () {
                          _startPhraseListening();
                        },
                      ),
                    isLike == true
                        ? FilledButton.icon(
                            label: const Text("Like"),
                            icon: const Icon(Icons.thumb_up_rounded),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              fixedSize: const Size(128, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                isLike = null;
                              });
                            },
                          )
                        : OutlinedButton.icon(
                            label: const Text("Like"),
                            icon: const Icon(Icons.thumb_up_rounded),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              fixedSize: const Size(128, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                isLike = true;
                              });
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),

        ///
        if (widget.actionItem == ActionItem.smile)
          Center(
            child: CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 8,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animateFromLastPercent: true,
              animationDuration: 40,
              percent: min(1.0, smileValue),
              center: Text(
                "${min((smileValue * 100).toInt(), 100)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              ),
              progressColor: AppColors.primaryColor,
              backgroundColor: Colors.white54,
            ),
          ).animate().fadeIn().slideY(begin: -0.05, end: 0.0),

        ///
        Center(
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            numberOfParticles: 100,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.purple,
              Colors.yellow,
            ],
          ),
        ),
      ],
    );
  }
}
