import 'package:common_module/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:level/dto/experience_dto.dart';
import 'package:level/dto/level_policy_dto.dart';
import 'package:level/repositories/level_policy_repository.dart';
import 'package:logger/logger.dart';

class LevelPolicyService {
  final logger = Modular.get<Logger>();

  Future<Either<Failure,List<LevelPolicyDto>>> getLevelPolicy() async {
    var listItemDetail = <LevelPolicyDto>[];
    final levelPolicyRepo = Modular.get<LevelPolicyRepository>();
    final either = await levelPolicyRepo.getLevelPolicy();
    return either.fold((failure) => Left(failure), (data) {
        data.data.forEach((item) {
          LevelPolicyDto entity = LevelPolicyDto.fromMap(item);
          listItemDetail.add(entity);
        });
        listItemDetail.sort((a,b) => b.minExp.compareTo(a.minExp));
      return Right(listItemDetail);
    });
  }

  Future<Either<Failure,ExperienceDto>> getIdolExperience() async {
    final levelPolicyRepo = Modular.get<LevelPolicyRepository>();
    final either = await levelPolicyRepo.getIdolExperience();
    return either.fold((failure) => Left(failure), (data) {
      ExperienceDto entity = ExperienceDto.fromMap(data.data);
      return Right(entity);
    });
  }
}
