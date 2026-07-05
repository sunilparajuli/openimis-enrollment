import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class InstructionCard extends StatelessWidget {
  const InstructionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search, // Magnifier glass icon
                  size: 48.0, // Big size
                  color: Colors.blue,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    'search_instruction'.tr,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 16.0),
                const Icon(
                  Icons.qr_code_scanner, // QR icon
                  size: 48.0, // Big size
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

