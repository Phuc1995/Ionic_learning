import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:live_stream/dto/dto.dart';

class PrivacyRepository {
  final String endpoint = "/privacy";
  final DioClient _dioClient;

  PrivacyRepository(this._dioClient);

  Future<Either<Failure, GatewayResponse>> viewerPermission(AddViewerPermissionDto param) async {
    try {
      final uri = "$endpoint/viewer/permission${param.isRemove ? '/remove' : ''}";
      final data = await _dioClient.post(uri, data: param.toJson());
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  Future<Either<Failure, GatewayResponse>> getListPermission(ListViewerPermissionDto param) async {
    try {
      final uri = "$endpoint/viewer/permission/";
      final data = await _dioClient.get(uri, queryParameters: param.toJson());
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }
}
