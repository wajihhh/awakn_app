import 'dart:async';
import 'package:awakn/views/alarm_trigger/alarm_trigger_view_model.dart';
import 'package:get/get.dart';

class SmileDetector {
  final RxDouble smileProgress;
  final Function onSmileDetected;

  Timer? _smileTimer;
  StreamSubscription<bool>? _streamSubscription;

  SmileDetector({required this.smileProgress, required this.onSmileDetected});

  void startDetection() {
    final smileStream = Get.find<AlarmTriggerViewModel>().smileDetected;

    _streamSubscription = smileStream.listen((value) {
      if (value) {
        _smileTimer =
            Timer.periodic(const Duration(milliseconds: 100), (Timer t) {
          smileProgress.value += 0.05;
          if (smileProgress.value >= 1.0) {
            onSmileDetected();
            t.cancel();
            smileProgress.value = 1.0;
          }
        });
      } else {
        _smileTimer?.cancel();
      }
    });
  }

  void stopDetection() {
    _streamSubscription?.cancel();
  }
}
