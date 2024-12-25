import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FamilyMemberDetails extends StatelessWidget {
  final List<Map<String, dynamic>> families;

  const FamilyMemberDetails({required this.families});

  @override
  Widget build(BuildContext context) {
    int totalMembers = families.fold(
      0,
          (sum, family) => sum + (family['members'] as List).length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Family Members: $totalMembers',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Service Point', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Policy Status', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ]),
            ...families.expand((family) => family['members'].map<TableRow>((member) {
              return TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member['fullname']),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member['date_of_birth']),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member['insuree_gender']),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member['first_service_point']),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member['policy_status']),
                ),
              ]);
            }).toList()).toList(),
          ],
        ),
      ],
    );
  }
}
