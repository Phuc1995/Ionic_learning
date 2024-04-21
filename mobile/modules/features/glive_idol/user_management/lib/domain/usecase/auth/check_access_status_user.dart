import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/entity/response/access_status_response.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class CheckAccessStatusUser extends UseCase<AccessStatusResponse, NoParams> {
  late Either<Failure, AccessStatusResponse> _response;

  Either<Failure, AccessStatusResponse> get response => _response;

  @override
  Future<Either<Failure, AccessStatusResponse>> call(NoParams) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.checkAccessStatusUser();
    return _response;
  }
}

