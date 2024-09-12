import 'package:awakn/models/alarm_setup_model.dart';
import 'package:awakn/models/login_response.dart';
import 'package:awakn/models/profile_response.dart';

final GlobalCache globalCache = GlobalCache();

class GlobalCache {
  User? user;
  ProfileResponse? userProfile;

  int? selectedAnswerIndex;
  AlarmSetupResponse? alarmSetupResponse;
}

class AppConstants {
  static String appId = "88454060-9716-46e9-8a61-495315697a84"; //eprep
  static const existingCheckKey = "isFirstTime";
  static const rememberMeEnabledKey = "rememberMeEnabled";

  static const skinToneMin = 1;
}

const tunesMap = {
  'Chime': 'assets/tunes/chime.mp3',
  'Chorus': 'assets/tunes/coral_chorus.mp3',
  'Galaxy': 'assets/tunes/samsung_galaxy.mp3',
  'Whistle': 'assets/tunes/whistle.mp3',
  'Sunny Mornings': 'assets/tunes/sunny_mornings.mp3',
};
