class TransactionHistoryParamDto {
  final int type;
  final String fromDate;
  final String toDate;
  final int page;

  TransactionHistoryParamDto({required this.type, required this.fromDate, required this.toDate, required this.page});
}
