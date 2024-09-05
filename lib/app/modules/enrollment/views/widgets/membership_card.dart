import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MembershipCard extends StatelessWidget {
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String firstServicePoint;
  final String policyStatus;
  final String photoUrl;
  final String qrCodeData;
  final String logoUrl;

  MembershipCard({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.firstServicePoint,
    required this.policyStatus,
    required this.photoUrl,
    required this.qrCodeData,
    required this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 2.0,
      margin: EdgeInsets.all(2.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Flexible(  // Use Flexible here to allow resizing
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      logoUrl,
                      width: 100.0,
                      height: 50.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    dateOfBirth,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Gender: $gender',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Service Point: $firstServicePoint',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Policy Status: $policyStatus',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    photoUrl,
                    width: 80.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16.0),
                QrImageView(
                  data: qrCodeData,
                  version: QrVersions.auto,
                  size: 100.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
