import 'dart:async';
import 'dart:developer';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:awakn/models/alarm_response.dart';
import 'package:awakn/models/profile_response.dart';
import 'package:awakn/services/alarm_service.dart';
import 'package:awakn/services/user_service.dart';
import 'package:awakn/utils/global.dart';
import 'package:awakn/utils/helper.dart';
import 'package:awakn/views/alarm_trigger/alarm_trigger_view_model.dart';
import 'package:awakn/views/alarm_trigger/face_detection/face_detector_view.dart';
import 'package:awakn/widgets/snackbar_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

StreamSubscription<AlarmSettings>? subscription;

class HomeViewModel extends GetxController with WidgetsBindingObserver {
  bool isInBackground = true;

  RxBool isLoading = true.obs;
  RxBool isDarkMode = false.obs;
  Rxn<ProfileResponse> userProfile = Rxn<ProfileResponse>();
  RxList<AlarmObject> userAlarmsList = RxList<AlarmObject>();
  late List<AlarmSettings> alarms;

  GetStorage box = GetStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    if (!kReleaseMode) {}
    if (Alarm.android) {
      await checkAndroidNotificationPermission();
      await checkAndroidScheduleExactAlarmPermission();
    }

    loadAlarms();
    Future.wait([
      getUserProfile(),
      getUserAlarms(),
      checkCameraPermission(),
      // SpeechToText().initialize(),
    ]).then((value) async {
      setupAlarm();

      isLoading(false);

      initAlarmSubscription();
    });
  }

  initAlarmSubscription() async {
    try {
      if (subscription != null) return;

      subscription = Alarm.ringStream.stream.listen(
        (alarmSettings) => navigateToRingScreen(alarmSettings),
      );
      subscription?.onError(
        (handleError) {
          SnackbarManager().showAlertSnackbar(
            Get.context!,
            handleError.toString(),
          );
        },
      );
      // subscription?.onError((handleError) => log(handleError.toString()));
    } catch (e) {
      if (Get.context?.mounted ?? false) {
        SnackbarManager().showAlertSnackbar(Get.context!, e.toString());
      }
    }
  }

  @override
  void dispose() {
    // subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void setIsForeground(bool isForeground) {
    isInBackground = !isForeground;
    if (isInBackground) {
      if (subscription == null) {
        log('subscription null on pause');
      }
      subscription?.pause();

      // log('App backgrounded');
    } else {
      if (subscription == null) {
        log('subscription null on resume');
      }
      subscription?.resume();
      // log('App foregrounded');
    }
    // Notify listeners automatically in GetX
    update();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // setIsForeground(true);
      log('App resumed');
    } else if (state == AppLifecycleState.inactive) {
      log('App inactive');
    } else if (state == AppLifecycleState.hidden) {
      log('App hidden');
    } else if (state == AppLifecycleState.paused) {
      // setIsForeground(true);
      log('App paused');
    } else if (state == AppLifecycleState.detached) {
      log('App detached');
    }

    //  else {
    //   setIsForeground(false);
    // }
  }

  void loadAlarms() {
    alarms = Alarm.getAlarms();
    alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    update();
  }

  Future<void> navigateToRingScreen(AlarmSettings? alarmSettings) async {
    final model = Get.put(
      AlarmTriggerViewModel(),
      // permanent: true,
    );
    if (alarmSettings != null) {
      model.alarmId = alarmSettings.id;
      await getAlaramDataById(alarmSettings.id.toString()).then((alarmData) {
        model.alarm = alarmData;
        model.isWakeUpAlarm(alarmData.type == 'wake-up');
        checkNextAlarm(alarmData);
        model.initializeReelsController();
        Get.to(() => FaceDetectorView(model: model));
      }).catchError((onError) {
        debugPrint(onError.toString());
      });
    } else {
      //Temp Case
      model.initializeReelsController();
      Get.to(() => FaceDetectorView(model: model));
    }
    // loadAlarms();
  }

  Future<AlarmObject> getAlaramDataById(String id) async {
    try {
      final sId = box.read(id);
      final result = userAlarmsList.firstWhere((element) => element.sId == sId);
      // final resp = AlarmObject.fromJson(result);
      return result;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void checkNextAlarm(AlarmObject alarmObject) {
    if ((alarmObject.repeat ?? false) &&
        (alarmObject.interval?.isNotEmpty ?? false)) {
      //get list of day that set for repeated
      List<String> weekdays = Helper.sortWeekDays(alarmObject.interval ?? []);
      final workDay = Helper.getCurrentDayOfWeek();
      //check next week day
      int nextWeekDayIndex = weekdays.indexOf(workDay) + 1;
      //if sunday occur
      if (nextWeekDayIndex >= weekdays.length) {
        nextWeekDayIndex = 0;
      }
      int nextWeekDayDayOrderIndex =
          Helper.dayOrder[weekdays[nextWeekDayIndex]] ?? 0;
      DateTime nextDate = Helper.getDateFromWeekday(nextWeekDayDayOrderIndex);

      Alarm.set(alarmSettings: buildAlarmSetting(alarmObject, nextDate))
          .then((res) {
        log('alarm add success: $res');
      });
    }
  }

  AlarmSettings buildAlarmSetting(AlarmObject alarmObject, DateTime nextDate) {
    final selectedDateTime =
        DateTime.parse(alarmObject.time ?? "2024-05-01T23:15:00.000Z");

    final dateTime = DateTime(nextDate.year, nextDate.month, nextDate.day,
        selectedDateTime.hour, selectedDateTime.minute);
    final title = alarmObject.title;
    final alarmSettings = AlarmSettings(
      // id: DateTime.now().millisecondsSinceEpoch % 10000,
      id: int.parse(alarmObject.sId ?? "0"),
      dateTime: dateTime,
      // loopAudio: loopAudio,
      // vibrate: true,
      // volume: volume,
      assetAudioPath: tunesMap['Galaxy'
          // alarmObject.tune ?? 'Sunny Mornings'
          ]!,
      // 'assets/tunes/nokia.mp3', //selectedTune ?? '',
      notificationTitle: title ?? "",
      notificationBody: 'Your alarm ($title) is ringing',
      enableNotificationOnKill: false,
    );
    return alarmSettings;
  }

  Future<void> checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      final res = await Permission.camera.request();
      alarmPrint(
        'Camera permission ${res.isGranted ? '' : 'not'} granted.',
      );
    } else {
      debugPrint('Camera permission allowed');
    }
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  toggleAlarm(AlarmObject alarm) async {
    // TODO(Junaid): integrate toggle alarm status API
    log("Alarm status updated: ${alarm.sId}");
  }

  get getGradient {
    !isDarkMode.value
        ? const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // stops: [0.0,0.1],
            // #6D3FFF, #9878FF
            // #6D3FFF, #9878FF
            colors: [
                // #6D3FFF, #9878FF
                Color(0xff1F1743),
                Color(0xff110D28),
                Color(0xff110D28),
                Color(0xff1F1743),
              ])
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff6B46F6), Color(0xff8001FF)],
            stops: [0.3, 0.7],
          );
  }

  Future<void> getUserProfile() async {
    final response = await UserService().getProfile();
    userProfile(response);
  }

  Future<void> getUserAlarms({bool showLoader = false}) async {
    if (showLoader) {
      isLoading(true);
    }
    final response = await AlarmService().getAlarmsList();
    userAlarmsList(response);
    if (showLoader) {
      isLoading(false);
    }
  }

  Future<bool> deleteAlarm(String id) async {
    isLoading.value = true;
    if (await AlarmService().deleteAlarm(id)) {
      if (Alarm.getAlarm(Helper().getAlarmId(id)) != null) {
        Alarm.stop(Helper().getAlarmId((id))).then((res) {
          // if (res) Get.back(result: true);
          log('alarm delete success: $res');
        });
      }
      isLoading.value = false;
      getUserAlarms(showLoader: true);
      final alarmId = Helper().getAlarmId(id).toString();
      if (box.hasData(alarmId)) {
        box.remove(alarmId);
      }
      return true;
    } else {
      isLoading.value = false;
      SnackbarManager()
          .showAlertSnackbar(Get.context!, 'Error deleting alarm.');
      return false;
    }
  }

  Future<void> setupAlarm() async {
    await AlarmService().setupAlarm();
  }
}
