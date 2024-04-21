import 'package:common_module/common_module.dart';
import 'package:get/get.dart';

class PaymentTopUpController extends GetxController {
  late SharedPreferenceHelper _sharedPrefsHelper;

  PaymentTopUpController();

  Rx<num> numMoney = 0.obs;

  var loading = false.obs;
  var success = false.obs;

  final List<num> moneyOptions = [
    50000,
    100000,
    200000,
    500000,
    1000000,
    2000000,
  ];

  @override
  void onInit() {
    super.onInit();
    SharedPreferenceHelper.getInstance().then((value) => _sharedPrefsHelper = value);
  }
}
