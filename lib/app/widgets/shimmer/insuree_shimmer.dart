import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openimis_app/app/widgets/shimmer/shimmer_widget.dart';

class InsureeShimmer extends StatelessWidget {
  const InsureeShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 2.w),
        child: ShimmerWidget(
          width: double.infinity,
          height: 250.h,
        ),
      ),
    );
  }
}
