import 'dart:math';
import 'package:alarm/model/alarm_settings.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:autostart_settings/autostart_settings.dart';
import 'package:awakn/models/alarm_response.dart';
import 'package:awakn/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum ActionItem {
  smile,
  repeatPhrase,
  tiltPhone,
}

ActionItem? getCurrentActionEnum(String? action) {
  if (action == ActionItem.smile.name) {
    return ActionItem.smile;
  } else if (action == ActionItem.repeatPhrase.name) {
    return ActionItem.repeatPhrase;
  } else if (action == ActionItem.tiltPhone.name) {
    return ActionItem.tiltPhone;
  } else {
    return null;
  }
}

// var text = 'Initial text'.obs;

Future<bool> openSettings() async {
  try {
    final opened = await AutostartSettings.open(
      autoStart: true,
      batterySafer: true,
    );
    debugPrint('isAutoStart available: $opened');

    return opened;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

//initializing the autoStart with the first build.
Future<bool> initAutoStart() async {
  try {
    // Check auto-start availability.
    var test = await isAutoStartAvailable ?? false;
    debugPrint('isAutoStart available: $test');
    // If available, navigate to auto-start setting page.
    if (test) {
      await getAutoStartPermission();
      return true;
    }
  } on PlatformException catch (e) {
    debugPrint(e.toString());
  }
  return false;
}

AlarmSettings buildAlarmSettings(int id, AlarmObject alarm,
    {bool isRepeat = false}) {
  // final id = isEditMode
  //     ? DateTime.now().millisecondsSinceEpoch % 10000
  //     : widget.alarmSettings!.id;

  final selectedTime = DateTime.parse(alarm.time!);
  // final currentDay = DateFormat('EEEE').format(selectedTime);
  if (isRepeat) {
    selectedTime.add(const Duration(days: 1));
  }
  if (alarm.interval!.isNotEmpty && alarm.interval!.length != 7) {
    // JD make algo for days
  }
  final now = DateTime.now();
  final dateTime = DateTime(
      now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);

  final title = alarm.title ?? '';
  final alarmSettings = AlarmSettings(
    // id: DateTime.now().millisecondsSinceEpoch % 10000,
    id: id,
    dateTime: dateTime,
    // loopAudio: loopAudio,
    // vibrate: true,
    // volume: volume,
    assetAudioPath: tunesMap['Galaxy'
        // alarm.tune?.name ?? 'Sunny Mornings'
        ]!,
    // 'assets/tunes/nokia.mp3', //selectedTune ?? '',
    notificationTitle: title,
    notificationBody: 'Your alarm ($title) is ringing',
    enableNotificationOnKill: false,
  );
  return alarmSettings;
}

extension ActionItemExtension on ActionItem {
  String get name {
    switch (this) {
      case ActionItem.smile:
        return 'smile';
      case ActionItem.repeatPhrase:
        return 'repeat the phrase';
      case ActionItem.tiltPhone:
        return 'rotate your phone';
      default:
        return '';
    }
  }
}

enum Daytime {
  morning,
  afternoon,
  evening,
  night,
}

extension DaytimeExtension on Daytime {
  String get backgroundImage {
    switch (this) {
      case Daytime.morning:
        return 'assets/images/Morning bg.png';
      case Daytime.afternoon:
        return 'assets/images/Noon bg.png';
      case Daytime.evening:
        return 'assets/images/evening bg.png';
      case Daytime.night:
        return 'assets/images/night bg.png';
      default:
        return 'assets/images/Morning bg.png';
    }
  }

  String get name {
    switch (this) {
      case Daytime.morning:
        return 'Good Morning';
      case Daytime.afternoon:
        return 'Good Afternoon';
      case Daytime.evening:
        return 'Good Evening';
      case Daytime.night:
        return 'Good Night';
      default:
        return '';
    }
  }

  String get narrative {
    switch (this) {
      case Daytime.morning:
        return 'Its bright shiny morning waiting for you to get up and enjoy.';
      case Daytime.afternoon:
        return "Wake-up call! \nIt may be afternoon, but there's no snoozing through life's opportunities. \nLet's make the most of it!";
      case Daytime.evening:
        return "Wake-up call! \nThe late afternoon sun is still shining, and so are you! \nKeep rising and shining till the evening arrives!";
      case Daytime.night:
        return 'Night Owl han ;)';
      default:
        return '';
    }
  }
}

Daytime getCurrentDaytimeEnum() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour >= 6 && hour < 12) {
    return Daytime.morning;
  } else if (hour >= 12 && hour < 18) {
    return Daytime.afternoon;
  } else if (hour >= 18 && hour < 21) {
    return Daytime.evening;
  } else {
    return Daytime.night;
  }
}

