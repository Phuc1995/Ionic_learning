class ExchangeRateDto {
  int id;
  String? name;
  int? chainId;
  String type;
  String? address;
  String? symbol;
  int? decimals;
  String? logoUri;
  int? exchangeRate;
  String? networkId;
  String? contract;
  String? logoNetworkUri;

  ExchangeRateDto({
    required this.id,
    required this.type,
    this.chainId,
    this.address,
    this.name,
    this.symbol,
    this.decimals,
    this.logoUri,
    this.exchangeRate,
    this.networkId,
    this.contract,
    this.logoNetworkUri,
  });

  factory ExchangeRateDto.fromMap(dynamic map) => ExchangeRateDto(
    id: int.parse(map['id']),
    chainId: map['chainId'],
    type: map['type'],
    address: map['address'],
    name: map['name'],
    symbol: map['symbol'],
    decimals: map['decimals'],
    logoUri: map['logoUri'],
    exchangeRate: map['exchangeRate'],
    networkId: map['networkId'],
  );
}