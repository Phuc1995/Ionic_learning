import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_management/presentation/page/follow_page/follow_page.dart';
import 'package:user_management/presentation/page/live_feed/live_feed_page.dart';
import 'package:user_management/presentation/page/user_info_page/user_info_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabModelDto {
  late TabItem tabItem;
  late Widget widget;
  TabModelDto({required this.tabItem, required this.widget});

  static TextStyle OPTION_STYPE = TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold);

  static List<TabModelDto> homeTabs = [
    TabModelDto(
        tabItem: TabItem(
          icon: Image(
            image: AssetImage("assets/images/tab_0.png"),
          ),
          activeIcon: Image(
            image: AssetImage("assets/images/tab_0s.png"),
          ),
        ),
        widget: LiveFeedSPage()
    ),
    TabModelDto(
        tabItem: TabItem(
          icon: Image(
            image: AssetImage("assets/images/tab_1.png"),
          ),
          activeIcon: Image(
            image: AssetImage("assets/images/tab_1s.png"),
          ),
        ),
        widget: Text(
          'Follow Page',
          style: OPTION_STYPE,
        )
    ),
    TabModelDto(
        tabItem: TabItem(
          icon: Image(
            image: AssetImage("assets/images/tab_2.png"),
          ),
          activeIcon: Image(
            image: AssetImage("assets/images/tab_2s.png"),
          ),
        ),
        widget: FlowingPage(),
    ),
    TabModelDto(
        tabItem: TabItem(
          icon: Image(
            image: AssetImage("assets/images/tab_3.png"),
          ),
          activeIcon: Image(
            image: AssetImage("assets/images/tab_3s.png"),
          ),
        ),
        widget: UserInfoPage(),
    ),
  ];
}
