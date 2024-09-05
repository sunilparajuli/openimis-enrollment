import '../../base/idto.dart';

class LoginInDto implements IDto {
  LoginInDto({
    this.username,
    this.password,
  });

  String? username;
  String? password;

  LoginInDto.fromJson(dynamic json) {
    username = json['username'];
    password = json['password'];
  }

  LoginInDto copyWith({
    String? username,
    String? password,
  }) =>
      LoginInDto(
        username: username ?? this.username,
        password: password ?? this.password,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = password;
    return map;
  }
}
