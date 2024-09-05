import '../../../data/remote/base/idto.dart';

class LocationDto implements IDto {
  int? id;
  String? uuid;
  String? code;
  String? name;
  String? type;
  dynamic malePopulation;
  dynamic femalePopulation;
  dynamic otherPopulation;
  dynamic families;
  District? district;
  Municipality? municipality;
  Village? village;

  LocationDto({
    this.id,
    this.uuid,
    this.code,
    this.name,
    this.type,
    this.malePopulation,
    this.femalePopulation,
    this.otherPopulation,
    this.families,
    this.district,
    this.municipality,
    this.village,
  });

  LocationDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    code = json['code'];
    name = json['name'];
    type = json['type'];
    malePopulation = json['male_population'];
    femalePopulation = json['female_population'];
    otherPopulation = json['other_population'];
    families = json['families'];
    district = json['district'] != null ? District.fromJson(json['district']) : null;
    municipality = json['Municipality'] != null ? Municipality.fromJson(json['Municipality']) : null;
    village = json['Village'] != null ? Village.fromJson(json['Village']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['code'] = code;
    map['name'] = name;
    map['type'] = type;
    map['male_population'] = malePopulation;
    map['female_population'] = femalePopulation;
    map['other_population'] = otherPopulation;
    map['families'] = families;
    if (district != null) {
      map['district'] = district!.toJson();
    }
    if (municipality != null) {
      map['Municipality'] = municipality!.toJson();
    }
    if (village != null) {
      map['Village'] = village!.toJson();
    }
    return map;
  }
}

class District {
  int? id;
  String? uuid;
  String? code;
  String? name;
  String? type;
  dynamic malePopulation;
  dynamic femalePopulation;
  dynamic otherPopulation;
  dynamic families;

  District({
    this.id,
    this.uuid,
    this.code,
    this.name,
    this.type,
    this.malePopulation,
    this.femalePopulation,
    this.otherPopulation,
    this.families,
  });

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    code = json['code'];
    name = json['name'];
    type = json['type'];
    malePopulation = json['male_population'];
    femalePopulation = json['female_population'];
    otherPopulation = json['other_population'];
    families = json['families'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['code'] = code;
    map['name'] = name;
    map['type'] = type;
    map['male_population'] = malePopulation;
    map['female_population'] = femalePopulation;
    map['other_population'] = otherPopulation;
    map['families'] = families;
    return map;
  }
}

class Municipality {
  int? id;
  String? uuid;
  String? code;
  String? name;
  String? type;
  dynamic malePopulation;
  dynamic femalePopulation;
  dynamic otherPopulation;
  dynamic families;

  Municipality({
    this.id,
    this.uuid,
    this.code,
    this.name,
    this.type,
    this.malePopulation,
    this.femalePopulation,
    this.otherPopulation,
    this.families,
  });

  Municipality.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    code = json['code'];
    name = json['name'];
    type = json['type'];
    malePopulation = json['male_population'];
    femalePopulation = json['female_population'];
    otherPopulation = json['other_population'];
    families = json['families'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['code'] = code;
    map['name'] = name;
    map['type'] = type;
    map['male_population'] = malePopulation;
    map['female_population'] = femalePopulation;
    map['other_population'] = otherPopulation;
    map['families'] = families;
    return map;
  }
}

class Village {
  int? id;
  String? uuid;
  String? code;
  String? name;
  String? type;
  dynamic malePopulation;
  dynamic femalePopulation;
  dynamic otherPopulation;
  dynamic families;

  Village({
    this.id,
    this.uuid,
    this.code,
    this.name,
    this.type,
    this.malePopulation,
    this.femalePopulation,
    this.otherPopulation,
    this.families,
  });

  Village.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    code = json['code'];
    name = json['name'];
    type = json['type'];
    malePopulation = json['male_population'];
    femalePopulation = json['female_population'];
    otherPopulation = json['other_population'];
    families = json['families'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['code'] = code;
    map['name'] = name;
    map['type'] = type;
    map['male_population'] = malePopulation;
    map['female_population'] = femalePopulation;
    map['other_population'] = otherPopulation;
    map['families'] = families;
    return map;
  }
}
