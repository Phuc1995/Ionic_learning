import 'dart:io';

import 'package:walletconnect_dart/walletconnect_dart.dart';

class PaymentContants {
  PaymentContants._();

  // transaction history
  static const int LIMIT_ITEM = 20;
  static const String ITEM = 'items';
  static const String TOTAL_PAGE = 'totalPages';
  static const String ALL = "ALL";
  static const String NEW = "NEW";
  static const String PROCESSING = "PROCESSING";
  static const String COMPLETED = "COMPLETED";
  static const String FAILED = "FAILED";
  static const String LIMIT= "limit";
  static const String PAGE= "page";
  static const String NETWORK= "network";
  static const String TRANSACTION_DATE= "transactionDate";
  static const String TOKEN_TYPE= "tokenType";
  static const String STATUS= "status";
  static const String TOP_UP_CACHE_DELETE_MESSAGE_CODE= "DELETE_TOP_UP_CACHE_SUCCESS";
  static const int TTL = 900;

  //statistic
  static const int LIMIT_ITEM_STATISTIC = 10;

  // Deeplink
  static const String TRUST_UNIVERSAL_LINK = "https://link.trustwallet.com";
  static final String TRUST_GET_APP_LINK = Platform.isIOS ? 'https://apps.apple.com/app/apple-store/id1288339409?mt=8' : 'https://play.google.com/store/apps/details?id=com.wallet.crypto.trustapp&referrer=utm_source%3Dwebsite';
  static const String TRUST_DEEP_LINK = "trust://";

  // Wallet connect
  static const String WC_BRIDGE = 'https://bridge.walletconnect.org';
  static const PeerMeta WC_PEER_META = PeerMeta(
    name: 'GLive',
    description: 'GLive',
    url: 'https://glivedev.xyz',
    icons: ['https://glivedev.xyz/favicon/favicon-96x96.png'],
  );

  static const String TRC_20 = 'TRC20';
  static const String BEP_20 = 'TRC20';
}