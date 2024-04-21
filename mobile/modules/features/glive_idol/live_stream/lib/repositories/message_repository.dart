import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:live_stream/dto/message_dto.dart';

class MessageRepository {
  final String endpoint = "/message";
  final DioClient _dioClient;

  MessageRepository(this._dioClient);

  Future<Either<Failure, GatewayResponse>> sendMessage(MessageDto dto) async {
    try {
      final data = await _dioClient.post(endpoint, data: { 'roomId' : dto.roomId ,'content' : dto.content});
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }
}
