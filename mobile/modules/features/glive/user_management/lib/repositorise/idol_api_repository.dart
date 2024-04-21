import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';

class IdolRepository {
  final String idol = '/idols';

  // dio instance
  final DioClient _dioClient;

  IdolRepository(this._dioClient);

  @override
  Future<Either<Failure, GatewayResponse>> getIdolDetail(String uuidIdol) async {
    try{
      final data = await _dioClient.get('$idol/detail/$uuidIdol');
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getHotIdols() async {
    try{
      final data = await _dioClient.get('$idol/hot-idols');
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }
}
