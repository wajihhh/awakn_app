import 'dart:developer';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:awakn/models/alarm_response.dart';
import 'package:awakn/models/alarm_setup_model.dart';
import 'package:awakn/models/objectives_response.dart';
import 'package:awakn/services/alarm_service.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/home/home_view_model.dart';
import 'package:awakn/widgets/snackbar_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../utils/global.dart';

class CreateAlarmViewModel extends GetxController {
  RxBool isLoading = false.obs;
  bool isEditMode = false;
  AlarmObject? alarmObj;
  RxBool isObjectiveLoading = false.obs;
  GetStorage box = GetStorage();

  Rx<AlarmSetupResponse?> alarmSetup = Rx<AlarmSetupResponse?>(null);

  RxBool isRepeatAlarm = false.obs;
  TextEditingController alarmTitleController = TextEditingController();
  TextEditingController alarmNoteController = TextEditingController();
  TextEditingController objectiveOverviewController = TextEditingController();
  TextEditingController objectiveTitleController = TextEditingController();
  RxList<String> repeatDays = RxList<String>([]);
  TimeOfDay selectedTime = TimeOfDay.now();

  String? textOnContainer = "Write Your Own Objectives".tr;
  String? selectedTune;
  RxList<String> selectedColor = RxList<String>([]);

  String? isSelected;
  final currentDay = DateFormat('EEEE').format(DateTime.now());

  final pageFormKey = GlobalKey<FormState>();

  IconData currentIcon = Icons.check_circle;
  RxBool isAlarmActive = true.obs;
  RxBool isWakeUpAlarm = true.obs;

