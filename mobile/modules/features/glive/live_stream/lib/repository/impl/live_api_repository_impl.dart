import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/domain/entity/category_entity.dart';
import 'package:live_stream/domain/entity/gift_dto.dart';
import 'package:live_stream/domain/entity/message_dto.dart';
import 'package:live_stream/domain/usecase/list_viewer_permission.dart';
import 'package:live_stream/domain/usecase/viewer_permission.dart';
import 'package:live_stream/repository/live_api_repository.dart';
import 'package:user_management/dto/dto.dart';


class LiveApiRepositoryImpl implements LiveApiRepository {
  final String endpoint = '/idol/live-session';
  final String endpointViewer = "/idol/privacy/viewer/permission";

  // dio instance
  final DioClient _dioClient = Modular.get<DioClient>();

  LiveApiRepositoryImpl();

  @override
  Future<Either<Failure, GatewayResponse>> createLiveSession(LiveSessionDto dto) async {
    try {
      final data = await _dioClient.post('$endpoint/start', data: dto);
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> endLiveSession(String id, String streamId) async {
    try {
      final data = await _dioClient
          .put('/idol/live-session/end/$id', data: {'streamId': streamId.toString()});
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> heartBeat(String id) async {
    try {
      final data = await _dioClient.put('$endpoint/heart-beat/$id');
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> viewerPermission(AddViewerPermissionParam param) async {
    try {
      final data = await _dioClient
          .post(param.isRemove ? endpointViewer + "/remove" : endpointViewer, data: param.toJson());
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getListPermission(
      ListViewerPermissionParam param) async {
    try {
      final data = await _dioClient.get(endpointViewer + "/", queryParameters: param.toJson());
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> sendMessage(MessageDto dto) async {
    try {
      final data =
          await _dioClient.post('/message', data: {'roomId': dto.roomId, 'content': dto.content});
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> joinRoom(String roomId, String userUuid) async {
    try {
      final data = await _dioClient
          .put('/idol/live-session/join', data: {'roomId': roomId, 'content': userUuid});
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> leaveRoom(String roomId, String userUuid) async {
    try {
      final data = await _dioClient
          .put('/idol/live-session/leave', data: {'roomId': roomId, 'content': userUuid});
      return Right(GatewayResponse.fromMap(data));
    } catch (error) {
      return Left(DioErrorUtil.handleError(error));
    }
  }

  @override
  Future<Either<Failure, List<CategoryList>>> getCategory() async {
    try {
      final data = await _dioClient.get('/bags/categories');
      List<CategoryList> listCategoryResponse = [];
      data['data'].forEach((json) {
        CategoryList categoryResponse = CategoryList.fromMap(json);
        listCategoryResponse.add(categoryResponse);
      });
      return Right(listCategoryResponse);
    } catch (error) {
      print(error);
      return Left(DioErrorUtil.handleError(error));
    }
  }

  @override
  Future<Either<Failure, String>> sendGift(GiftDto giftDto) async {
    try {
      final data = await _dioClient.post('/bags/gift/send', data: {
        'id': giftDto.id,
        'price': giftDto.price,
        'promotionPrice': giftDto.promotionPrice,
        'quantity': giftDto.quantity,
        'receiverId': giftDto.receiverId,
        'streamId': giftDto.streamId
      });
      return Right(data);
    } catch (error) {
      print(error);
      return Left(DioErrorUtil.handleError(error));
    }
  }
}
