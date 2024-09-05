import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/remote/dto/search/search_out_dto.dart';

class FamilyMemberDetails extends StatelessWidget {
  final List<FamilyDto> families;

  const FamilyMemberDetails({required this.families});

  @override
  Widget build(BuildContext context) {
    int totalMembers = families.fold(
      0,
          (sum, family) => sum + (family.members!.length ?? 0),
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
            ...families.expand((family) => family.members?.map<TableRow>((member) {
              return TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member.fullname ?? 'N/A'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member.dateOfBirth ?? 'N/A'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member.insureeGender ?? 'N/A'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member.firstServicePoint ?? 'N/A'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(member.policyStatus ?? 'N/A'),
                ),
              ]);
            }).toList() ?? []),
          ],
        ),
      ],
    );
  }
}
