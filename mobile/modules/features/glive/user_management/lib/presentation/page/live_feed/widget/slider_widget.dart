import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SliderWidget extends StatefulWidget {
  List<String> images;

  SliderWidget({required this.images});

  @override
  State<StatefulWidget> createState() {
    return _SliderWidgetState();
  }
}

class _SliderWidgetState extends State<SliderWidget> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = widget.images
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(item, fit: BoxFit.cover, width: 1000.0.w),
                      ],
                    )),
              ),
            ))
        .toList();
    return Stack(children: [
      CarouselSlider(
        items: imageSliders,
        carouselController: _controller,
        options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 1,
            // enlargeCenterPage: true,
            height: 150.h,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Container(
        height: 150.h,
        padding: EdgeInsets.only(bottom: 12.h),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 4.0.w),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.white)
                          .withOpacity(_current == entry.key ? 1 : 0.5)),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    ]);
  }
}
