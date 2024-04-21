import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:user_management/domain/usecase/notification/get_list_notification.dart';
import 'package:user_management/domain/usecase/notification/tick_was_read.dart';

import '../notification_api_repository.dart';

class NotificationImpl extends NotificationRepository{
  final String endpoint = '/notification';

  // dio instance
  final DioClient _dioClient;

  NotificationImpl(this._dioClient);

  @override
  Future<Either<Failure, GatewayResponse>> getData(ListDataNotificationParam param) async {
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
  Future<Either<Failure, GatewayResponse>> tickWasRead(TickWasReadNotificationParam param) async {
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
