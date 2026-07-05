import 'package:flutter/material.dart';
import '../../controller/enrollment_controller.dart';

class FamilyDetail extends StatelessWidget {
  final dynamic family;
  final EnrollmentController enrollmentController;

  FamilyDetail({super.key, required this.family, required this.enrollmentController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
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
        const SizedBox(height: 20),
      ],
    );
  }
}
