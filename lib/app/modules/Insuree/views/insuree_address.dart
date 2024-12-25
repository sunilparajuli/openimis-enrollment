import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PatientAddressCard extends StatelessWidget {
  final String addressText;
  final String city;
  final String district;
  final String state;

  const PatientAddressCard({
    Key? key,
    required this.addressText,
    required this.city,
    required this.district,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Text(addressText),
            Text("$city, $district, $state"),
          ],
        ),
      ),
    );
  }
}
