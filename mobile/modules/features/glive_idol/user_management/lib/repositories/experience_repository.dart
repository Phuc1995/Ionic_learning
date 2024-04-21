import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';

class ExperienceRepository {
  final DioClient _dioClient;

  ExperienceRepository(this._dioClient);

  Future<Either<Failure, GatewayResponse>> getExperience() async {
    try {
      final data = await _dioClient.get('/experience');
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }
}
