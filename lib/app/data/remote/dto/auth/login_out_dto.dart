import 'package:openimis_app/app/data/local/entities/user_entity.dart' as local_entities;


import '../../base/idto.dart';

class LoginOutDto implements IDto {
  LoginOutDto({
    this.refresh,
    this.access,
    this.username,
    this.user,
    this.exp,
    this.firstName,
    this.lastName,
    this.email,
    this.userType,
    this.isOfficer,
    this.isInsuree,
    this.insureeInfo, // Specify the correct `InsureeInfo` class
  });

  LoginOutDto.fromJson(dynamic json) {
    refresh = json['refresh'];
    access = json['access'];
    username = json['username'];
    user = json['user'];
    exp = json['exp'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    userType = json['user_type'];
    isOfficer = json['is_officer'];
    isInsuree = json['is_insuree'];
    insureeInfo = json['insuree_info'] != null
        ? local_entities.InsureeInfo.fromJson(json['insuree_info']) // Use `local_entities.InsureeInfo`
        : null;
  }

  String? refresh;
  String? access;
  String? username;
  dynamic user;
  int? exp;
  String? firstName;
  String? lastName;
  String? email;
  dynamic userType;
  bool? isOfficer;
  bool? isInsuree;
  local_entities.InsureeInfo? insureeInfo; // Use the specific InsureeInfo class here

  LoginOutDto copyWith({
    String? refresh,
    String? access,
    String? username,
    dynamic user,
    int? exp,
    String? firstName,
    String? lastName,
    String? email,
    dynamic userType,
    bool? isOfficer,
    bool? isInsuree,
    local_entities.InsureeInfo? insureeInfo, // Specify the correct class
  }) =>
      LoginOutDto(
        refresh: refresh ?? this.refresh,
        access: access ?? this.access,
        username: username ?? this.username,
        user: user ?? this.user,
        exp: exp ?? this.exp,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        userType: userType ?? this.userType,
        isOfficer: isOfficer ?? this.isOfficer,
        isInsuree: isInsuree ?? this.isInsuree,
        insureeInfo: insureeInfo ?? this.insureeInfo,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['refresh'] = refresh;
    map['access'] = access;
    map['username'] = username;
    map['user'] = user;
    map['exp'] = exp;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['user_type'] = userType;
    map['is_officer'] = isOfficer;
    map['is_insuree'] = isInsuree;
    if (insureeInfo != null) {
      map['insuree_info'] = insureeInfo!.toJson();
    }
    return map;
  }
}
