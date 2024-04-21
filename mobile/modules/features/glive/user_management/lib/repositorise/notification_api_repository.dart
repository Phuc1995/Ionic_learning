import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management/dto/dto.dart';
import 'package:user_management/dto/list_data_notification_param_dto.dart';

class NotificationRepository {
  final String endpoint = '/notification';

  // dio instance
  final DioClient _dioClient;

  NotificationRepository(this._dioClient);

  @override
  Future<Either<Failure, GatewayResponse>> getData(ListDataNotificationParamDto param) async {
    try{
      final data = await _dioClient.get('${endpoint}',
          queryParameters: param.toJson()
      );
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> tickWasRead(TickWasReadNotificationParamDto param) async {
    try{
      final data = await _dioClient.put('${endpoint}/${param.id}',
          data: {'read': true}
      );
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> countUnreadNotification() async {
    try{
      final data = await _dioClient.get('${endpoint}/count-unread',
      );
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }
}
