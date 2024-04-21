import 'package:flutter/material.dart';
import 'package:user_management/constants/assets.dart';
import 'package:get/get.dart';
import 'package:user_management/presentation/controller/user/account_verify_store_controller.dart';
import 'package:common_module/presentation/widget/icon/app_icon_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContryDropdown extends StatelessWidget {
  final AccountVerifyStoreController accountVerifyStoreController;
  const ContryDropdown({Key? key, required this.accountVerifyStoreController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _locations = ['VN'];
    var _selectedLocation = 'VN'.obs;
    accountVerifyStoreController.countryController.value = 'VN';
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      InputDecorator(
        decoration: InputDecoration(
          fillColor: Color(0xFFF6F6F6),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            isExpanded: true,
            items: _locations.map((location) {
              return DropdownMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppIconWidget(
                      image: Assets.vnFlag,
                      size: 15.sp,
                      height: 20.h,
                    ),
                    Text(
                      ' ' + 'vietnam',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      ' ' + '(Viet Nam)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontSize: 16.sp,
                      ),
                    )
                  ],
                ),
                value: location,
              );
            }).toList(),
            onChanged: (newValue) {
                _selectedLocation.value = newValue.toString();
                accountVerifyStoreController.countryController.value = newValue!;
            },
            value: _selectedLocation.value,
          ),
        ),
      ),
    ]);;
  }
}

