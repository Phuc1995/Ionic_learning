import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_management/constants/custom_icons.dart';

class ToolbarWidget extends StatelessWidget {
  final ScrollController toolbarScrollController;
  ToolbarWidget(ScrollController this.toolbarScrollController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Container(
            height: 54.h,
            width: MediaQuery.of(context).size.width - 150.h,
            child: FadingEdgeScrollView.fromScrollView(
              gradientFractionOnStart: 0.8,
              gradientFractionOnEnd: 0.7,
              child: ListView(
                controller: toolbarScrollController,
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  TextButton(
                    child: Text('Phổ biến', style: TextStyle(color: Colors.white, fontSize: 18.sp),),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Gần đây', style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Hẹn hò', style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                    onPressed: () {},
                  ),
                  TextButton(
                    child: Text('Trò chơi', style: TextStyle(color: Colors.white, fontSize: 16.sp),),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildActions(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      _buildCrownButton(),
      _buildSearchButton(),
      _buildNotificationButton(),
    ];
  }

  Widget _buildCrownButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        CustomIcons.crown,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSearchButton() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.search,
        color: Colors.white,
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        IconButton(
          onPressed: () {
          },
          icon: Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
        ),
        Positioned(
          top: 18.0.h,
          right: 16.r,
          width: 8.0.w,
          height: 8.0.h,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE80000),
            ),
          ),
        )
      ],
    );
  }
}
