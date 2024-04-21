import 'package:get/get.dart';

extension GetXExtension on GetInterface {
  void resetCustom(
      {@deprecated bool clearFactory = true, bool clearRouteBindings = true}) {
    GetInstance().resetInstance(clearRouteBindings: clearRouteBindings);
    Get.clearRouteTree();
    Get.resetRootNavigator();
  }
}
