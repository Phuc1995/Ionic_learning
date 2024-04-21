import 'dart:collection';
import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/repositories/transaction_history_repository.dart';

class TransactionHistoryService {
  final logger = Modular.get<Logger>();

  Future<Either<Failure, SplayTreeMap<int, String>>>getTypeFilterTransactionHistory() async {
    final transactionHistoryRepo = Modular.get<TransactionHistoryRepository>();
    final either = await transactionHistoryRepo.getTypeOfTransactionHistory();
    return either.fold((failure) => Left(failure), (data) {
      SplayTreeMap<int, String> treeMap = new SplayTreeMap<int, String>();
      treeMap[0] = ConvertCommon().tyeTransactionTranslate("All");
      data.data.forEach((item) {
        ItemFilterDto itemFilter = ItemFilterDto.fromJson(item);
        treeMap[itemFilter.id!] = ConvertCommon().tyeTransactionTranslate(itemFilter.typeName!);
      });
      return Right(treeMap);
    });
}

  Future<Either<Failure, Map>> getItemTransactionHistory(ItemTransactionHistoryParamDto param) async {
    final transactionHistoryRepo = Modular.get<TransactionHistoryRepository>();
    final either = await transactionHistoryRepo.getItemOfTransactionHistory(param);
    return either.fold((failure) => Left(failure), (data) {
      if(data.messageCode == "GET_TRANSACTIONS_SUCCESS"){
        List<ItemTransactionHistoryDto> listItem = <ItemTransactionHistoryDto>[];
        data.data['items'].forEach((json){
          ItemTransactionHistoryDto item = ItemTransactionHistoryDto.fromMap(json);
          listItem.add(item);
        });
        Map result = new Map();
        result['items'] = listItem;
        return Right(result);
      }
      return Left(LocalFailure());
    });
  }

  Future<Either<Failure, PagingDto<ItemStatisticDto, SummaryDto>>> getStatistic(ItemStatisticParamDto param) async {
    final transactionHistoryRepo = Modular.get<TransactionHistoryRepository>();
    final either = await transactionHistoryRepo.getStatistic(param);
    return either.fold((failure) => Left(failure), (data) {
      if(data.messageCode == "GET_LIVE_HISTORY_SUCCESS"){
        List<ItemStatisticDto> listItem = <ItemStatisticDto>[];
        PagingDto<ItemStatisticDto, SummaryDto> pagingObj = PagingDto();
        data.data['items'].forEach((json){
          ItemStatisticDto item = ItemStatisticDto.fromMap(json);
          listItem.add(item);
        });
        pagingObj.setItems(listItem);
        pagingObj.setPage(PageData.fromMap(data.data["meta"]));
        pagingObj.setSummary(data.data["summary"]);
        return Right(pagingObj);
      }
      return Left(LocalFailure());
    });
  }
}
