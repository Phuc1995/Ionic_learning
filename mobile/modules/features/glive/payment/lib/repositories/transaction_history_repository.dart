import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/dto/dto.dart';

class TransactionHistoryRepository {

  // dio instance
  final DioClient _dioClient;

  TransactionHistoryRepository(this._dioClient);

  @override
  Future<Either<Failure, GatewayResponse>> getTypeOfTransactionHistory() async {
    try{
      final data = await _dioClient.get('/transaction-types');
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }

  @override
  Future<Either<Failure, GatewayResponse>> getItemOfTransactionHistory(ItemTransactionHistoryParamDto param) async {
    try{
      String type;
      if(param.type == 0){
        type = '';
      } else {
        type = param.type.toString();
      }
      final data = await _dioClient.get('/transactions',
          queryParameters: {'limit':PaymentContants.LIMIT_ITEM, 'type':type, 'fromDate':param.fromDate, 'toDate':param.toDate, "page": param.page}
          );
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
}

  @override
  Future<Either<Failure, GatewayResponse>> getStatistic(ItemStatisticParamDto param) async {
    try{
      final data = await _dioClient.get('/live-history',
          queryParameters: {'limit':PaymentContants.LIMIT_ITEM_STATISTIC, 'type':param.type, 'fromDate':param.fromDate, 'toDate':param.toDate, "page": param.page}
      );
      return Right(GatewayResponse.fromMap(data));
    }catch(err){
      return Left(DioErrorUtil.handleError(err));
    }
  }
}
