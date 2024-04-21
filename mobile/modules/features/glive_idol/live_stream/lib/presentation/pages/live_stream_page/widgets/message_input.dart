import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController textController;

  final Function? onSend;

  final FocusNode? focusNode;

  const MessageInput({
    Key? key,
    required this.textController,
    this.focusNode,
    this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          constraints: BoxConstraints(maxHeight: 100),
          padding: EdgeInsets.only(top: 3.sp, bottom: 3.sp, left: 16.sp),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: true,
                  focusNode: focusNode,
                  controller: this.textController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.newline,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(100),
                  ],
                  onSubmitted: (value) {
                    if (onSend != null) {
                      onSend!();
                    }
                  },
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
                    hintText: '',
                    counterText: '',
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: AppColors.pink[500]!
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (onSend != null) {
                    onSend!();
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: AppColors.pink[500],
                  size: 25.sp,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
