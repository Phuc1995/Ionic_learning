import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:user_management/domain/service/auth_api_service.dart';

class UpdateInfoIdol extends UseCase<bool, InfoParams> {
  late Either<Failure, bool> _response;

  Either<Failure, bool> get response => _response;

  @override
  Future<Either<Failure, bool>> call(InfoParams params) async {
    final authService = Modular.get<AuthApiService>();
    _response = await authService.updateInfoForIdol(params: params);
    return _response;
  }
}

class InfoParams extends Equatable {
  final String field;
  final dynamic content;

  @override
  List<Object> get props => [field, content];

  InfoParams({required this.field, required this.content});
}


