import 'package:common_module/utils/i18n/glive_idol/lang/en_us.dart';
import 'package:common_module/utils/i18n/glive_idol/lang/vi_vn.dart';
import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'vi_VN': vi_vn,
    'en_US': en_us,
  };
}