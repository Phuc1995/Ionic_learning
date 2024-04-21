import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/dto/idol_bell_param_dto.dart';
import 'package:user_management/dto/idol_detail_dto.dart';
import 'package:user_management/dto/idol_followed_param_dto.dart';
import 'package:user_management/dto/idol_followed_streaming_param_dto.dart';

import '../repositorise/repositories.dart';

class FollowIdolService {

  Future<Either<Failure, GatewayResponse>> followIdol(String uuidIdol) async {
    final followRepo = Modular.get<FollowIdolRepository>();
    final _response = await followRepo.followIdol(uuidIdol);
    return _response;
  }

  Future<Either<Failure, GatewayResponse>> unfollowIdol(String uuidIdol) async {
    final followRepo = Modular.get<FollowIdolRepository>();
    final _response = await followRepo.unfollowIdol(uuidIdol);
    return _response;
  }

  Future<Either<Failure, IdolDetailDto>> getIdolDetail(String uuidIdol) async {
    final followRepo = Modular.get<FollowIdolRepository>();
    final _response = await followRepo.getIdolDetail(uuidIdol);
    return _response.fold((fail) => Left(fail), (data) {
      IdolDetailDto idolEntity = IdolDetailDto.fromMap(data.data);
      return Right(idolEntity);
    });
  }

  Future<Either<Failure, bool>> receiveBellIdol(IdolBellParamDto param) async {
    final followRepo = Modular.get<FollowIdolRepository>();
    final either = await followRepo.receiveBellIdol(param);
    return either.fold((failure) => Left(failure), (data) {
      if(data.data != null){
        return Right(data.data['bell']);
      }
      return Right(false);
    });
  }

  Future<Either<Failure, PagingDto<IdolDetailDto, dynamic>>> getIdolsFollowed(IdolFollowedParamDto param) async {
    final followRepo = Modular.get<FollowIdolRepository>();
    final _response = await followRepo.getIdolsFollowed(param);
    PagingDto<IdolDetailDto, String> pagingObj = PagingDto();
    return _response.fold((fail) => Left(fail), (res) {
      List<IdolDetailDto> listIdolFollowed = [];
      if (res.data['items'] != null && res.data['items'].length > 0) {
        res.data['items'].forEach((e) {
          listIdolFollowed.add(IdolDetailDto.fromMap(e));
        });
      }
      if(res.data['meta'] != null){
        pagingObj.setPage(PageData.fromMap(res.data['meta']));
      }
      pagingObj.setItems(listIdolFollowed);
      return Right(pagingObj);
    });
  }

  Future<Either<Failure, PagingDto<IdolDetailDto, dynamic>>> getIdolFollowedStreaming(IdolFollowedStreamingParamDto param) async {
    final followRepo = Modular.get<FollowIdolRepository>();
    final _response = await followRepo.getIdolFollowedStreaming(param);
    PagingDto<IdolDetailDto, String> pagingObj = PagingDto();
    return _response.fold((fail) => Left(fail), (res) {
      List<IdolDetailDto> listIdolDetail = [];
      if (res.data['items'] != null && res.data['items'].length > 0) {
        res.data['items'].forEach((e) {
          listIdolDetail.add(IdolDetailDto.fromMap(e));
        });
      }
      if(res.data['meta'] != null){
        pagingObj.setPage(PageData.fromMap(res.data['meta']));
      }
      pagingObj.setItems(listIdolDetail);
      return Right(pagingObj);
    });
  }

  Future<Either<Failure, GatewayResponse>> countFollowingViewer(String uuidViewer) async {
    final followRepo = Modular.get<FollowIdolRepository>();
    final _response = await followRepo.countFollowingViewer(uuidViewer);
    return _response;
  }


}


