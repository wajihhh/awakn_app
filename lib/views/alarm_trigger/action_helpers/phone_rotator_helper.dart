import 'dart:async';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';

class PhoneRotator {
  final Function onRotationDetected;

  StreamSubscription<AccelerometerEvent>? _streamSubscription;
  Timer? _sensingTimer;
  AccelerometerEvent? _acceleration;
  math.Point<int>? _initialDirection;

  PhoneRotator({required this.onRotationDetected});

  void startSensing() {
    _streamSubscription = accelerometerEvents.listen((event) {
      _acceleration = event;
    });

    _sensingTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _checkRotation();
    });
  }

  void _checkRotation() {
    if (_acceleration == null) return;

    final newDirection =
        _acceleration!.x.abs() < 1.0 && _acceleration!.y.abs() < 1.0
            ? null
            : (_acceleration!.x.abs() < _acceleration!.y.abs())
                ? math.Point<int>(0, _acceleration!.y.sign.toInt())
                : math.Point<int>(-_acceleration!.x.sign.toInt(), 0);

    if (_initialDirection == null) {
      _initialDirection = newDirection;
      return; // Do nothing on the first check to set the initial direction
    }

    final left = newDirection?.x == -1;
    final right = newDirection?.x == 1;
    final up = newDirection?.y == 1;
    final down = newDirection?.y == -1;

    if (newDirection != null &&
        newDirection != _initialDirection &&
        (left || right || up || down)) {
      onRotationDetected();
      stopSensing();
    }
  }

  void stopSensing() {
    _streamSubscription?.cancel();
    _sensingTimer?.cancel();
  }
}
