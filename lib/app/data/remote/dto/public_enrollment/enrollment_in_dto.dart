import '../../base/idto.dart';

List<EnrollmentInDto> EnrollmentFromJson(List<dynamic> list) =>
    List<EnrollmentInDto>.from(list.map((x) => EnrollmentInDto.fromJson(x)));

class EnrollmentInDto implements IDto {
  EnrollmentInDto({
    this.id,
    this.company,
    this.position,
    this.employmentType,
    this.description,
    this.location,
    this.workplace,
    this.createdAt,
  });

  EnrollmentInDto.fromJson(dynamic json) {
    id = json['id'];
    company =
    json['company'] != null ? EnrollmentBrief.fromJson(json['company']) : null;
    position = json['position'];
    employmentType = json['employment_type'];
    description = json['description'];
    location = json['location'];
    workplace = json['workplace'];
    createdAt = json['created_at'];
  }

  String? id;
  EnrollmentBrief? company;
  dynamic position;
  dynamic employmentType;
  String? description;
  dynamic location;
  dynamic workplace;
  String? createdAt;

  EnrollmentInDto copyWith({
    String? id,
    EnrollmentBrief? company,
    dynamic position,
    dynamic employmentType,
    String? description,
    dynamic location,
    dynamic workplace,
    String? created,
  }) =>
      EnrollmentInDto(
        id: id ?? this.id,
        company: company ?? this.company,
        position: position ?? this.position,
        employmentType: employmentType ?? this.employmentType,
        description: description ?? this.description,
        location: location ?? this.location,
        workplace: workplace ?? this.workplace,
        createdAt: created ?? this.createdAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (company != null) {
      map['company'] = company?.toJson();
    }
    map['position'] = position;
    map['employment_type'] = employmentType;
    map['description'] = description;
    map['location'] = location;
    map['workplace'] = workplace;
    map['created_at'] = createdAt;
    return map;
  }
}

class EnrollmentBrief {
  EnrollmentBrief({
    this.id,
    this.name,
    this.image,
  });

  EnrollmentBrief.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  String? id;
  String? name;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    return map;
  }
}