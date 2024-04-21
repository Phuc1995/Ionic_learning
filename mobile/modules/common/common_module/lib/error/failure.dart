import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];

}

class ServerFailure extends Failure {
  final int statusCode;

  final String message;

  final dynamic data;

  ServerFailure({ required this.statusCode, required this.message, this.data});

  @override
  List<Object> get props => [statusCode, message, data];
}

class DioFailure extends Failure {
  final int? statusCode;

  final String message;

  final String messageCode;

  DioFailure({required this.message, required this.messageCode, this.statusCode});

  @override
  List<Object> get props => [statusCode!, message, messageCode];
}

class LocalFailure extends Failure {}

class NetworkFailure extends Failure {}
