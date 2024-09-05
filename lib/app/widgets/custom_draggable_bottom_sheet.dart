import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DraggableBottomSheet extends StatelessWidget {
  const DraggableBottomSheet({Key? key, required this.body}) : super(key: key);
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (BuildContext context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            
              SliverList.list(children:  [
                body
              ])
            ],
          ),
        );
      },
    );
  }
}
