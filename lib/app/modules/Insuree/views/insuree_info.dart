import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PatientInfoCard extends StatelessWidget {
  final String title;
  final String value;

  const PatientInfoCard({
    Key? key,
    required this.title,
    required this.value,
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
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
