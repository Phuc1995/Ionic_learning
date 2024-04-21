import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:get/get.dart';
import 'package:live_stream/domain/entity/category_entity.dart';
import 'package:live_stream/domain/entity/gift_dto.dart';
import 'package:live_stream/repository/live_api_repository.dart';

class CategoryController extends GetxController {
  LiveApiRepository _liveApi = Modular.get<LiveApiRepository>();
  var categories = <CategoryList>[].obs;
  var activeId = 0.obs;
  var errorMessage = "".obs;
  var balance = 0.obs;

  CategoryController();

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> getCategoryGift() async {
    await this._liveApi.getCategory()
      ..fold(
          (l) => null,
          (r) => {
                categories.value = r,
              });
  }

  Future<void> sendGift(GiftDto giftDto) async {
    await this._liveApi.sendGift(giftDto)
      ..fold(
          (l) {
            if(l is DioFailure){
              errorMessage.value = l.messageCode;
            }
          },
          (r) => null);
  }

  void setActiveId() {
    activeId.value = (categories.length > 0 ? categories[0].order : 0)!;
  }

  void changeCategory(order) {
    activeId.value = order;
  }
}