  RxBool isAlarmNoteVisible = true.obs;
  RxBool isEndIconChanged = false.obs;
  RxList<Objective> selectedObjectives = <Objective>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    setupAlarm();
  }

  setAlarmObjects(AlarmObject alarm) {
    try {
      alarmObj = alarm;
      alarmTitleController.text = alarm.title ?? "";
      alarmNoteController.text = alarm.note ?? "";
      isRepeatAlarm(alarm.repeat);
      isAlarmActive(alarm.status);
      isWakeUpAlarm(alarm.type == "wake-up");
      repeatDays(alarm.interval);
      selectedColor(alarm.colorTags);
      selectedTune = alarm.tune?.name;
      selectedTime =
          stringToTimeOfDay(alarm.time ?? DateTime.now().toIso8601String());
      for (var objectiveId in alarm.objectiveId!) {
        getObjectiveById(objectiveId)
            .then((value) => selectedObjectives.add(value));
      }
      // getObjectiveById(alarm.objectiveId!)
      //     .then((value) => selectedObjectives.add(value));
    } catch (e) {
      debugPrint(e.toString());
    }
    // colorTags: ["General"],
  }

  void alarmNotesVisibility() {
    isAlarmNoteVisible.toggle();
    isEndIconChanged.toggle();
  }

  RxBool isObjectiveVisible = true.obs;
  RxBool isEndIconChanged2 = false.obs;
  RxBool isEndIconChanged3 = false.obs;

  void objectiveNotesVisibility() {
    isObjectiveVisible.toggle();
    isEndIconChanged2.toggle();
  }

  void tuneVisibility() {
    isObjectiveVisible.toggle();
    isEndIconChanged3.toggle();
  }

  void changeIcon() {
    currentIcon = (currentIcon == Icons.check_circle_outline)
        ? Icons.check_circle
        : Icons.check_circle_outline;
    update();
  }

  String get getTitle {
    if (!isRepeatAlarm.value ||
        repeatDays.length.isEqual(1) && repeatDays.first == currentDay) {
      return 'Today';
    } else if (repeatDays.isEmpty && isRepeatAlarm.value) {
      return 'Select Day';
    } else if (repeatDays.length.isEqual(days.length) && isRepeatAlarm.value) {
      return 'Every day';
    } else if (repeatDays.isNotEmpty) {
      var days = '';
      for (var element in repeatDays) {
        days += element.substring(0, 3);
        if (element != repeatDays.last) {
          days += ', ';
        }
      }
      return days;
    }

    return currentDay;
  }

  selectDay(String day) {
    repeatDays.contains(day) ? repeatDays.remove(day) : repeatDays.add(day);
    repeatDays.value = Helper.sortWeekDays(repeatDays.value);
    update();
  }

  // Future<void> showCustomTimePicker(BuildContext context) async {
  //   final picked = await showDialog<TimeOfDay>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return TimerPickerDialog(
  //         initialTime: selectedTime,
  //       );
  //     },
  //   );
  //
  //   if (picked != null && picked != selectedTime) {
  //     selectedTime = picked;
  //      update
  //   }
  // }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      update();
    }
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    DateTime now = DateTime.now();
    // final format = DateFormat.jm(); //"6:00 AM"
    var time = tod.split('T')[1];
    final timeList = time.split(':');
    final hour = int.parse(timeList.first);
    final minute = int.parse(timeList[1]);
    // final sec = int.parse(timeList[2].split('.').first);

    final date = DateTime(now.year, now.month, now.day, hour, minute);
    var res = TimeOfDay.fromDateTime(date);
    return res;
  }

  String get parseDateTime {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, selectedTime.hour,
            selectedTime.minute)
        .toIso8601String();
  }

  selectColor(String color) {
    //Limit to only one tag at a time
    if (selectedColor.isNotEmpty) {
      selectedColor.removeAt(0);
    }
    selectedColor.add(color);

    // selectedColor.contains(color)
    //     ? selectedColor.remove(color)
    //     : selectedColor.add(color);
    update();
  }

  AlarmSettings buildAlarmSetting(int id) {
    // final id = isEditMode
    //     ? DateTime.now().millisecondsSinceEpoch % 10000
    //     : widget.alarmSettings!.id;
    final getDateTime = getAlarmDateTime(repeatDays, selectedTime);
    final dateTime = DateTime(getDateTime.year, getDateTime.month,
        getDateTime.day, getDateTime.hour, getDateTime.minute);
    final title = alarmTitleController.text.trim();
    final alarmSettings = AlarmSettings(
      // id: DateTime.now().millisecondsSinceEpoch % 10000,
      id: id,
      dateTime: dateTime,
      // loopAudio: loopAudio,
      // vibrate: true,
      // volume: volume,
      assetAudioPath: tunesMap['Galaxy'
          // selectedTune ?? 'Sunny Mornings'
          ]!,
      // 'assets/tunes/nokia.mp3', //selectedTune ?? '',
      notificationTitle: title,
      notificationBody: 'Your alarm ($title) is ringing',
      enableNotificationOnKill: false,
    );
    return alarmSettings;
  }

  Future<void> createAlarm() async {
    if (alarmTitleController.text.isEmpty) {
      showCenteredSnackBar(Get.context!, 'Please enter alarm title!');

      return;
      // } else if (alarmNoteController.text.isEmpty) {
      //   SnackbarManager().showInfoSnackbar('Please enter alarm note.');
      //   return;
    } else if (selectedObjectives.isEmpty) {
      SnackbarManager()
          .showInfoSnackbar(Get.context!, 'Please select objective.');
      return;
    } else if (isObjectiveLoading.value) {
      SnackbarManager().showInfoSnackbar(
          Get.context!, 'Please wait while the objective is being created.');
      return;
    }
    final currentTime = TimeOfDay.now();
    final selectedTimeOfDay = selectedTime;
    // final currentDay = DateFormat('EEEE').format(DateTime.now());

    if (!isEditMode) {
      if (!isRepeatAlarm.value &&
          (selectedTimeOfDay.hour < currentTime.hour ||
              (selectedTimeOfDay.hour == currentTime.hour &&
                  selectedTimeOfDay.minute <= currentTime.minute))) {
        SnackbarManager()
            .showInfoSnackbar(Get.context!, 'Please select a future time.');
        return;
      }
      if (await hasSameOrCloseTimeAlarm(selectedTime)) {
        SnackbarManager().showInfoSnackbar(
            Get.context!, 'An alarm at this time already exists.');
        return;
      }
    }

    FocusManager.instance.primaryFocus?.unfocus();

    isLoading.value = true;

    String title = alarmTitleController.text.trim();
    final result = await AlarmService().addAlarm(
        title: title,
        note: alarmNoteController.text.trim(),
        repeat: isRepeatAlarm.value,
        colorTags: selectedColor.toList(),
        time: parseDateTime,
        status: isAlarmActive.value,
        type: isWakeUpAlarm.value ? "wake-up" : "exercise",
        objectiveIds:
            selectedObjectives.map((element) => element.sId!).toList(),
        interval: repeatDays.toList(),
        isUpdate: isEditMode,
        tune: selectedTune ?? '',
        alarmId: alarmObj?.sId ?? '');

    if (result != null) {
      final alarmId = Helper().getAlarmId(result.sId ?? alarmObj?.sId ?? '');
      box.write(alarmId.toString(), result.sId);

      Alarm.set(alarmSettings: buildAlarmSetting(alarmId)).then((res) {
        log('alarm add success: $res');
      });

      //navigate to home and fetch list
      final homeViewModel = Get.find<HomeViewModel>();

      homeViewModel.getUserAlarms(showLoader: true);

      Get.until((route) => Get.currentRoute == '/HomeView');
      SnackbarManager().showSuccessSnackbar(
          Get.context!,
          isEditMode
              ? '$title updated successfully.'
              : '$title added successfully.');
    }

    isLoading.value = false;
  }

  Future<bool> hasSameOrCloseTimeAlarm(TimeOfDay selectedTime) async {
    try {
      final homeViewModel = Get.find<HomeViewModel>();

      final List<AlarmObject> existingAlarms =
          homeViewModel.userAlarmsList(); // Assuming a method to fetch alarms

      for (var alarm in existingAlarms) {
        final alarmDateTime = DateTime.parse(alarm.time!);
        final existingTime = TimeOfDay.fromDateTime(alarmDateTime);

        // Check if the selected time is the same as an existing alarm time
        if (selectedTime.hour == existingTime.hour &&
            selectedTime.minute == existingTime.minute) {
          return true; // Alarm at the same time already exists
        }

        // Check if the selected time is within 10 minutes after an existing alarm time
        if ((selectedTime.hour == existingTime.hour &&
                selectedTime.minute >= existingTime.minute &&
                selectedTime.minute <= existingTime.minute + 10) ||
            (selectedTime.hour == existingTime.hour + 1 &&
                selectedTime.minute <= existingTime.minute - 50 &&
                selectedTime.minute >= 0)) {
          return true; // Alarm within 10 minutes after an existing alarm
        }

        // Check if the selected time is within 10 minutes before an existing alarm time
        if ((selectedTime.hour == existingTime.hour &&
                selectedTime.minute <= existingTime.minute &&
                selectedTime.minute >= existingTime.minute - 10) ||
            (selectedTime.hour == existingTime.hour - 1 &&
                selectedTime.minute >= existingTime.minute + 50 &&
                selectedTime.minute <= 59)) {
          return true; // Alarm within 10 minutes before an existing alarm
        }
      }
      return false; // No same or close time alarm found
    } catch (e) {
      debugPrint('Error fetching existing alarms: $e');
      return false; // Assume no alarm at the same time in case of an error
    }
  }

  Future<void> addObjective() async {
    if (objectiveOverviewController.text.isEmpty) {
      SnackbarManager()
          .showInfoSnackbar(Get.context!, 'Please enter objective overview');

      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    //  TODO(Junaid): way around for now as UI doesn't contain title field
    // final title = objectiveTitleController.text.isEmpty
    //     ? objectiveOverviewController.text.trim()
    //     : objectiveTitleController.text.trim();
    // Get.close(1);
    Get.back();
    isObjectiveLoading.value = true;
    var res = await AlarmService().addObjective(
        // title,
        objectiveOverviewController.text.trim());
    if (res != null) {
      objectiveOverviewController.clear();
      selectedObjectives.add(res);

      SnackbarManager().showSuccessSnackbar(
          Get.context!, 'New objective added successfully.');
    } else {
      // Get.back();
      SnackbarManager()
          .showAlertSnackbar(Get.context!, 'Error adding a new objective.');
      // isObjectiveLoading.value = false;

      // invalidCreds(true);
    }
    isObjectiveLoading.value = false;
  }

  Future<Objective> getObjectiveById(String id) async {
    isLoading.value = true;
    var res = await AlarmService().getObjectiveById(id);

    isLoading.value = false;
    return res!;
  }

  Future<void> setupAlarm() async {
    if (globalCache.alarmSetupResponse != null) {
      alarmSetup(globalCache.alarmSetupResponse);
      return;
    }
    isLoading.value = true;
    var res = await AlarmService().setupAlarm();
    alarmSetup(res);
    isLoading.value = false;
  }

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

/*
  DateTime convertSelectedTimeToDateTime(TimeOfDay selectedTime) {
    // Assuming selectedTime is in the format "HH:mm"
    List<String> parts = selectedTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // Get the current date to combine with the selected time
    DateTime currentDate = DateTime.now();

    // Create a new DateTime object with the selected time and the current date
    return DateTime(currentDate.year, currentDate.month, currentDate.day, hour, minute);
  }
*/
// This method checks if the alarm time falls on the current day and time, and if not,
// it finds the next valid day for the alarm based on the provided list of weekdays.
// If the alarm time is in the past, it also returns the next valid day.
  DateTime getAlarmDateTime(List<String> weekdays, TimeOfDay alarmTime) {
    // Get the current day of the week
    final currentDay = Helper.getCurrentDayOfWeek();

    // Check if the current day is included in the list of weekdays for the alarm
    if (!(weekdays.contains(currentDay)) && weekdays.isNotEmpty) {
      // If not, find the next valid day for the alarm
      int nextWeekDayDayOrderIndex = Helper.dayOrder[weekdays.first] ?? 0;
      DateTime nextDate = Helper.getDateFromWeekday(
          nextWeekDayDayOrderIndex); // Get the next valid day
      return nextDate;
    } else if (convertTimeOfDayToDateTime(alarmTime).isBefore(DateTime.now()) &
        weekdays.isNotEmpty) {
      // If the alarm time is in the past, also find the next valid day for the alarm
      int nextWeekDayDayOrderIndex = Helper.dayOrder[weekdays.first] ?? 0;
      DateTime nextDate = Helper.getDateFromWeekday(
          nextWeekDayDayOrderIndex); // Get the next valid day
      return nextDate;
    } else {
      // If the alarm time is valid, return it
      return convertTimeOfDayToDateTime(alarmTime);
    }
  }

  DateTime convertTimeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }
}
