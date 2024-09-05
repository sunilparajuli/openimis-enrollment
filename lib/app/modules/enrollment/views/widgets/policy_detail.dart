import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/remote/dto/search/search_out_dto.dart';

class PolicyDetails extends StatelessWidget {
  final List<PolicyDto> policies;

  const PolicyDetails({required this.policies});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Policies (${policies.length})',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Enrollment Date', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Start Date', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Effective Date', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Expiry Date', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Policy Status', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ]),
            ...policies.map((policy) => TableRow(children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(policy.enrollmentDate?.toString() ?? "N/A"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(policy.startDate?.toString() ?? "N/A"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(policy.effectiveDate?.toString() ?? 'N/A'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(policy.expiryDate?.toString() ?? "N/A"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(policy!.policyStatus ?? 'NA'),
              ),
            ])),
          ],
        ),
      ],
    );
  }
}
