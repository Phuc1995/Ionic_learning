import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneFieldWidget extends StatelessWidget {
  final TextEditingController? textController;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged<PhoneNumber>? onChanged;
  final ValueChanged<PhoneNumber>? onCountryChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;
  final String? hint;
  final String errorText;
  final TextStyle? errorStyle;
  final EdgeInsets padding;
  final Color hintColor;
  final TextStyle? style;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final BorderRadius? radiusCustom;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16.h),
          padding: this.contentPadding,
          decoration: BoxDecoration(
              color: this.fillColor,
              borderRadius: this.radiusCustom ?? BorderRadius.circular(50.r)),
          child: IntlPhoneField(
            searchText: 'login_et_phone_search'.tr,
            showDropdownIcon: false,
            initialCountryCode: 'VN',
            dropdownDecoration: BoxDecoration(
                color: this.fillColor,
                borderRadius: this.radiusCustom ?? BorderRadius.circular(50.r)),
            style: this.style,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              counterText: '',
              hintText: hint??'login_et_user_phone'.tr,
              hintStyle: TextUtils.textStyle(FontWeight.w500, 15.sp,
                  color: hintColor),
              border: OutlineInputBorder(
                borderRadius: this.radiusCustom ?? BorderRadius.circular(50.r),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
            ),
            controller: this.textController,
            keyboardType: this.inputType ?? TextInputType.number,
            validator: this.validator,
            onChanged: this.onChanged,
            onCountryChanged: this.onCountryChanged,
            onSubmitted: this.onFieldSubmitted,
            autofocus: this.autoFocus,
            enabled: !this.readOnly,
            textInputAction: this.inputAction,
            focusNode: focusNode,
          ),
        ),
        Visibility(
            visible: errorText.isNotEmpty,
            child: Container(
              margin: EdgeInsets.only(top: 8.h, left: 16.w),
              child: Text(
                errorText,
                style: errorStyle,
              ),
            )),
      ],
    );
  }

  const PhoneFieldWidget({
    Key? key,
    this.focusNode,
    this.textController,
    this.inputType,
    this.readOnly = false,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.onCountryChanged,
    this.autoFocus = false,
    this.inputAction,
    this.errorText = '',
    this.errorStyle,
    this.hint,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.black38,
    this.style,
    this.contentPadding,
    this.fillColor = const Color(0xFFF6F6F6),
    this.filled = false,
    this.inputFormatters,
    this.radiusCustom,
  }) : super(key: key);
}
