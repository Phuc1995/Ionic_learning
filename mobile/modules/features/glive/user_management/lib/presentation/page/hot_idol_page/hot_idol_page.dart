import 'package:common_module/common_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:user_management/constants/assets.dart';
import 'package:user_management/dto/hot_idol_dto.dart';
import 'widget/common_verify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotIdolPage extends StatefulWidget {
  @override
  _HotIdolPageState createState() => _HotIdolPageState();
}

class _HotIdolPageState extends State<HotIdolPage> {
  List<HotIdolDto> hotIdols = <HotIdolDto>[];
  List<HotIdolDto> selectedIdols = <HotIdolDto>[];

  fetchIdols() async {
    const data = [
      {"name": "test", "id": 1213321212132},
      {"name": "test", "id": 121332412132},
      {"name": "test", "id": 121332512132},
      {"name": "test", "id": 121336212132},
      {"name": "test", "id": 1213321212132},
      {"name": "test", "id": 121332412132},
      {"name": "test", "id": 121332512132},
      {"name": "test", "id": 121336212132},
      {"name": "test", "id": 121336212132}
    ];
    var mappedData = data.map((d) => HotIdolDto.fromMap(d)).toList();
    setState(() {
      hotIdols = mappedData;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  initState() {
    super.initState();
    fetchIdols();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: DeviceUtils.buildWidget(context, _buildBody(context)),
      appBar: EmptyAppBar(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: [
            Text('hot_idol_title'.tr,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32.sp),
                textAlign: TextAlign.center),
          ],
        ),
        SizedBox(height: 33.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 27.w),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 110.w/160.h,
              mainAxisSpacing: 10.h,
              crossAxisSpacing: 15.w
            ),
            itemCount: hotIdols.length,
            semanticChildCount: 20,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index){
              return _buildIdolWidget(context, hotIdols[index]);
            },
          ),
        ),
        SizedBox(height: 105.h),
        CommonVerify().nextButton(
            context: context,
            submit: () {
              Modular.to.pushReplacementNamed(ViewerRoutes.home,  arguments: {'currentPage' : 0});
            }),
      ],
    );
  }

  Widget _buildIdolWidget(BuildContext context, HotIdolDto hotIdol) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.whiteSmoke2,
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 65.h,
            width: 65.w,
            margin: EdgeInsets.only(top: 15.h),
            child: SizedBox(
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(Assets.defaultAvatar),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      height: 18.h,
                      width: 18.w,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.pinkGradientButton,
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: FlatButton(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                          padding: EdgeInsets.only(right: 0),
                          onPressed: null,
                        ),
                      )),
                ],
              ),
            ),
          ),
          SizedBox(height: 6.h),
          Text(hotIdol.name,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          SizedBox(height: 10.h),
          _buildFollowButton(context, hotIdol),
        ],
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context, HotIdolDto hotIdol) {
    return RoundedButtonGradientWidget(
      buttonText: selectedIdols.any((idol) => idol.id == hotIdol.id)
          ? 'hot_idol_cancel_btn'.tr
          : 'hot_idol_follow_btn'.tr,
      buttonColor: selectedIdols.any((idol) => idol.id == hotIdol.id)
          ? LinearGradient(
              colors: [
                Color(0xFF8A8A8A),
                Color(0xFF8A8A8A),
              ],
              begin: Alignment(-1, 0.7),
              end: Alignment(1, -0.7),
            )
          : AppColors.pinkGradientButton,
      height: 22.h,
      textColor: Colors.white,
      textSize: 11.sp,
      padding: const EdgeInsets.all(0),
      onPressed: () {
        if (selectedIdols.any((idol) => idol.id == hotIdol.id)) {
          List<HotIdolDto> newSelectedIdols = new List<HotIdolDto>.from(selectedIdols);
          newSelectedIdols.removeWhere((idol) => idol.id == hotIdol.id);
          setState(() {
            selectedIdols = newSelectedIdols;
          });
        } else {
          List<HotIdolDto> newSelectedIdols = new List<HotIdolDto>.from(selectedIdols);
          newSelectedIdols.add(hotIdol);
          setState(() {
            selectedIdols = newSelectedIdols;
          });
        }
      },
    );
  }
}
