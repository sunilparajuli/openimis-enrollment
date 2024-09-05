import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openimis_app/app/modules/policy/controller/policy_controller.dart';
import '../../../search/views/widgets/items_card.dart'; // Ensure this is the correct path for SearchItem

class PolicyListPage extends StatelessWidget {
  final PolicyController controller = Get.put(PolicyController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final policies = controller.policies;
      return policies.isEmpty
          ? Center(child: Text('No policies found'))
          : ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: policies.length,
        itemBuilder: (context, index) {
          final policy = policies[index];
          return SearchItem(
            avatar: 'assets/avatar_placeholder.png', // Replace with actual avatar path or URL
            title: 'Policy ${policy['id']}',
            subtitle: 'CHFID: ${policy['headInsureeChfid']}\nReceipt No: ${policy['receiptNo']}',
            onTap: () {
              // Handle the tap event
            },
          );
        },
      );
    });
  }
}
