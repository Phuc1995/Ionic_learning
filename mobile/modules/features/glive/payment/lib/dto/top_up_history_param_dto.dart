class TopUpHistoryParamDto {
  final int? page;
  final int? limit;
  final int? network;
  final List? transactionDate;
  final String? tokenType;
  final String? status;

  TopUpHistoryParamDto({required this.page, required this.limit, this.network, this.transactionDate, this.tokenType, this.status});

  Map<String, dynamic> toJson() => {
    "limit": limit.toString(),
    "page": page.toString(),
  };

}