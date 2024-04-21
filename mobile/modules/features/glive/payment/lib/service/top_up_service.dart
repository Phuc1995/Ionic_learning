import 'dart:convert';
import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/repositories/top_up_repository.dart';

class TopUpService {
  final logger = Modular.get<Logger>();

  Future<Either<Failure, GatewayResponse>> topUp(TopUpParamDto param) async {
    final repo = Modular.get<TopUpRepository>();
    final either = await repo.topUp(amount: param.amount, method: param.method);
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, List<NetworkDto>>> getNetwork() async {
    final repo = Modular.get<TopUpRepository>();
    final either = await repo.getNetwork();
    return either.fold((failure) => Left(failure), (data) {
      List<NetworkDto> listTopUpNetworkEntity = [];
      data.data.forEach((network){
        NetworkDto topUpNetworkEntity = NetworkDto.fromMap(network);
        listTopUpNetworkEntity.add(topUpNetworkEntity);
      });
      return Right(listTopUpNetworkEntity);
    });
  }

  @override
  Future<Either<Failure, Map>> getHistory(TopUpHistoryParamDto param) async {
    final repo = Modular.get<TopUpRepository>();
    final either = await repo.getTopUpHistory(param);
    return either.fold((failure) => Left(failure), (data) {
      List<TopUpHistoryDto> listTopUpHistory = [];
      data.data['items'].forEach((item){
        listTopUpHistory.add(TopUpHistoryDto.fromMap(item));
      });
      Map result = new Map();
      result['items'] = listTopUpHistory;
      result['totalPages'] = data.data['meta']['totalPages'];
      return Right(result);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> deleteTopUpCache() async {
    final repo = Modular.get<TopUpRepository>();
    final either = await repo.deleteTopUpCache();
    return either.fold((failure) => Left(failure), (data) {
      return Right(data);
    });
  }

  @override
  Future<Either<Failure, RechargeInformationDto?>> getTopUpCache() async {
    final repo = Modular.get<TopUpRepository>();
    final either = await repo.getTopUpCache();
    return either.fold((failure) => Left(failure), (data) {
      if(data.data != null){
        return Right(RechargeInformationDto.fromSocketWaitingMap(data.data));
      }
      return Right(null);
    });
  }

  @override
  Future<Either<Failure, GatewayResponse>> postTopUpCache(RechargeInformationDto information) async {
    final repo = Modular.get<TopUpRepository>();
    var content = json.encode({
      "tokenSelected": {
        "network": {
          "name": information.networkName,
          "explorerUrl": information.explorerUrl,
          "accountPath": information.accountPath,
          "txPath": information.txPath,
        },
        "token": {
          "type": information.tokenType,
          "symbol": information.tokenSymbol,
        }
      },
      "toAddress": information.addressTo,
    });
    var data =  {
      "content" : content,
      "isManual" : information.type == 1 ? true : false,
    };
    final either = await repo.postTopUpCache(data);
    return either.fold((failure) => Left(failure), (data) {
      if(data.data != null){
      }
      return Right(GatewayResponse());
    });
  }
}
