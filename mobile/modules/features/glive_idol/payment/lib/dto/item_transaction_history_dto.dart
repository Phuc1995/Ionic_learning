class ItemTransactionHistoryDto {
  String createdDate;
  String updatedDate;
  int id;
  String userUuid;
  int amount;
  int newBalance;
  String description;
  int transactionTypeId;

  ItemTransactionHistoryDto(
      {required this.createdDate,
      required this.updatedDate,
      required this.id,
      required this.userUuid,
      required this.amount,
      required this.newBalance,
      required this.description,
      required this.transactionTypeId});

  factory ItemTransactionHistoryDto.fromMap(Map<String, dynamic> json) => ItemTransactionHistoryDto(
    createdDate: json['createdDate'],
    updatedDate: json['updatedDate'],
    id: int.parse(json['id']),
    userUuid: json['userUuid'],
    amount: int.parse(json['amount']),
    newBalance: int.parse(json['newBalance']),
    description: json['description'],
    transactionTypeId: json['transactionTypeId'],

  );
}
