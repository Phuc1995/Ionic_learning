import 'package:flutter/material.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FriendButton extends StatelessWidget {
  const FriendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        CustomIcons.addfriend,
        color: Colors.white,
        size: 26.sp,
      ),
    );
  }
}