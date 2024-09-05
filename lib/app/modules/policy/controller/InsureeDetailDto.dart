import 'package:openimis_app/app/data/remote/base/idto.dart';

class InsureeDetailsDto implements IDto {
  InsureeDetailsDto({
    this.success,
    this.data,
  });

  InsureeDetailsDto.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? DataDto.fromJson(json['data']) : null;
  }

  bool? success;
  DataDto? data;

  InsureeDetailsDto copyWith({
    bool? success,
    DataDto? data,
  }) =>
      InsureeDetailsDto(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}

class DataDto {
  DataDto({
    this.insuree,
    this.families,
    this.policy,
  });

  DataDto.fromJson(Map<String, dynamic> json) {
    insuree = json['insuree'] != null ? InsureeDto.fromJson(json['insuree']) : null;
    if (json['families'] != null) {
      families = List<FamilyDto>.from(json['families'].map((x) => FamilyDto.fromJson(x)));
    }
    if (json['policy'] != null) {
      policy = List<PolicyDto>.from(json['policy'].map((x) => PolicyDto.fromJson(x)));
    }
  }

  InsureeDto? insuree;
  List<FamilyDto>? families;
  List<PolicyDto>? policy;

  DataDto copyWith({
    InsureeDto? insuree,
    List<FamilyDto>? families,
    List<PolicyDto>? policy,
  }) =>
      DataDto(
        insuree: insuree ?? this.insuree,
        families: families ?? this.families,
        policy: policy ?? this.policy,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (insuree != null) {
      map['insuree'] = insuree!.toJson();
    }
    if (families != null) {
      map['families'] = families!.map((x) => x.toJson()).toList();
    }
    if (policy != null) {
      map['policy'] = policy!.map((x) => x.toJson()).toList();
    }
    return map;
  }
}

class FamilyDto {
  FamilyDto({
    this.members,
  });

  FamilyDto.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = List<InsureeDto>.from(json['members'].map((x) => InsureeDto.fromJson(x)));
    }
  }

  List<InsureeDto>? members;

  FamilyDto copyWith({
    List<InsureeDto>? members,
  }) =>
      FamilyDto(
        members: members ?? this.members,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (members != null) {
      map['members'] = members!.map((x) => x.toJson()).toList();
    }
    return map;
  }
}

class InsureeDto {
  InsureeDto({
    this.fullname,
    this.chfId,
    this.dateOfBirth,
    this.insureeGender,
    this.firstServicePoint,
    this.districtFsp,
    this.photo,
    this.policyStatus,
    this.latestPolicy,
  });

  InsureeDto.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    chfId = json['chf_id'];
    dateOfBirth = json['date_of_birth'];
    insureeGender = json['insuree_gender'];
    firstServicePoint = json['first_service_point'];
    districtFsp = json['district_fsp'];
    photo = json['photo'];
    policyStatus = json['policy_status'];
    latestPolicy = json['latest_policy'] != null ? PolicyDto.fromJson(json['latest_policy']) : null;
  }

  String? fullname;
  String? chfId;
  String? dateOfBirth;
  String? insureeGender;
  String? firstServicePoint;
  String? districtFsp;
  String? photo;
  String? policyStatus;
  PolicyDto? latestPolicy;

  InsureeDto copyWith({
    String? fullname,
    String? chfId,
    String? dateOfBirth,
    String? insureeGender,
    String? firstServicePoint,
    String? districtFsp,
    String? photo,
    String? policyStatus,
    PolicyDto? latestPolicy,
  }) =>
      InsureeDto(
        fullname: fullname ?? this.fullname,
        chfId: chfId ?? this.chfId,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        insureeGender: insureeGender ?? this.insureeGender,
        firstServicePoint: firstServicePoint ?? this.firstServicePoint,
        districtFsp: districtFsp ?? this.districtFsp,
        photo: photo ?? this.photo,
        policyStatus: policyStatus ?? this.policyStatus,
        latestPolicy: latestPolicy ?? this.latestPolicy,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fullname'] = fullname;
    map['chf_id'] = chfId;
    map['date_of_birth'] = dateOfBirth;
    map['insuree_gender'] = insureeGender;
    map['first_service_point'] = firstServicePoint;
    map['district_fsp'] = districtFsp;
    map['photo'] = photo;
    map['policy_status'] = policyStatus;
    if (latestPolicy != null) {
      map['latest_policy'] = latestPolicy!.toJson();
    }
    return map;
  }
}

class PolicyDto {
  PolicyDto({
    this.enrollmentDate,
    this.startDate,
    this.effectiveDate,
    this.expiryDate,
    this.policyStatus,
  });

  PolicyDto.fromJson(Map<String, dynamic> json) {
    enrollmentDate = DateTime.parse(json['enrollment_date']);
    startDate = DateTime.parse(json['start_date']);
    effectiveDate = json['effective_date'];
    expiryDate = DateTime.parse(json['expiry_date']);
    policyStatus = json['policy_status'];
  }

  DateTime? enrollmentDate;
  DateTime? startDate;
  dynamic effectiveDate;
  DateTime? expiryDate;
  String? policyStatus;

  PolicyDto copyWith({
    DateTime? enrollmentDate,
    DateTime? startDate,
    dynamic effectiveDate,
    DateTime? expiryDate,
    String? policyStatus,
  }) =>
      PolicyDto(
        enrollmentDate: enrollmentDate ?? this.enrollmentDate,
        startDate: startDate ?? this.startDate,
        effectiveDate: effectiveDate ?? this.effectiveDate,
        expiryDate: expiryDate ?? this.expiryDate,
        policyStatus: policyStatus ?? this.policyStatus,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['enrollment_date'] = "${enrollmentDate?.year.toString().padLeft(4, '0')}-${enrollmentDate?.month.toString().padLeft(2, '0')}-${enrollmentDate?.day.toString().padLeft(2, '0')}";
    map['start_date'] = "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}";
    map['effective_date'] = effectiveDate;
    map['expiry_date'] = "${expiryDate?.year.toString().padLeft(4, '0')}-${expiryDate?.month.toString().padLeft(2, '0')}-${expiryDate?.day.toString().padLeft(2, '0')}";
    map['policy_status'] = policyStatus;
    return map;
  }
}
