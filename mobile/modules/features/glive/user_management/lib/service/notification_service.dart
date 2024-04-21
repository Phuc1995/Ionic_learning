import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:user_management/dto/dto.dart';

import '../repositorise/repositories.dart';


abstract class NotificationServiceAbs{
  Future<Either<Failure, PagingDto<NotificationDataDto, dynamic>>> getData(ListDataNotificationParamDto param);
  Future<Either<Failure, bool>> tickWasRead(TickWasReadNotificationParamDto param);
  Future<Either<Failure, int>> countUnreadNotification();
}

class NotificationService implements NotificationServiceAbs {
  final logger = Modular.get<Logger>();

  @override
  Future<Either<Failure, PagingDto<NotificationDataDto, dynamic>>> getData(ListDataNotificationParamDto param) async {
    final notificationRepo = Modular.get<NotificationRepository>();
    final either = await notificationRepo.getData(param);

    return either.fold((failure) => Left(failure), (data) {
      if(data.messageCode == "GET_LIST_NOTIFICATION_SUCCESS"){
        List<NotificationDataDto> listItem = <NotificationDataDto>[];
        PagingDto<NotificationDataDto, dynamic> pagingObj = PagingDto();
        data.data['items'].forEach((json){
          NotificationDataDto item = NotificationDataDto.fromMap(json);
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
  Future<Either<Failure, bool>> tickWasRead(TickWasReadNotificationParamDto param) async {
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
