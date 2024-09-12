class GeneralSettingResponse {
  bool? smoothWakeUp;
  bool? blockAlarmDuringCalls;
  bool? stickAlarm;
  bool? disturbMode;
  int? generalAlarmVolume;
  String? colorMode;

  GeneralSettingResponse(
      {this.smoothWakeUp,
        this.blockAlarmDuringCalls,
        this.stickAlarm,
        this.disturbMode,
        this.generalAlarmVolume,
        this.colorMode});

  GeneralSettingResponse.fromJson(Map<String, dynamic> json) {
    smoothWakeUp = json['smooth_wake_up'];
    blockAlarmDuringCalls = json['block_alarm_during_calls'];
    stickAlarm = json['stick_alarm'];
    disturbMode = json['disturb_mode'];
    generalAlarmVolume = json['general_alarm_volume'];
    colorMode = json['color_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['smooth_wake_up'] = this.smoothWakeUp;
    data['block_alarm_during_calls'] = this.blockAlarmDuringCalls;
    data['stick_alarm'] = this.stickAlarm;
    data['disturb_mode'] = this.disturbMode;
    data['general_alarm_volume'] = this.generalAlarmVolume;
    data['color_mode'] = this.colorMode;
    return data;
  }
}