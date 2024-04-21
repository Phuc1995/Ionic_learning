import 'package:common_module/common_module.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  AppBarCommonWidget _appbarCommonWidget = AppBarCommonWidget();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _appbarCommonWidget.build("support_title".tr,  (){
        Modular.to.pop();
      }),
      backgroundColor: AppColors.whiteSmoke5,
      body: Tawk(
        directChatLink: dotenv.env['TAWK_TO_LINK']!,
        visitor: TawkVisitor(
          name: _sharedPrefsHelper.getUserNameSupport!,
          email: _sharedPrefsHelper.getUserMailSupport!,
        ),
        onLinkTap: (String url) {
          print(url);
        },
        placeholder: const Center(
          child: CustomProgressIndicatorWidget(),
        ),
      ),
    );
  }
}

