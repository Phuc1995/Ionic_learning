
import 'package:payment/dto/top_up_exchange_rate_dto.dart';

class NetworkDto {
  int id;
  String? name;
  String? rpcUrl;
  String? wsRpcUrl;
  int? chainId;
  String? symbol;
  String? explorerUrl;
  String? explorerApiUrl;
  String? txPath;
  String? accountPath;
  int? decimals;
  String? type;
  String? coinType;
  int? coinId;
  String? derivationPath;
  String? logoUri;
  String? walletAddress;
  List<ExchangeRateDto>? exchangeRates;

  NetworkDto({
    required this.id,
    this.name,
    this.rpcUrl,
    this.wsRpcUrl,
    this.chainId,
    this.symbol,
    this.explorerUrl,
    this.explorerApiUrl,
    this.txPath,
    this.accountPath,
    this.decimals,
    this.type,
    this.coinType,
    this.coinId,
    this.derivationPath,
    this.exchangeRates,
    this.logoUri,
    this.walletAddress,
  });

  factory NetworkDto.fromMap(dynamic map) {
    final entity = NetworkDto(
      id: int.parse(map['id']),
      name: map['name'],
      rpcUrl: map['rpcUrl'],
      wsRpcUrl: map['wsRpcUrl'],
      chainId: map['chainId'],
      symbol: map['symbol'],
      explorerUrl: map['explorerUrl'],
      explorerApiUrl: map['explorerApiUrl'],
      txPath: map['txPath'],
      accountPath: map['accountPath'],
      decimals: map['decimals'],
      type: map['type'],
      coinType: map['coinType'],
      coinId: map['coinId'],
      derivationPath: map['derivationPath'],
      logoUri: map['logoUri'],
      walletAddress: map['walletAddress'],
      exchangeRates: [],
    );
    (map['exchangeRate']??[]).forEach((ex) {
      final exchangeRate = ExchangeRateDto.fromMap(ex);
      exchangeRate.logoNetworkUri = entity.logoUri;
      entity.exchangeRates!.add(exchangeRate);
    });
    return entity;
  }
}