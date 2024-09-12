class ObjectivesResponse {
  List<Objective>? objectives;
  List<Objective>? recommendations;

  ObjectivesResponse({this.objectives, this.recommendations});

  ObjectivesResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      objectives = <Objective>[];
      json['data'].forEach((v) {
        objectives!.add(Objective.fromJson(v));
      });
    }
    if (json['recommendations'] != null) {
      recommendations = <Objective>[];
      json['recommendations'].forEach((v) {
        recommendations!.add(Objective.fromJson(v));
      });
    }
  }
}

class Objective {
  String? sId;
  String? overview;
  List<String>? examples;
  List<String>? tags;
  String? coverImage;
  String? title;
  String? duration;
  List<String>? reviewIds;
  String? category;
  bool? isUserDefined;
  String? createdAt;
  String? updatedAt;
  bool? isFavourite;
  int? rating;
  String? userImage;

  String? goal;
  List<String>? imageSuggestions;
  List<String>? mainPhrases;
  List<String>? quotes;
  List<SubliminalMessages>? subliminalMessages;
  String? coverImageSuggestion;
  List<String>? sounds;
  List<String>? actions;
  String? color;

  Objective({
    this.sId,
    this.overview,
    this.examples,
    this.tags,
    this.coverImage,
    this.title,
    this.duration,
    this.reviewIds,
    this.category,
    this.isUserDefined,
    this.createdAt,
    this.updatedAt,
    this.isFavourite,
    this.rating,
    this.userImage,
    this.goal,
    this.imageSuggestions,
    this.mainPhrases,
    this.quotes,
    this.subliminalMessages,
    this.coverImageSuggestion,
    this.sounds,
    this.actions,
    this.color,
  });

  static List<Objective> fromJsonList(dynamic jsonRes) {
    List<Objective> list = [];
    for (var json in jsonRes) {
      list.add(Objective.fromJson(json));
    }
    return list;
  }

  Objective.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    overview = json['overview'];
    examples = json['examples'].cast<String>();
    tags = json['tags'].cast<String>();
    coverImage = json['cover_image'];
    title = json['title'];
    duration = json['duration'];
    reviewIds = json['reviewIds'].cast<String>();
    category = json['category'];
    isUserDefined = json['is_user_defined'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isFavourite = json['is_favourite'];
    rating = json['rating'];
    userImage = json['user_image'];
    goal = json['goal'];
    imageSuggestions = json['image-suggestions'].cast<String>();
    mainPhrases = json['main-phrases'].cast<String>();
    quotes = json['quotes'].cast<String>();
    if (json['subliminal-messages'] != null) {
      subliminalMessages = <SubliminalMessages>[];
      json['subliminal-messages'].forEach((v) {
        subliminalMessages!.add(SubliminalMessages.fromJson(v));
      });
    }
    coverImageSuggestion = json['cover_image_suggestion'];
    sounds = json['sounds'].cast<String>();
    actions = json['actions'].cast<String>();
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['overview'] = overview;
    data['examples'] = examples;
    data['tags'] = tags;
    data['cover_image'] = coverImage;
    data['title'] = title;
    data['duration'] = duration;
    data['reviewIds'] = reviewIds;
    data['category'] = category;
    data['is_user_defined'] = isUserDefined;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['is_favourite'] = isFavourite;
    data['rating'] = rating;
    data['user_image'] = userImage;
    data['goal'] = goal;
    data['image-suggestions'] = imageSuggestions;
    data['main-phrases'] = mainPhrases;
    data['quotes'] = quotes;
    if (subliminalMessages != null) {
      data['subliminal-messages'] =
          subliminalMessages!.map((v) => v.toJson()).toList();
    }
    data['cover_image_suggestion'] = coverImageSuggestion;
    data['sounds'] = sounds;
    data['actions'] = actions;
    data['color'] = color;
    return data;
  }
}

class SubliminalMessages {
  String? message;
  String? emoji;
  String? sId;

  SubliminalMessages({this.message, this.emoji, this.sId});

  SubliminalMessages.fromJson(Map<String, dynamic> json) {
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
