import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management/dto/dto.dart';

class FollowIdolRepository {
  final String follow = '/follow';
  final String idol = '/idols';

  // dio instance
  final DioClient _dioClient;

  FollowIdolRepository(this._dioClient);

  Future<Either<Failure, GatewayResponse>> followIdol(String uuidIdol) async {
    try{
      final data = await _dioClient.post(follow, data: {'idolUuid' : uuidIdol });
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  Future<Either<Failure, GatewayResponse>> unfollowIdol(String uuidIdol) async {
    try{
      final data = await _dioClient.delete(follow, data: {'idolUuid' : uuidIdol });
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  Future<Either<Failure, GatewayResponse>> getIdolDetail(String uuidIdol) async {
    try{
      final data = await _dioClient.get('$idol/detail/$uuidIdol');
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  Future<Either<Failure, GatewayResponse>> receiveBellIdol(IdolBellParamDto param) async {
    try {
      final data = await _dioClient.put("$follow/bell", data: {'idolUuid' : param.uuidIdol, "bell":  param.bell});
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  Future<Either<Failure, GatewayResponse>> getIdolsFollowed(IdolFollowedParamDto param) async {
    try{
      final params = {
        "limit": param.limit,
        "page": param.page,
      };
      final data = await _dioClient.get('$follow/idols-list', queryParameters: params);
      return Right(GatewayResponse.fromMap(data));
    } catch(err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  Future<Either<Failure, GatewayResponse>> getIdolFollowedStreaming(IdolFollowedStreamingParamDto param) async {
    try{
      final params = {
        "limit": param.limit,
        "page": param.page,
      };
      final data = await _dioClient.get('$follow/idols-streaming', queryParameters: params);
      return Right(GatewayResponse.fromMap(data));
    } catch(err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  Future<Either<Failure, GatewayResponse>> countFollowingViewer(String uuidViewer) async {
    try{
      final data = await _dioClient.get('$follow/following/$uuidViewer',);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

}

