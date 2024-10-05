import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/root_controller.dart';

class NoticesPage extends StatelessWidget {
  final RootController controller = Get.find<RootController>();

  NoticesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notices'.tr), // Changed from 'partners' to 'notices'
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final notices = controller.notices; // Changed from supportedPartners to notices
          return ListView.separated(
            itemCount: notices.length,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemBuilder: (context, index) {
              final notice = notices[index];
              return Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notice Title
                    Text(
                      notice['title'] ?? 'Untitled', // Use 'title' instead of 'name'
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Notice Description
                    Text(
                      notice['description'] ?? 'No description available', // Assuming 'description' field
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    // Optional Date or Metadata (if available)
                    Text(
                      notice['date'] ?? 'No date available', // Assuming 'date' field
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
