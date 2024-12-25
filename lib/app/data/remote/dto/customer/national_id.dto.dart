import '../../base/idto.dart';

class NationalID implements IDto {
  final String? nationalId;
  final String? firstname;
  final String? lastname;
  final int? age;
  final String? address;
  final String? gender;       // Added gender
  final String? birthdate;    // Added birthdate
  final bool? isHead;         // Added isHead (true/false)
  final String? phone;        // Added phone
  final String? email;        // Added email

  // Constructor
  NationalID({
    this.nationalId,
    this.firstname,
    this.lastname,
    this.age,
    this.address,
    this.gender,
    this.birthdate,
    this.isHead,
    this.phone,
    this.email,
  });

  // Factory method to create a NationalID object from JSON
  factory NationalID.fromJson(Map<String, dynamic> json) {
    return NationalID(
      nationalId: json['national_id'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      age: json['age'] as int?,
      address: json['address'] as String?,
      gender: json['gender'] as String?,
      birthdate: json['birthdate'] as String?,
      isHead: json['is_head'] as bool?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  // Method to convert a NationalID object to JSON
  Map<String, dynamic> toJson() {
    return {
      'national_id': nationalId,
      'firstname': firstname,
      'lastname': lastname,
      'age': age,
      'address': address,
      'gender': gender,
      'birthdate': birthdate,
      'is_head': isHead,
      'phone': phone,
      'email': email,
    };
  }
}
