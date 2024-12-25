import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String photoUrl;
  final String gender;
  final String birthDate;

  const ProfileHeader({
    Key? key,
    required this.name,
    required this.photoUrl,
    required this.gender,
    required this.birthDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(photoUrl),
          radius: 50,
        ),
        SizedBox(height: 16),
        Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("$gender, Born on $birthDate"),
      ],
    );
  }
}
