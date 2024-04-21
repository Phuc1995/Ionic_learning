import 'package:common_module/common_module.dart';
import 'package:common_module/utils/firebase/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FollowCount extends StatelessWidget {
  final String roomId;

  const FollowCount({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int viewCount = 0;
    return StreamBuilder(
      stream: FirebaseStorage.getFollow(roomId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value != null) {
          viewCount = snapshot.data.snapshot.value;
        }
        return Container(
          child: Row(
            children: [
              Container(
                child: Text(
              ConvertCommon().convertViewCount(viewCount.toString()) + " " +"live_follow".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}
