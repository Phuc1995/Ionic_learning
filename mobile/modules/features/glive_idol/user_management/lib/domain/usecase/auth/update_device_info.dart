import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class UpdateDeviceInfo extends UseCase< GatewayResponse, DeviceInfoParams> {
  late Either<Failure,  GatewayResponse> _response;

  Either<Failure,  GatewayResponse> get response => _response;

  final logger = Modular.get<Logger>();

  @override
  Future<Either<Failure, GatewayResponse>> call(DeviceInfoParams params) async {
    final _authApiService = Modular.get<AuthApiService>();
    _response = await _authApiService.updateDeviceInfo(params);
    _response.fold((l){
      logger.e("Update device info error");
    }, (r) => null);
    return _response;
  }
}

class DeviceInfoParams extends Equatable {
  final String deviceId;
  final String deviceModel;
  final String fcmToken;

  @override
  List<Object> get props => [deviceId, deviceModel, fcmToken];

  DeviceInfoParams({required this.deviceId, required this.deviceModel, required this.fcmToken});

  Map<String, dynamic> toJson() => {
    "id": deviceId,
    "token": fcmToken,
    "name": deviceModel,
  };
}

