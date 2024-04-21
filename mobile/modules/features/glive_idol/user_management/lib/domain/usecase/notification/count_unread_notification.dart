import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/service/notification_service.dart';

class CountUnreadNotification extends UseCase<int, NoParams>{
  late Either<Failure, int> _response;

  Either<Failure, int> get response => _response;

  @override
  Future<Either<Failure, int>> call(NoParams params) async{
    final notificationService = Modular.get<NotificationService>();
    _response = await notificationService.countUnreadNotification();
    return await _response;
  }
}