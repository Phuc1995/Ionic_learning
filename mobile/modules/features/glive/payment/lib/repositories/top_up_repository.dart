import 'dart:io';
import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/dto/dto.dart';

class TopUpRepository {
  final String wallet = '/wallet';
  final String topUpCache = '/top-up/cache';
  // dio instance
  final DioClient _dioClient;

  TopUpRepository(this._dioClient);

  @override
  Future<Either<Failure, GatewayResponse>> topUp({required String method, required num amount}) async {
    try{
      final body = {'method': method, 'amount': amount, 'platform': Platform.isIOS ? 'ios' : 'android'};
      final data = await _dioClient.post('/top-up', data: body);
      return Right(GatewayResponse.fromMap(data));
    } catch(err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getNetwork() async {
    try{
      final params = {
        'networkType': dotenv.env['CRYPTO_NETWORK']??'MAINNET',
      };
      final data = await _dioClient.get('$wallet/network', queryParameters: params);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getTopUpHistory(TopUpHistoryParamDto param) async {
    try{
      Map<String, dynamic> parameters = {
        PaymentContants.LIMIT: param.limit,
        PaymentContants.PAGE : param.page,
        PaymentContants.NETWORK: param.network ,
        PaymentContants.TRANSACTION_DATE: param.transactionDate,
        PaymentContants.TOKEN_TYPE: param.tokenType,
        PaymentContants.STATUS: param.status,
      };
      if(param.network == null){
        parameters.remove(PaymentContants.NETWORK);
      }
      if(param.transactionDate == null){
        parameters.remove(PaymentContants.TRANSACTION_DATE);
      }
      if(param.tokenType == null){
        parameters.remove(PaymentContants.TOKEN_TYPE);
      }
      if(param.status == null){
        parameters.remove(PaymentContants.STATUS);
      }
      final data = await _dioClient.get('/top-up', queryParameters: parameters);
      return Right(GatewayResponse.fromMap(data));
    } catch (err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> deleteTopUpCache() async {
    try{
      final data = await _dioClient.delete(topUpCache);
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getTopUpCache() async {
    try{
      final data = await _dioClient.get(topUpCache);
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> postTopUpCache(dynamic json) async {
    try{
      final data = await _dioClient.post(topUpCache, data: json);
      return Right(GatewayResponse.fromMap(data));
    } catch (err) {
      return Left(DioErrorUtil.handleError(err));
    }
  }

}
