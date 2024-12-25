import 'package:openimis_app/app/data/local/base/i_entity.dart';

class UserEntity implements IEntity {
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? token;
  String? status;
  String? role;
  String? refresh;
  bool? isOfficer;
  bool? isInsuree;
  InsureeInfo? insureeInfo; // Add insureeInfo field

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.token,
    required this.status,
    required this.role,
    required this.refresh,
    required this.isOfficer,
    required this.isInsuree,
    this.insureeInfo, // Optional field
  });

  @override
  UserEntity.fromMap(dynamic map) {
    id = map['id'];
    name = map['name'];
    email = map['email'];
    phoneNumber = map['phone'];
    token = map['token'];
    status = map['status'];
    role = map['role'];
    refresh = map['refresh'];
    isOfficer = map['is_officer'];
    isInsuree = map['is_insuree'];
    // Deserialize insureeInfo if present
    insureeInfo = map['insuree_info'] != null
        ? InsureeInfo.fromMap(map['insuree_info'])
        : null;
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phoneNumber;
    map['token'] = token;
    map['role'] = role;
    map['status'] = status;
    map['refresh'] = refresh;
    map['is_officer'] = isOfficer;
    map['is_insuree'] = isInsuree;
    // Serialize insureeInfo if present
    if (insureeInfo != null) {
      map['insuree_info'] = insureeInfo!.toMap();
    }
    return map;
  }
}

// Define InsureeInfo class
class InsureeInfo {
  String? firstName;
  String? lastName;
  String? chfid;
  String? uuid;
  dynamic? family;

  InsureeInfo({
    this.firstName,
    this.lastName,
    this.chfid,
    this.uuid,
    this.family,
  });

  InsureeInfo.fromMap(dynamic map) {
    firstName = map['first_name'];
    lastName = map['last_name'];
    chfid = map['chfid'];
    uuid = map['uuid'];
    family = map['family'];
  }

// toJson method
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'chfid': chfid,
      'uuid': uuid,
      'family': family,
    };
  }


  factory InsureeInfo.fromJson(Map<String, dynamic> json) {
    return InsureeInfo(
        firstName: json['first_name'],
        lastName: json['last_name'],
        chfid: json['chfid'],
        uuid: json['uuid'],
        family: json['family']);
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['chfid'] = chfid;
    map['uuid'] = uuid;
    map['family'] = family;
    return map;
  }
}
