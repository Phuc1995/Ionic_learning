import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management/domain/entity/request/live-session.dart';
import 'package:dio/dio.dart';

class LiveStreamRepository {
  final String endpoint = '/live-session';
  final DioClient _dioClient;

  LiveStreamRepository(this._dioClient);

  Future<Either<Failure, GatewayResponse>> createLiveSession(LiveSessionDto dto) async {
    try {
      final data = await _dioClient.post('$endpoint/start', data: dto);
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  Future<Either<Failure, GatewayResponse>> endLiveSession(String id, String streamId) async {
    try {
      final data = await _dioClient.put('$endpoint/end/$id', data: {'streamId': streamId});
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  Future<Either<Failure, GatewayResponse>> heartBeat(String id) async {
    try {
      final data = await _dioClient.put('$endpoint/heart-beat/$id', options: Options(
        receiveTimeout: 5000,
      ));
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }
}
