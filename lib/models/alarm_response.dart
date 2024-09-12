class AlarmObject {
  String? sId;
  String? title;
  String? note;
  Tune? tune;
  bool? repeat;
  List<String>? colorTags;
  String? userId;
  String? time;
  bool? status;
  String? type;
  List<String>? objectiveId;
  List<String>? interval;
  String? createdAt;
  String? updatedAt;

  AlarmObject(
      {this.sId,
      this.title,
      this.note,
      this.tune,
      this.repeat,
      this.colorTags,
      this.userId,
      this.time,
      this.status,
      this.type,
      this.objectiveId,
      this.interval,
      this.createdAt,
      this.updatedAt});

  static List<AlarmObject> fromJsonList(dynamic jsonRes) {
    List<AlarmObject> list = [];
    for (var json in jsonRes) {
      list.add(AlarmObject.fromJson(json));
    }
    return list;
  }

  AlarmObject.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    note = json['note'];
    tune = json['tune'] != null ? Tune.fromJson(json['tune']) : null;
    repeat = json['repeat'];
    colorTags = json['color_tags'].cast<String>();
    userId = json['userId'];
    time = json['time'];
    status = json['status'];
    type = json['type'];
    objectiveId = json['objectiveId'].cast<String>();
    interval = json['interval'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['note'] = note;
    if (tune != null) {
      data['tune'] = tune!.toJson();
    }
    data['repeat'] = repeat;
    data['color_tags'] = colorTags;
    data['userId'] = userId;
    data['time'] = time;
    data['status'] = status;
    data['type'] = type;
    data['objectiveId'] = objectiveId;
    data['interval'] = interval;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Tune {
  String? name;
  String? url;
  String? sId;

  Tune({this.name, this.url, this.sId});

  Tune.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    data['_id'] = sId;
    return data;
  }
}
