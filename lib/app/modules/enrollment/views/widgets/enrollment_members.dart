import 'package:flutter/material.dart';
import 'dart:convert';

import '../../../../utils/database_helper.dart';

class EnrollmentDetailsPage extends StatelessWidget {
  final int enrollmentId;

  EnrollmentDetailsPage({required this.enrollmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enrollment Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: DatabaseHelper().getEnrollmentById(enrollmentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('No data found'));
          }

          final enrollment = snapshot.data!;
          final family = jsonDecode(enrollment['json_content']);
          final members = family['members'] as List;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CHFID: ${enrollment['chfid']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Sync Status: ${enrollment['sync'] == 1 ? 'Synced' : 'Not Synced'}'),
                SizedBox(height: 20),
                Text('Family Information:'),
                ...members.map((member) => ListTile(
                  title: Text('Member Name: ${member['givenName']} ${member['lastName']}'),
                  subtitle: Text('Phone: ${member['phone']}'),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
