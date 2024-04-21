import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/constants/custom_icons.dart';
import 'package:user_management/constants/identityType.dart';
import 'package:user_management/presentation/widgets/icon_button_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputListBoxVerify2 extends StatefulWidget {

  final ValueChanged<String> onFileChanged;


  InputListBoxVerify2({
    Key? key,
    required this.onFileChanged,
  }) : super(key: key);

  @override
  _InputListBoxVerify2State createState() => _InputListBoxVerify2State();

}

class _InputListBoxVerify2State extends State<InputListBoxVerify2> {

  var _items = [
    {
      "isSelected": true,
      "buttonText": 'account_verify_identity'.tr,
      "type": IdentityType.identityCard,
      'icon': CustomIcons.cccd
    },
    {
      "isSelected": false,
      "buttonText": 'account_verify_passport'.tr,
      "type": IdentityType.passport,
      'icon': CustomIcons.passport_outline
    },
    {
      "isSelected": false,
      "buttonText": 'account_verify_driver'.tr,
      "type": IdentityType.driverLicense,
      'icon': CustomIcons.driver_lic
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: List.generate(_items.length, (index) {
          return _buildInputBox(_items[index], index);
        }),
      ),
    );
  }

  Widget _buildInputBox(_item, index) {
    return new InkWell(
        onTap: () {
          setState(() {
            _items.forEach((element) => element["isSelected"] = false);
            _items[index]["isSelected"] = true;
            widget.onFileChanged(_items[index]["type"].toString());
          });
        },
        child: new Container(
          margin: new EdgeInsets.all(7.5),
          padding: EdgeInsets.fromLTRB(30.w, 17.h, 21.w, 17.h),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  color: _item['isSelected'] ? AppColors.pinkLiveButtonCustom : Colors.transparent),
              borderRadius: BorderRadius.circular(40.r),
              color: _item['isSelected'] ? Colors.white : Colors.black12),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(children: [
                Icon(_item['icon'],
                    color: _item['isSelected'] ? AppColors.pinkLiveButtonCustom : Colors.black54),
                SizedBox(width: 18.w),
                new Text(
                  (_item['buttonText']),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18.sp,
                    color: _item['isSelected'] ? AppColors.pinkLiveButtonCustom : Colors.black87,
                  ),
                ),
              ]),
              _item['isSelected']
                  ? IconButtonWidget(
                      buttonColor: AppColors.pinkGradientButton,
                      onPressed: () {},
                      icon: Icons.check,
                      iconSize: 18.sp,
                      width: 24.w,
                      height: 24.h,
                    )
                  : Container(),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
