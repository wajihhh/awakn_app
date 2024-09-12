class ProfileResponse {
  String? sId;
  String? fullName;
  String? role;
  String? email;
  String? phoneNo;
  List<String>? interests;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<String>? favourites;
  PasswordUpdate? passwordUpdate;
  String? city;
  String? country;
  String? profilePicture;

  ProfileResponse(
      {this.sId,
      this.fullName,
      this.role,
      this.email,
      this.phoneNo,
      this.interests,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.favourites,
      this.passwordUpdate,
      this.city,
      this.country,
      this.profilePicture});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['full_name'];
    role = json['role'];
    email = json['email'];
    phoneNo = json['phone_no'];
    interests = json['interests'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    favourites = json['favourites'].cast<String>();
    passwordUpdate = json['passwordUpdate'] != null
        ? PasswordUpdate.fromJson(json['passwordUpdate'])
        : null;
    city = json['city'];
    country = json['country'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['full_name'] = fullName;
    data['role'] = role;
    data['email'] = email;
    data['phone_no'] = phoneNo;
    data['interests'] = interests;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['favourites'] = favourites;
    if (passwordUpdate != null) {
      data['passwordUpdate'] = passwordUpdate!.toJson();
    }
    data['city'] = city;
    data['country'] = country;
    data['profile_picture'] = profilePicture;
    return data;
  }
}

class PasswordUpdate {
  String? token;
  int? expiry;
  String? passwordUpdatedAt;
  String? sId;

  PasswordUpdate({this.token, this.expiry, this.passwordUpdatedAt, this.sId});

  PasswordUpdate.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiry = json['expiry'];
    passwordUpdatedAt = json['password_updated_at'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expiry'] = expiry;
    data['password_updated_at'] = passwordUpdatedAt;
    data['_id'] = sId;
    return data;
  }
}
