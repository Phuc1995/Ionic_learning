import 'dart:convert';

import 'package:common_module/common_module.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class WcSessionService extends SessionStorage {

  @override
  Future<WalletConnectSession?> getSession() async {
    final sharedPre = await SharedPreferenceHelper.getInstance();
    final json = sharedPre.getWcSession;
    if (json.isNotEmpty) {
      return WalletConnectSession.fromJson(jsonDecode(json));
    }
    return null;
  }

  @override
  Future removeSession() async {
    final sharedPre = await SharedPreferenceHelper.getInstance();
    await sharedPre.setWcSession('');
  }

  @override
  Future store(WalletConnectSession session) async {
    final sharedPre = await SharedPreferenceHelper.getInstance();
    await sharedPre.setWcSession(jsonEncode(session.toJson()));
  }
}