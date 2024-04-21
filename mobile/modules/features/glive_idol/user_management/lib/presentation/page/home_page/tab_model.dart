import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabModel {
  late TabItem tabItem;
  late Widget widget;
  TabModel({required this.tabItem, required this.widget});

  static TextStyle textStyle = TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold);

  static List<TabModel> homeTabs = [
    TabModel(
        tabItem: TabItem(
          icon: Image(
            image: AssetImage("assets/images/tab_0.png"),
          ),
          activeIcon: Image(
            image: AssetImage("assets/images/tab_0s.png"),
          ),
        ),
        widget: Container()
    ),
    TabModel(
        tabItem: TabItem(
          icon: Image(
            image: AssetImage("assets/images/tab_1.png"),
          ),
          activeIcon: Image(
            image: AssetImage("assets/images/tab_1s.png"),
          ),
        ),
        widget: Text(
          'Discover Page',
          style: textStyle,
        )
    ),
    TabModel(
        tabItem: TabItem(
          icon: Icon(
            CustomIcons.live,
            size: 20,
            color: Colors.white,
          ),
        ),
        widget: Container()
    ),
    TabModel(
        tabItem: TabItem(
          icon: Image(
            image: AssetImage("assets/images/tab_2.png"),
          ),
          activeIcon: Image(
            image: AssetImage("assets/images/tab_2s.png"),
          ),
        ),
        widget: Text(
          'Follow Page',
          style: textStyle,
        )
    ),
    TabModel(
        tabItem: TabItem(
          icon: Image(
            image: AssetImage("assets/images/tab_3.png"),
          ),
          activeIcon: Image(
            image: AssetImage("assets/images/tab_3s.png"),
          ),
        ),
        widget: Text(
          'Smile Page',
          style: textStyle,
        )
    ),
  ];
}
