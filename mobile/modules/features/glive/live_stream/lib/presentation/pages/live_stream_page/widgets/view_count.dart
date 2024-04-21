import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewCount extends StatelessWidget {
  final String roomId;

  const ViewCount({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int viewCount = 0;
    return StreamBuilder(
      stream: FirebaseStorage.getViewCount(roomId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
          viewCount = snapshot.data.snapshot.value;
        }
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.black12.withOpacity(0.2),
            borderRadius: BorderRadius.all(
              Radius.circular(25.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 14.sp,
                  color: Colors.white,
                ),
                Container(
                  child: Text(
                    ConvertCommon().convertViewCount(viewCount.toString()),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
