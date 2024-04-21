import 'dart:convert';

class RechargeInformationDto {
  int? type;
  String? tokenType;
  String? tokenSymbol;
  String? addressFrom;
  String? addressTo;
  String? txID;
  String? createdDate;
  String? expireTime;
  int? ttl;
  String? networkName;
  String? explorerUrl;
  String? txPath;
  String? accountPath;
  bool? isCompleted;
  String? status;
  String? amount;
  String? amountToken;
  String messageErr;

  RechargeInformationDto({
    this.networkName,
    this.type,
    this.tokenType,
    this.tokenSymbol,
    this.addressFrom,
    this.addressTo,
    this.isCompleted,
    this.status,
    this.amount,
    this.amountToken,
    this.txID,
    this.createdDate,
    this.expireTime,
    this.ttl,
    this.explorerUrl,
    this.accountPath,
    this.txPath,
    this.messageErr = '',
  });

  Map<String, dynamic> toJson() => {
    jsonEncode('type'): jsonEncode(this.type),
    jsonEncode('tokenType'): jsonEncode(this.tokenType),
    jsonEncode('tokenSymbol'): jsonEncode(this.tokenSymbol),
    jsonEncode('addressFrom'): jsonEncode(this.addressFrom),
    jsonEncode('addressTo'): jsonEncode(this.addressTo),
    jsonEncode('isCompleted'): jsonEncode(this.isCompleted),
    jsonEncode('status'): jsonEncode(this.status),
    jsonEncode('txId'): jsonEncode(this.txID),
    jsonEncode('amount'): jsonEncode(this.amount),
    jsonEncode('amountToken'): jsonEncode(this.amountToken),
    jsonEncode('createdDate'): jsonEncode(this.createdDate),
    jsonEncode('networkName'): jsonEncode(this.networkName),
  };

  Map<String, dynamic> toJSONEncodable() {
    Map<String, dynamic> m = new Map();

    m['type'] = type;
    m['tokenType'] = tokenType;
    m['tokenSymbol'] = tokenSymbol;
    m['address'] = addressTo;
    m['isCompleted'] = isCompleted;
    m['status'] = status;
    m['txId'] = txID;
    m['amount'] = amount;
    m['amountToken'] = amountToken;
    m['createdDate'] = createdDate;

    return m;
  }


  factory RechargeInformationDto.fromSocketWaitingMap(Map<String, dynamic> map) => RechargeInformationDto(
    type: map['type']??0,
    tokenType: json.decode(map['content'])['tokenSelected']['token']['type'],
    tokenSymbol: json.decode(map['content'])['tokenSelected']['token']['symbol'],
    addressFrom: map['addressFrom'],
    addressTo: json.decode(map['content'])['toAddress'],
    isCompleted: map['isCompleted'],
    status: map['status'],
    amount: map['amount'],
    amountToken: map['amountToken'],
    txID: map['txId'],
    createdDate: map['createdAt'],
    expireTime: map['expireTime'],
    ttl: map['ttl'],
    networkName : json.decode(map['content'])['tokenSelected']['network']['name'],
    explorerUrl: json.decode(map['content'])['tokenSelected']['network']['explorerUrl'],
    accountPath: json.decode(map['content'])['tokenSelected']['network']['accountPath'],
    txPath: json.decode(map['content'])['tokenSelected']['network']['txPath'],
  );

  factory RechargeInformationDto.fromMap(Map<String, dynamic> map) => RechargeInformationDto(
    type: map['type']??0,
    tokenType: map['tokenType'],
    tokenSymbol: map['tokenSymbol'],
    addressFrom: map['addressFrom'],
    addressTo: map['addressTo'],
    isCompleted: map['isCompleted'],
    status: map['status'],
    amount: map['amount'].toString(),
    amountToken: map['amountToken'].toString(),
    txID: map['txID'],
    createdDate: map['createdAt']??map['createdDate'],
    expireTime: map['expireTime'],
    ttl: map['ttl'],
    networkName : map['networkName'],
    explorerUrl: map['network']['explorerUrl'],
    accountPath: map['network']['accountPath'],
    txPath: map['network']['txPath'],
  );

}