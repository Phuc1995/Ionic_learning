import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/entity/response/category_response.dart';
import 'package:user_management/domain/service/skills_idol_service.dart';

class GetAllSkill extends UseCase<List<CategoryResponse>, NoParams> {
  late Either<Failure, List<CategoryResponse>> _response;

  Either<Failure, List<CategoryResponse>> get response => _response;

  @override
  Future<Either<Failure, List<CategoryResponse>>> call(NoParams) async {
    final skillsService = Modular.get<SkillsIdolService>();
    _response = await skillsService.getAllSkills();
    return _response;
  }
}



