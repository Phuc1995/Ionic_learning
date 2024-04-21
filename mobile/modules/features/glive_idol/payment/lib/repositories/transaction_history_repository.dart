import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/dto/dto.dart';

class TransactionHistoryRepository {

  // dio instance
  final DioClient _dioClient;

  TransactionHistoryRepository(this._dioClient);

  Future<Either<Failure, GatewayResponse>> getTransactionTypes() async {
    try{
      final data = await _dioClient.get('/transaction-types');
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  Future<Either<Failure, GatewayResponse>> getTransactionHistory(TransactionHistoryParamDto param) async {
    try{
      String type;
      if(param.type == 0){
        type = '';
      } else {
        type = param.type.toString();
      }
      final data = await _dioClient.get('/transactions',
          queryParameters: {'limit':Paging.LIMIT_ITEM, 'type':type, 'fromDate':param.fromDate, 'toDate':param.toDate, "page": param.page}
          );
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
}
  Future<Either<Failure, GatewayResponse>> getStatistic(StatisticParamDto param) async {
    try{
      final data = await _dioClient.get('/live-history',
          queryParameters: {'limit':Paging.LIMIT_ITEM_STATISTIC, 'type':param.type, 'fromDate':param.fromDate, 'toDate':param.toDate, "page": param.page}
      );
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }
}
