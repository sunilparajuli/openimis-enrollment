import 'package:openimis_app/app/data/remote/base/idto.dart';

class FHIRPatient implements IDto {
  final String ? id;
  final bool? isHead; // Made optional
  final bool? cardIssued; // Made optional
  final String? groupReference; // Made optional
  final String? identifierCode; // Made optional
  final String? identifierUUID; // Made optional
  final String? familyName; // Made optional
  final List<String>? givenNames; // Made optional
  final String? gender; // Made optional
  final String? birthDate; // Made optional
  final String? addressText; // Made optional
  final String? city; // Made optional
  final String? district; // Made optional
  final String? state; // Made optional
  final String? maritalStatus; // Made optional
  final String? photoUrl; // Made optional

  FHIRPatient({
    required this.id, // Keep `id` as required if it's critical
    this.isHead,
    this.cardIssued,
    this.groupReference,
    this.identifierCode,
    this.identifierUUID,
    this.familyName,
    this.givenNames,
    this.gender,
    this.birthDate,
    this.addressText,
    this.city,
    this.district,
    this.state,
    this.maritalStatus,
    this.photoUrl,
  });

  factory FHIRPatient.fromJson(Map<String, dynamic> json) {
    return FHIRPatient(
      id: json['id'],
      isHead: json['extension']?[0]['valueBoolean'], // Default is null
      cardIssued: json['extension']?[1]['valueBoolean'], // Default is null
      groupReference: json['extension']?[2]['valueReference']['reference'], // Default is null
      identifierCode: json['identifier']?[1]['value'], // Default is null
      identifierUUID: json['identifier']?[0]['value'], // Default is null
      familyName: json['name']?[0]['family'], // Default is null
      givenNames: json['name']?[0]['given'] != null
          ? List<String>.from(json['name'][0]['given'])
          : null,
      gender: json['gender'], // Default is null
      birthDate: json['birthDate'], // Default is null
      addressText: json['address']?[0]['text'], // Default is null
      city: json['address']?[0]['city'], // Default is null
      district: json['address']?[0]['district'], // Default is null
      state: json['address']?[0]['state'], // Default is null
      maritalStatus: json['maritalStatus']?['coding']?[0]['display'], // Default is null
      photoUrl: json['photo']?[0]['url'], // Default is null
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isHead': isHead,
      'cardIssued': cardIssued,
      'groupReference': groupReference,
      'identifierCode': identifierCode,
      'identifierUUID': identifierUUID,
      'familyName': familyName,
      'givenNames': givenNames,
      'gender': gender,
      'birthDate': birthDate,
      'addressText': addressText,
      'city': city,
      'district': district,
      'state': state,
      'maritalStatus': maritalStatus,
      'photoUrl': photoUrl,
    };
  }
}
