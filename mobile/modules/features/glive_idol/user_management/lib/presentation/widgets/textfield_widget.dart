import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidget extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hint;
  final String? errorText;
  final TextStyle? errorStyle;
  final bool isObscure;
  final TextInputType? inputType;
  final TextEditingController textController;
  final EdgeInsets padding;
  final Color hintColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;
  final TextStyle? style;
  final int? maxLength;
  final Color? fillColor;
  final bool filled;
  final EdgeInsetsGeometry? contentPadding;
  final GestureTapCallback? onTap;
  final bool readOnly;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final BorderRadius? radiusCustom;
  final bool? maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        maxLines: maxLines! ? null: 1,
        onTap: onTap,
        controller: textController,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        autofocus: autoFocus,
        textInputAction: inputAction,
        obscureText: this.isObscure,
        maxLength: maxLength,
        readOnly: readOnly,
        keyboardType: this.inputType,
        inputFormatters: inputFormatters,
        style: style ?? Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
            filled: this.filled,
            contentPadding: this.contentPadding,
            fillColor: this.fillColor,
            prefixIcon: this.prefixIcon,
            suffixIcon: this.suffixIcon,
            hintText: this.hint,
            hintStyle:
                Theme.of(context).textTheme.bodyText1!.copyWith(color: hintColor),
            errorText: errorText,
            errorStyle: errorStyle,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: this.radiusCustom ?? BorderRadius.circular(50.r),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
        ),
        validator: validator,
      ),
    );
  }

  const TextFieldWidget({
    Key? key,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.errorStyle,
    required this.textController,
    this.inputType,
    this.hint,
    this.isObscure = false,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
    this.style,
    this.maxLength,
    this.contentPadding,
    this.fillColor = const Color(0xFFF6F6F6),
    this.filled = false,
    this.onTap,
    this.readOnly = false,
    this.validator,
    this.inputFormatters,
    this.radiusCustom,
    this.maxLines = false,
  }) : super(key: key);
}