extension RandomInt on int {
  static int generate({int min = 1, required int max}) {
    final random = Random();
    final result = min + random.nextInt(max - min);
    debugPrint(result.toString());
    return result;
  }
}

extension StringExtensions on String? {
  /// Check both not null and not empty i.e. "".
  bool get isNotNullAndNotEmpty => this != null && this!.isNotEmpty;

  /// Returns two fixed decimal points.
  /// ```dart
  /// print(5000.9200.toPoints());
  /// output=> 5000.92
  /// ```
  String toPoints({int intPoint = 2}) {
    if (this == "") {
      return this!;
    }
    try {
      return double.parse(this!).toStringAsFixed(intPoint);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return this!;
    }
  }
}

class Helper {
  // Map days to integers for sorting
  static Map<String, int> dayOrder = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

  int getAlarmId(String id) {
    const maxIntValue = 2147483647;
    const minIntValue = -2147483648;

    // Pad with leading zeros if needed
    final String hexStringPadded = id.padLeft(16, '0');

    // Calculate high and low 32-bit parts
    final int highInt = int.parse(hexStringPadded.substring(0, 8), radix: 16);
    final int lowInt = int.parse(hexStringPadded.substring(8, 16), radix: 16);

    // Combine parts into a BigInt
    final combinedBigInt = BigInt.from(highInt) << 32 | BigInt.from(lowInt);

    // Remove extra digits from the right side to fit int32 range
    int result = combinedBigInt.toInt();
    while (result > maxIntValue || result < minIntValue) {
      // Truncate the least significant digit
      result ~/= 10;
    }

    return result;
  }

  String? validatePassword(String? value, {int minLength = 2}) {
    var message = "Password is required";
    if (value == null || value.isEmpty) {
      message = message;
    } else if (value.length < minLength) {
      message = "Password minimum length is of $minLength characters. ";
    } else {
      // Regex condition and messages
      return null;
    }
    return message;
  }

  static Future<bool?> confirmExit() {
    Future<bool?> res = showDialog<bool>(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Exit",
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
          content: Text(
            "Are you sure you want to exit?",
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
          actions: [
            ElevatedButton(
              child: const Text("No"),
              onPressed: () {
                Get.back(result: false);
              },
            ),
            ElevatedButton(
              child: const Text("Yes"),
              onPressed: () {
                Get.back(result: true);
              },
            ),
          ],
        );
      },
    );
    return res;
  }

  // static String backgroundTunePath(String name) {
  //   switch (name) {
  //     case 'galaxy':
  //       return 'assets/audio/Sovereign.mp3';
  //     case 'chimes':
  //       return 'assets/audio/Sovereign.mp3';
  //     case 'chorus':
  //       return 'assets/audio/Sovereign.mp3';
  //     case 'whistle':
  //       return 'assets/audio/Sovereign.mp3';
  //     default:
  //       return 'assets/audio/Sovereign.mp3';
  //   }
  // }

  static String getCurrentDayOfWeek() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  static DateTime getDateFromWeekday(int weekday) {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    int daysToAdd = weekday - currentWeekday;
    if (daysToAdd <= 0) {
      daysToAdd += 7;
    }
    final nextDate = now.add(Duration(days: daysToAdd));
    return DateTime(nextDate.year, nextDate.month, nextDate.day);
  }

  static List<String> sortWeekDays(List<String> repeatDays) {
    if (repeatDays.length > 1) {
      repeatDays.sort((a, b) {
        return dayOrder[a]! - dayOrder[b]!;
      });
    }

    return repeatDays;
  }
}
