import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OpenIMISAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabController? tabController;
  final RxInt? selectedTabIndex;
  final bool showActions;
  final List<Tab>? tabs;
  final List<Widget>? actions; // Accept list of widgets directly

  const OpenIMISAppBar({
    Key? key,
    required this.title,
    this.tabController,
    this.selectedTabIndex,
    this.showActions = true,
    this.tabs,
    this.actions, // Initialize actions parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/imis-gif.gif',
            height: 80,
          ),
          const SizedBox(width: 5),
          Text(title),
        ],
      ),
      actions: showActions && selectedTabIndex != null
          ? actions ?? [] // Use actions passed from the page, or an empty list
          : null,
      bottom: tabController != null && tabs != null
          ? TabBar(
        controller: tabController,
        tabs: tabs!,
      )
          : null,
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}
