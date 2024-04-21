import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:user_management/domain/entity/response/category_response.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/repository/user_info_api_repository.dart';

abstract class SkillsIdolServiceAbs{
  Future<Either<Failure, GatewayResponse>> updateSkillsIdol(String skills);
  Future<Either<Failure, List<CategoryResponse>>> getAllSkills();
  Future<Either<Failure, Map>> getSkillsIdol();
}

class SkillsIdolService implements SkillsIdolServiceAbs {
  final logger = Modular.get<Logger>();

  @override
  Future<Either<Failure, GatewayResponse>> updateSkillsIdol(String skills) async {
    final _accountInfoApi = Modular.get<UserInfoApiRepository>();
    final either = await _accountInfoApi.updateSkillsIdol(skills);
    return either.fold((failure) => Left(failure), (data) {
    return Right(data);
    });
  }

  @override
  Future<Either<Failure, List<CategoryResponse>>> getAllSkills() async {
    final _accountInfoApi = Modular.get<UserInfoApiRepository>();
    final either = await _accountInfoApi.getAllSkill();
    return either.fold((failure) => Left(failure), (data) {
      List<CategoryResponse> listCategoryResponse = [];
      data.data.forEach((json){
        CategoryResponse categoryResponse = CategoryResponse.fromMap(json);
        listCategoryResponse.add(categoryResponse);
      });
      return Right(listCategoryResponse);
    });
  }

  @override
  Future<Either<Failure, Map>> getSkillsIdol() async {
    final _accountInfoApi = Modular.get<UserInfoApiRepository>();
    final either = await _accountInfoApi.getSkillIdol();
    return either.fold((failure) => Left(failure), (data) {
      List<CategoryResponse> listCategoryResponse = [];
      List<String> listSelected = [];
      Map result = Map();
      data.data['options'].forEach((json){
        CategoryResponse categoryResponse = CategoryResponse.fromMap(json);
        listCategoryResponse.add(categoryResponse);
      });
      data.data['selected'].forEach((json){
        listSelected.add(json['key']);
      });
      result['options'] = listCategoryResponse;
      result['selected'] = listSelected;
      return Right(result);
    });
  }
}
