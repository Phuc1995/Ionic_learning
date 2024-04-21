import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/dto/idol_detail_dto.dart';

import '../repositorise/repositories.dart';

class IdolService {
  Future<Either<Failure, IdolDetailDto>> getIdolDetail(String uuidIdol) async {
    final _repo = Modular.get<FollowIdolRepository>();
    final _response = await _repo.getIdolDetail(uuidIdol);
    return _response.fold((fail) => Left(fail), (data) {
      IdolDetailDto idolEntity = IdolDetailDto.fromMap(data.data);
      return Right(idolEntity);
    });
  }

  Future<Either<Failure, List<IdolDetailDto>>> getHotIdols() async {
    final _repo = Modular.get<IdolRepository>();
    final _response = await _repo.getHotIdols();
    return _response.fold((fail) => Left(fail), (res) {
      List<IdolDetailDto> idols = [];
      res.data.forEach((e) {
        idols.add(IdolDetailDto.fromMap(e));
      });
      return Right(idols);
    });
  }
}
