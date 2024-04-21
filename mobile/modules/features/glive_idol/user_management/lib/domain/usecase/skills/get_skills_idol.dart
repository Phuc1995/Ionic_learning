import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/service/skills_idol_service.dart';

class GetSkillsIdol extends UseCase<Map, NoParams> {
  late Either<Failure, Map> _response;

  Either<Failure, Map> get response => _response;

  @override
  Future<Either<Failure, Map>> call(NoParams) async {
    final skillsService = Modular.get<SkillsIdolService>();
    _response = await skillsService.getSkillsIdol();
    return _response;
  }
}



