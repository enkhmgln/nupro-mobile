class UserInfo {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? sex;
  String? userType;
  String? dateOfBirth;
  String? address;
  String? profilePicture;
  String? createdAt;
  String? lastLogin;

  UserInfo(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.sex,
      this.userType,
      this.dateOfBirth,
      this.address,
      this.profilePicture,
      this.createdAt,
      this.lastLogin});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    sex = json['sex'];
    userType = json['user_type'];
    dateOfBirth = json['date_of_birth'];
    address = json['address'];
    profilePicture = json['profile_picture'];
    createdAt = json['created_at'];
    lastLogin = json['last_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['sex'] = sex;
    data['user_type'] = userType;
    data['date_of_birth'] = dateOfBirth;
    data['address'] = address;
    data['profile_picture'] = profilePicture;
    data['created_at'] = createdAt;
    data['last_login'] = lastLogin;
    return data;
  }
}

class Meta {
  bool? success;
  String? timestamp;
  String? traceId;
  String? version;

  Meta({this.success, this.timestamp, this.traceId, this.version});

  Meta.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    timestamp = json['timestamp'];
    traceId = json['trace_id'];
    version = json['version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['timestamp'] = timestamp;
    data['trace_id'] = traceId;
    data['version'] = version;
    return data;
  }
}
