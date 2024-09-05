import 'package:openimis_app/app/data/remote/base/idto.dart';

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
    return map;
  }
}

class Token {
  Token({
    this.access,
  });

  Token.fromJson(dynamic json) {
    access = json['access'];
  }

  String? access;

  Token copyWith({
    String? access,
  }) =>
      Token(
        access: access ?? this.access,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access'] = access;
    return map;
  }
}
