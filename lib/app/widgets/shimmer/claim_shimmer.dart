import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openimis_app/app/widgets/shimmer/shimmer_widget.dart';

class ClaimResultsShimmer extends StatelessWidget {
  const ClaimResultsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,  // Number of shimmer items to display
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 5.h),
        child: Card(
          child: ListTile(
            // Shimmer effect for the title (code in your case)
            title: ShimmerWidget(
              width: 150.w,
              height: 20.h,  // height for the shimmer title
            ),
            // Shimmer effect for subtitle or secondary info (optional)
            subtitle: ShimmerWidget(
              width: 100.w,
              height: 16.h,  // smaller shimmer height for secondary text
            ),
            // Shimmer effect for leading icon or avatar (optional)
            // leading: ShimmerWidget(
            //   width: 40.w,
            //   height: 40.w,  // Shimmer for a circular avatar/icon
            //   //shapeBorder: const CircleBorder(),  // Circular shimmer shape
            // ),
          ),
        ),
      ),
    );
  }
}
