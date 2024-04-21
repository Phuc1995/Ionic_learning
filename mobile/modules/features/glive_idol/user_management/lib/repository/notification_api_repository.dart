import 'package:dartz/dartz.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/usecase/notification/get_list_notification.dart';
import 'package:user_management/domain/usecase/notification/tick_was_read.dart';

abstract class NotificationRepository {
  Future<Either<Failure, GatewayResponse>> getData(ListDataNotificationParam param);
  Future<Either<Failure, GatewayResponse>> tickWasRead(TickWasReadNotificationParam param);
  Future<Either<Failure, GatewayResponse>> countUnreadNotification();
}
