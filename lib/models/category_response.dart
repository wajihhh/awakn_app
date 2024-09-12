class CategoryDto {
  String? sId;
  String? name;
  String? createdAt;
  String? updatedAt;

  CategoryDto({this.sId, this.name, this.createdAt, this.updatedAt});

  static List<CategoryDto> fromJsonList(dynamic jsonRes) {
    List<CategoryDto> list = [];
    for (var json in jsonRes) {
      list.add(CategoryDto.fromJson(json));
    }
    return list;
  }

  CategoryDto.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
