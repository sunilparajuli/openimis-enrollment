import 'dart:convert';
import '../../../data/remote/base/idto.dart';

class Hospital implements IDto {
  bool? success;
  List<HealthServiceProvider>? data;

  Hospital({
    this.success,
    this.data,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      success: json["success"],
      data: json["data"] != null
          ? List<HealthServiceProvider>.from(json["data"].map((x) => HealthServiceProvider.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data != null ? List<dynamic>.from(data!.map((x) => x.toJson())) : null,
  };
}

class HealthServiceProvider implements IDto {
  int? id;
  dynamic jsonExt;
  DateTime? validityFrom;
  dynamic validityTo;
  dynamic legacyId;
  String? uuid;
  String? code;
  String? name;
  String? accCode;
  String? level;
  String? address;
  String? phone;
  String? fax;
  String? email;
  String? careType;
  bool? offline;
  int? auditUserId;
  dynamic contractStartDate;
  dynamic contractEndDate;
  String? status;
  String? legalForm;
  dynamic subLevel;
  int? location;
  int? servicesPricelist;
  int? itemsPricelist;

  HealthServiceProvider({
    this.id,
    this.jsonExt,
    this.validityFrom,
    this.validityTo,
    this.legacyId,
    this.uuid,
    this.code,
    this.name,
    this.accCode,
    this.level,
    this.address,
    this.phone,
    this.fax,
    this.email,
    this.careType,
    this.offline,
    this.auditUserId,
    this.contractStartDate,
    this.contractEndDate,
    this.status,
    this.legalForm,
    this.subLevel,
    this.location,
    this.servicesPricelist,
    this.itemsPricelist,
  });

  factory HealthServiceProvider.fromJson(Map<String, dynamic> json) {
    return HealthServiceProvider(
      id: json["id"],
      jsonExt: json["json_ext"],
      validityFrom: json["validity_from"] != null ? DateTime.parse(json["validity_from"]) : null,
      validityTo: json["validity_to"],
      legacyId: json["legacy_id"],
      uuid: json["uuid"],
      code: json["code"],
      name: json["name"],
      accCode: json["acc_code"],
      level: json["level"],
      address: json["address"],
      phone: json["phone"],
      fax: json["fax"],
      email: json["email"],
      careType: json["care_type"],
      offline: json["offline"],
      auditUserId: json["audit_user_id"],
      contractStartDate: json["contract_start_date"],
      contractEndDate: json["contract_end_date"],
      status: json["status"],
      legalForm: json["legal_form"],
      subLevel: json["sub_level"],
      location: json["location"],
      servicesPricelist: json["services_pricelist"],
      itemsPricelist: json["items_pricelist"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "json_ext": jsonExt,
    "validity_from": validityFrom?.toIso8601String(),
    "validity_to": validityTo,
    "legacy_id": legacyId,
    "uuid": uuid,
    "code": code,
    "name": name,
    "acc_code": accCode,
    "level": level,
    "address": address,
    "phone": phone,
    "fax": fax,
    "email": email,
    "care_type": careType,
    "offline": offline,
    "audit_user_id": auditUserId,
    "contract_start_date": contractStartDate,
    "contract_end_date": contractEndDate,
    "status": status,
    "legal_form": legalForm,
    "sub_level": subLevel,
    "location": location,
    "services_pricelist": servicesPricelist,
    "items_pricelist": itemsPricelist,
  };
}
