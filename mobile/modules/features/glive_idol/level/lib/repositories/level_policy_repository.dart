import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';

class LevelPolicyRepository {
  final DioClient _dioClient;

  LevelPolicyRepository(this._dioClient);

  Future<Either<Failure, GatewayResponse>> getLevelPolicy() async {
    try {
      final data = await _dioClient.get('/policy/level');
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  Future<Either<Failure, GatewayResponse>> getIdolExperience() async {
    try {
      final data = await _dioClient.get('/experience');
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }
}
