import 'dart:math';

import 'package:flutter/material.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class TextAnimationsList {
  final List<SampleTextSettings> _settingsList = [];

  List<SampleTextSettings> getAnimationList() {
    return _settingsList.toList();
  }

  TextAnimationsList() {
    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects.incomingScaleDown(),
      outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 65),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
      outgoingEffect: WidgetTransitionEffects.outgoingScaleDown(
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 65),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects.incomingSlideInFromTop(),
      outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToLeft(
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 65),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects.incomingSlideInFromRight(),
      outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToLeft(
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 65),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(),
      outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToRight(
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 300),
      characterDelay: const Duration(milliseconds: 0),
      maxLines: 3,
    ));
    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects(
          blur: const Offset(10, 0),
          duration: const Duration(milliseconds: 600)),
      outgoingEffect: WidgetTransitionEffects(
        blur: const Offset(0, 10),
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 300),
      characterDelay: const Duration(milliseconds: 0),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects(
          blur: const Offset(10, 10),
          duration: const Duration(milliseconds: 600)),
      outgoingEffect: WidgetTransitionEffects(
        blur: const Offset(10, 10),
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 65),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects(
          offset: const Offset(-60, 0),
          blur: const Offset(10, 0),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 400)),
      outgoingEffect: WidgetTransitionEffects(
        offset: const Offset(60, 0),
        blur: const Offset(10, 0),
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 65),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects(
          offset: const Offset(0, 80),
          blur: const Offset(0, 20),
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300)),
      outgoingEffect: WidgetTransitionEffects(
        offset: const Offset(0, 80),
        blur: const Offset(0, 20),
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 60),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects(
          offset: const Offset(20, 20),
          scale: 0.5,
          rotation: pi / 10,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 300)),
      outgoingEffect: WidgetTransitionEffects(
        offset: const Offset(60, 60),
        scale: 0.5,
        rotation: -pi / 10,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 260),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects(),
      outgoingEffect: WidgetTransitionEffects(
        duration: const Duration(milliseconds: 2000),
      ),
      atRestEffect: WidgetRestingEffects.pulse(effectStrength: 0.4),
      initialDelay: const Duration(milliseconds: 0),
      spaceDelay: const Duration(milliseconds: 65),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));

    _settingsList.add(SampleTextSettings(
      incomingEffect: WidgetTransitionEffects.incomingOffsetThenScale(
          duration: const Duration(milliseconds: 600)),
      outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(
          duration: const Duration(milliseconds: 2000)),
      atRestEffect: WidgetRestingEffects.none(),
      initialDelay: const Duration(milliseconds: 50),
      spaceDelay: const Duration(milliseconds: 65),
      characterDelay: const Duration(milliseconds: 40),
      maxLines: 3,
    ));
  }
}

class SampleTextSettings {
  WidgetTransitionEffects incomingEffect;
  WidgetTransitionEffects outgoingEffect;
  WidgetRestingEffects atRestEffect;
  int maxLines;
  Duration initialDelay;
  Duration characterDelay;
  Duration spaceDelay;

  SampleTextSettings(
      {required this.incomingEffect,
      required this.outgoingEffect,
      required this.atRestEffect,
      required this.maxLines,
      required this.initialDelay,
      required this.characterDelay,
      required this.spaceDelay});
}
