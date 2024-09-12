class AlarmSetupResponse {
  List<Tunes>? tunes;
  List<ColorTags>? colorTags;

  AlarmSetupResponse({this.tunes, this.colorTags});

  AlarmSetupResponse.fromJson(Map<String, dynamic> json) {
    if (json['tunes'] != null) {
      tunes = <Tunes>[];
      json['tunes'].forEach((v) {
        tunes!.add(Tunes.fromJson(v));
      });
    }
    if (json['color_tags'] != null) {
      colorTags = <ColorTags>[];
      json['color_tags'].forEach((v) {
        colorTags!.add(ColorTags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tunes != null) {
      data['tunes'] = tunes!.map((v) => v.toJson()).toList();
    }
    if (colorTags != null) {
      data['color_tags'] = colorTags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tunes {
  String? name;
  String? url;

  Tunes({this.name, this.url});

  Tunes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class ColorTags {
  String? title;
  List<String>? colors;

  ColorTags({this.title, this.colors});

  ColorTags.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    colors = json['colors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['colors'] = colors;
    return data;
  }
}
