class TopUpHistoryDto {
  String? id;
  int? networkId;
  String? createdDate;
  String? updatedDate;
  String? status;
  int? amount;
  double? amountToken;
  String? paymentMethod;
  String? paymentTransId;
  String? paymentBankTransferInfo;
  String? tokenAddress;
  String? tokenType;
  String? tokenAddressFrom;
  String? tokenAddressTo;
  String? transactionHash;
  String? explorerUrl;
  String? txPath;
  String? networkName;
  String? networkType;
  String? accountPath;
  String? errorMessage;

  TopUpHistoryDto({
    this.id,
    this.networkId,
    this.createdDate,
    this.updatedDate,
    this.status,
    this.amount,
    this.amountToken,
    this.paymentMethod,
    this.paymentTransId,
    this.paymentBankTransferInfo,
    this.tokenAddress,
    this.tokenType,
    this.tokenAddressFrom,
    this.tokenAddressTo,
    this.transactionHash,
    this.explorerUrl,
    this.txPath,
    this.networkName,
    this.networkType,
    this.accountPath,
    this.errorMessage,
  });

  factory TopUpHistoryDto.fromMap(dynamic map) => TopUpHistoryDto(
    id: map['id']??0,
    networkId: map['networkId']??0,
    createdDate: map['createdDate']??'',
    status: map['status']??'',
    amount: map['amount']??0,
    amountToken: double.tryParse(map['amountToken']),
    paymentMethod: map['paymentMethod']??'',
    paymentTransId: map['paymentTransId']??'',
    paymentBankTransferInfo: map['paymentBankTransferInfo']??'',
    tokenAddress: map['tokenAddress']??'',
    tokenType: map['tokenType']??'',
    tokenAddressFrom: map['tokenAddressFrom']??'',
    tokenAddressTo: map['tokenAddressTo']??'',
    transactionHash: map['transactionHash']??'',
    networkName: map['network']['name'],
    txPath: map['network']['txPath'],
    explorerUrl: map['network']['explorerUrl'],
    networkType: map['network']['exchangeRate'][0]['type'],
    accountPath: map['network']['accountPath'],
    errorMessage: map['errorMessage'],
  );

  factory TopUpHistoryDto.fromSocketMap(dynamic map) => TopUpHistoryDto(
    id: map['id']??0,
    createdDate: map['createdDate']??'',
    status: map['data']['status']??'',
    amount: map['data']['amount']??0,
    amountToken: map['data']['amountToken'].toDouble(),
    paymentMethod: map['paymentMethod']??'',
    paymentTransId: map['paymentTransId']??'',
    paymentBankTransferInfo: map['paymentBankTransferInfo']??'',
    tokenAddress: map['tokenAddress']??'',
    tokenType: map['data']['tokenType']??'',
    tokenAddressFrom: map['data']['addressFrom']??'',
    tokenAddressTo: map['data']['addressTo']??'',
    transactionHash: map['data']['txID']??'',
    networkName: map['data']['networkName']??'',
    txPath: map['data']['txPath']??'',
    explorerUrl: map['data']['explorerUrl']??'',
    networkType: '',
  );
}