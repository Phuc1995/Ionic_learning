import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginTypeButton extends StatelessWidget {
  final List<bool> isSelected;
  final void Function(int index)? onPressed;
  const LoginTypeButton({Key? key, required this.onPressed, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 16.h),
          padding: EdgeInsets.zero,
          height: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50))
          ),
          child: ToggleButtons(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  child: Icon(Icons.smartphone),
                  decoration: BoxDecoration(
                    color: isSelected[0] ? AppColors.pink[100] : Colors.white,
                  )
              ),
              Container(
                  alignment: Alignment.center,
                  child: Icon(Icons.mail),
                  decoration: BoxDecoration(
                    color: isSelected[1] ? AppColors.pink[100] : Colors.white,
                  )
              ),
            ],
            onPressed: this.onPressed,
            isSelected: isSelected,
            borderRadius: BorderRadius.all(Radius.circular(50)),
            constraints: BoxConstraints.expand(width: (constraints.minWidth.floor() - 4)/2, height: 48),
          )
      );
    }
    );
  }
}
