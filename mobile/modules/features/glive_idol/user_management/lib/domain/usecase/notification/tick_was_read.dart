import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/service/notification_service.dart';

class TickWasReadNotification extends UseCase<bool, TickWasReadNotificationParam>{
  late Either<Failure, bool> _response;

  Either<Failure, bool> get response => _response;

  @override
  Future<Either<Failure, bool>> call(TickWasReadNotificationParam param) async{
    final notificationService = Modular.get<NotificationService>();
    _response = await notificationService.tickWasRead(param);
    return await _response;
  }
}

class TickWasReadNotificationParam extends Equatable{
  final int id;
  final bool read;

  TickWasReadNotificationParam({required this.id, required this.read});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

Map<String, dynamic> toJson() => {
  "read": read,
};

}