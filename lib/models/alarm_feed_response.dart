class AlarmFeed {
  String? action;
  String? image;
  String? phrase;
  String? quote;
  String? sound;
  SubliminalMessage? subliminalMessage;
  double? readabilityTime;

  AlarmFeed(
      {this.action,
      this.image,
      this.phrase,
      this.quote,
      this.sound,
      this.subliminalMessage,
      this.readabilityTime});

  static List<AlarmFeed> fromJsonList(dynamic jsonRes) {
    List<AlarmFeed> list = [];
    for (var json in jsonRes) {
      list.add(AlarmFeed.fromJson(json));
    }
    return list;
  }

  AlarmFeed.fromJson(Map<String, dynamic> json) {
    action = json['action'];
    image = json['image'];
    phrase = json['phrase'];
    quote = json['quote'];
    sound = json['sound'];
    subliminalMessage = json['subliminal_message'] != null
        ? SubliminalMessage.fromJson(json['subliminal_message'])
        : null;
    readabilityTime = json['readability_time'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['action'] = action;
    data['image'] = image;
    data['phrase'] = phrase;
    data['quote'] = quote;
    data['sound'] = sound;
    if (subliminalMessage != null) {
      data['subliminal_message'] = subliminalMessage!.toJson();
    }
    data['readability_time'] = readabilityTime;
    return data;
  }
}

class SubliminalMessage {
  String? message;
  String? emoji;
  String? sId;

  SubliminalMessage({this.message, this.emoji, this.sId});

  SubliminalMessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    emoji = json['emoji'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['emoji'] = emoji;
    data['_id'] = sId;
    return data;
  }
}
