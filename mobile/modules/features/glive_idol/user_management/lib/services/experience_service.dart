import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/dto/experience_dto.dart';
import 'package:user_management/repositories/experience_repository.dart';

class ExperienceService {
  Future<Either<Failure, ExperienceDto>> getExperience() async {
    final _repo = Modular.get<ExperienceRepository>();
    final either = await _repo.getExperience();
    return either.fold((failure) => Left(failure), (data) {
      ExperienceDto entity = ExperienceDto.fromMap(data.data);
      return Right(entity);
    });
  }
}
