import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarCommonWidget{

  AppBar build(String title, Function onPressed, {Widget? action, isShowBack = true }){
    return AppBar(
      automaticallyImplyLeading: isShowBack,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      brightness: Brightness.light,
      title: Container(
        child: Text(title.tr,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),),
      ),
      leading: isShowBack ? IconButton(
        iconSize: 24.sp,
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => onPressed()
      ) : Container(),
      actions: [
        action ?? Container()
      ],
    );
  }
}
