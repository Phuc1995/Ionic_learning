import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/service/skills_idol_service.dart';

class UpdateSkillsIdol extends UseCase<GatewayResponse, String> {
  late Either<Failure, GatewayResponse> _response;

  Either<Failure, GatewayResponse> get response => _response;

  @override
  Future<Either<Failure, GatewayResponse>> call(String skills) async {
    final skillsService = Modular.get<SkillsIdolService>();
    _response = await skillsService.updateSkillsIdol(skills);
    return _response;
  }
}



