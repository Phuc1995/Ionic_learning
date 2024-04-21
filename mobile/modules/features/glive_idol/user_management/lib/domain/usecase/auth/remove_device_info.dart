import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:common_module/common_module.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class RemoveDeviceInfo extends UseCase< GatewayResponse, RemoveInfoParams> {
  late Either<Failure,  GatewayResponse> _response;

  Either<Failure,  GatewayResponse> get response => _response;

  final logger = Modular.get<Logger>();

  @override
  Future<Either<Failure, GatewayResponse>> call(RemoveInfoParams params) async {
    final _authApiService = Modular.get<AuthApiService>();
    _response = await _authApiService.removeDeviceInfo(params);
    _response.fold((l){
      logger.e("Remove device info error");
    }, (r) => null);
    return _response;
  }
}

class RemoveInfoParams extends Equatable {
  final String deviceId;

  @override
  List<Object> get props => [deviceId];

  RemoveInfoParams({required this.deviceId});

  Map<String, dynamic> toJson() => {
    "id": deviceId,
  };
}

