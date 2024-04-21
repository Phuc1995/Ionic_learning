import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/entity/notification/notification_data_entity.dart';
import 'package:user_management/domain/service/notification_service.dart';

class ListDataNotification extends UseCase<PagingDto<NotificationDataEntity, dynamic>, ListDataNotificationParam>{
  late Either<Failure, PagingDto<NotificationDataEntity, dynamic>> _response;
  Either<Failure, PagingDto<NotificationDataEntity, dynamic>> get response => _response;

  @override
  Future<Either<Failure, PagingDto<NotificationDataEntity, dynamic>>> call(ListDataNotificationParam param) async{
    final notificationService = Modular.get<NotificationService>();
    _response = await notificationService.getData(param);
    return _response;
  }
}

class ListDataNotificationParam extends Equatable{
  final String type;
  final int page;
  final int limit;

  ListDataNotificationParam({required this.type, required this.page, required this.limit});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "searchType": type,
    "page": page,
  };

}
