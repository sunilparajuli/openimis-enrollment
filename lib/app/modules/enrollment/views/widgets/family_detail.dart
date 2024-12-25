import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../controller/enrollment_controller.dart';

class FamilyDetail extends StatelessWidget {
  dynamic family;
  final EnrollmentController enrollmentController;

  FamilyDetail({required this.family, required this.enrollmentController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'Family Information:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: Text('Head of Family: ${family['head_of_family']}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Address: ${family['address']}'),
              Text('Phone: ${family['phone']}'),
              Text('Family Size: ${family['family_size']}'),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
