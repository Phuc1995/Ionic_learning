import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProgressIndicatorWidget extends StatelessWidget {
  const CustomProgressIndicatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 80.h,
        constraints: BoxConstraints.expand(),
        child: SizedBox(
          height: 80.h,
          width: 80.w,
          child: Center(
            child: Image.asset('assets/icons/loading.gif', width: 80.h, height: 80.w,),
          ),
        ),
        decoration: BoxDecoration(
            color: Color.fromARGB(100, 105, 105, 105)),
      ),
    );
  }
}
