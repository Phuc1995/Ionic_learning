import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:user_management/domain/entity/notification/notification_data_entity.dart';
import 'package:user_management/domain/usecase/notification/get_list_notification.dart';
import 'package:user_management/domain/usecase/notification/tick_was_read.dart';
import 'package:user_management/repository/notification_api_repository.dart';

abstract class NotificationServiceAbs{
  Future<Either<Failure, PagingDto<NotificationDataEntity, dynamic>>> getData(ListDataNotificationParam param);
  Future<Either<Failure, bool>> tickWasRead(TickWasReadNotificationParam param);
  Future<Either<Failure, int>> countUnreadNotification();
}

class NotificationService implements NotificationServiceAbs{
  final logger = Modular.get<Logger>();

  @override
  Future<Either<Failure, PagingDto<NotificationDataEntity, dynamic>>> getData(ListDataNotificationParam param) async {
    final notificationRepo = Modular.get<NotificationRepository>();
    final either = await notificationRepo.getData(param);

    return either.fold((failure) => Left(failure), (data) {
      if(data.messageCode == "GET_LIST_NOTIFICATION_SUCCESS"){
        List<NotificationDataEntity> listItem = <NotificationDataEntity>[];
        PagingDto<NotificationDataEntity, dynamic> pagingObj = PagingDto();
        data.data['items'].forEach((json){
          NotificationDataEntity item = NotificationDataEntity.fromMap(json);
          listItem.add(item);
        });
        pagingObj.setItems(listItem);
        if(data.data["meta"] != null){
          pagingObj.setPage(PageData.fromMap(data.data["meta"]));
        }
        return Right(pagingObj);
      }
      return Left(LocalFailure());
    });
  }

  @override
  Future<Either<Failure, bool>> tickWasRead(TickWasReadNotificationParam param) async {
    final notificationRepo = Modular.get<NotificationRepository>();
    final either = await notificationRepo.tickWasRead(param);

    return either.fold((failure) => Left(failure), (data) {
      if(data.messageCode == "NOTIFICATION_IS_UPDATED"){
        return Right(true);
      }
      return Left(LocalFailure());
    });
  }

  @override
  Future<Either<Failure, int>> countUnreadNotification() async {
    final notificationRepo = Modular.get<NotificationRepository>();
    final either = await notificationRepo.countUnreadNotification();

    return either.fold((failure) => Left(failure), (data) {
        return Right(data.data);
    });
  }
}
