import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_management/presentation/widgets/tag_pill.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagBottomSheet extends StatelessWidget {

  final StateSetter setStateModal;

  final List<String> tags;

  final Function() onPressed;

  const TagBottomSheet({
    Key? key,
    required this.setStateModal,
    required this.tags,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500.h,
      child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Column(
            children: [
              _buildModalTitle(),
              _buildListTag(),
              _buildButtonModal(context),
            ],
          )),
    );
  }

  Widget _buildListTag() {
    List<Widget> widgets = [
      TagPill(
        tag: 'live_suggest_topics'.tr,
        onPressed: () => null,
        colorFill: Colors.transparent,
        horizontal: 0,
      )
    ];
    widgets.addAll(
      List.generate(Strings.TAGS.length, (index) {
        final item = Strings.TAGS[index];
        bool isSelected = tags.contains(item);
        return TagPill(
          vertical: 10.h,
          tag: item.toString().tr,
          colorFill: isSelected ? AppColors.pink[400] : null,
          style: TextStyle(color: isSelected ? Colors.white : null),
          onPressed: () => {
            if (!this.tags.contains(item.toString())) {
              if (this.tags.length < 1) {
                setStateModal(() {
                  this.tags.add(item.toString());
                })
              }
              else {
                Fluttertoast.showToast(msg: 'live_max_tag_error'.tr)
              }
            }
            else {
              setStateModal(() {
                this.tags.remove(item.toString());
              })
            }
          },
        );
        }
      )
    );
    return Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 12,
        spacing: 12,
        children: widgets,
    );
  }

  Widget _buildModalTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
      child: Text(
        'live_select_tag'.tr,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildButtonModal(context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
      width: MediaQuery.of(context).size.width * 0.6,
      child: RoundedButtonGradientWidget(
        textSize: 16.sp,
        buttonText: 'button_confirm'.tr,
        buttonColor: AppColors.pinkGradientButton,
        textColor: Colors.white,
        width: double.infinity,
        height: 60.h,
        onPressed: this.onPressed,
      ),
    );
  }
}
