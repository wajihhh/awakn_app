class LoginResponse {
  Data? data;
  String? message;

  LoginResponse({this.data, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? token;
  bool? isVerified;
  User? user;

  Data({this.token, this.isVerified, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    isVerified = json['is_verified'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['is_verified'] = isVerified;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? sId;
  String? fullName;
  String? role;
  String? email;
  String? phoneNo;
  String? password;
  List<String>? interests;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<String>? favourites;

  User(
      {this.sId,
      this.fullName,
      this.role,
      this.email,
      this.phoneNo,
      this.password,
      this.interests,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.favourites});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['full_name'];
    role = json['role'];
    email = json['email'];
    phoneNo = json['phone_no'];
    password = json['password'];
    interests = json['interests'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    favourites = json['favourites'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['full_name'] = fullName;
    data['role'] = role;
    data['email'] = email;
    data['phone_no'] = phoneNo;
    data['password'] = password;
    data['interests'] = interests;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['favourites'] = favourites;
    return data;
  }
}
