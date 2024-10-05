class FamilyType {
  final String name;
  final String code;

  FamilyType({required this.name, required this.code});

  factory FamilyType.fromJson(Map<String, dynamic> json) {
    return FamilyType(
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }
}

class ConfirmationType {
  final String name;
  final String code;

  ConfirmationType({required this.name, required this.code});

  factory ConfirmationType.fromJson(Map<String, dynamic> json) {
    return ConfirmationType(
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
    };
  }
}
