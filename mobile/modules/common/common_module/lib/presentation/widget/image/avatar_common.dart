import 'package:flutter/material.dart';

class AvataCommon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final String avatarUrl;
  final BoxShape shape;
  final double padding;
  const AvataCommon({Key? key, required this.width, required this.height, required this.color, required this.avatarUrl, required this.shape, required this.padding,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        shape: this.shape,
        color: this.color,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: CircleAvatar(backgroundImage: NetworkImage(this.avatarUrl)),
      ),
    );
  }
}
