import 'package:common_module/common_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:payment/contants/contants.dart';
import 'package:payment/dto/dto.dart';
import 'package:payment/service/top_up_service.dart';
import 'package:payment/service/wc_session_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class RechargeCryptoController extends GetxController {
  RechargeCryptoController();
  late SharedPreferenceHelper _sharedPrefsHelper = Modular.get<SharedPreferenceHelper>();
  final _topUpService = Modular.get<TopUpService>();
  var information = RechargeInformationDto().obs;
  Rx<num> numMoney = 0.obs;
  //0 is connect via Wallet, 1 is manual
  var currentType = 0.obs;

  var currentNetwork = NetworkDto(id: 0).obs;
  var currentToken = ExchangeRateDto(id: 0, type: PaymentContants.TRC_20).obs;
  var tokens = <ExchangeRateDto>[].obs;
  var networks = <NetworkDto>[].obs;
  var packageAmount = <int>[].obs;
  var packageSelect = 0.obs;

  var amountErr = ''.obs;
  var currentTypeConnect = ''.obs;
  var userWallet = Map<int, String>().obs;

  var loading = false.obs;
  var success = false.obs;
  var isNoNetwork = false.obs;

  var wcConnector = WalletConnect(
    bridge: PaymentContants.WC_BRIDGE,
    clientMeta: PaymentContants.WC_PEER_META,
  ).obs;
  var wcConnectedAddress = ''.obs;

  @override
  void onInit() {
    this.packageAmount.value = [5, 10, 20, 50, 100, 200];
    this.packageSelect.value = this.packageAmount.value[0];
    initWalletConnect();
    super.onInit();
  }

  initWalletConnect() async {
    WcSessionService _wcSessionService = WcSessionService();
    var session = await _wcSessionService.getSession();
    // Create a connector
    this.wcConnector.value = WalletConnect(
      bridge: PaymentContants.WC_BRIDGE,
      clientMeta: PaymentContants.WC_PEER_META,
      session: session,
      sessionStorage: _wcSessionService,
    );
    this.wcConnector.refresh();

    if (session != null) {
      final sessionStatus = await this.wcConnector.value.connect();
      wcConnectedAddress.value = sessionStatus.accounts[0];
      wcConnectedAddress.refresh();
    }

    // Subscribe to events
    this.wcConnector.value.on<SessionStatus>('connect', (session) async {
      print('========WC connect event=========');
      print(session);
      wcConnectedAddress.value = session.accounts[0];
      wcConnectedAddress.refresh();
    });
    this.wcConnector.value.on('session_update', (payload) {
      print('========WC session_update event=========');
      print(payload);
    });
    this.wcConnector.value.on('disconnect', (session) {
      print('========WC disconnect event=========');
      print(session);
      _wcSessionService.removeSession();
      wcConnectedAddress.value = '';
      this.initWalletConnect();
    });
  }

  Future<void> getNetworks() async {
    final network = await _topUpService.getNetwork();
    network.fold((failure) {
      this.isNoNetwork.value = true;
      this.loading.value = false;
    }, (data) {
      this.loading.value = false;
      this.networks.value = data;
      this.networks.refresh();
      this.networks.forEach((item) {
        this.tokens.addAll(item.exchangeRates!);
      });
      this.currentToken.value = this.tokens[0];
      this.setCurrentNetwork(this.currentToken.value.networkId!);
      this.isNoNetwork.value = false;
    });
  }

  setCurrentNetwork(String networkId) {
    final index = this.networks.indexWhere((element) => element.id.toString() == networkId);
    if (index >= 0) {
      this.currentNetwork.value = this.networks[index];
    }
  }

  List<ExchangeRateDto> getTokenItems() {
    final index = this.networks.indexWhere((element) {
      return element.name == this.currentNetwork.value.name;
    });
    if (index >= 0) {
      return this.networks[index].exchangeRates!;
    }
    return [];
  }

  Future<bool> openMetaMask(
      {required int chainId,
      required String contractAddress,
      required String address,
      required int amount,
      int decimals = 18}) async {
    final url =
        'https://metamask.app.link/send/${contractAddress}@${chainId}/transfer?address=${address}&uint256=${amount}e${decimals}';
    if (await canLaunch(url)) {
      final opened = await launch(url);
      print('Open meta mask ' + opened.toString());
      return opened;
    }
    return false;
  }

  Future<bool> sendTokenTrustWallet(
      {required int coinId,
      required String contractAddress,
      required String address,
      required int amount,
      int decimals = 18}) async {
    final url =
        'send?asset=c${coinId}_t${contractAddress}&address=${address}&amount=${amount}&memo=glive-recharge';
    print(url);
    if (await canLaunch('${PaymentContants.TRUST_DEEP_LINK}$url')) {
      print('${PaymentContants.TRUST_DEEP_LINK}$url');
      return await launch('${PaymentContants.TRUST_DEEP_LINK}$url');
    } else {
      return await launch('${PaymentContants.TRUST_GET_APP_LINK}');
    }
  }

  Future<bool> openTrustWallet() async {
    if (await canLaunch('${PaymentContants.TRUST_DEEP_LINK}')) {
      return await launch('${PaymentContants.TRUST_DEEP_LINK}');
    } else {
      return await launch('${PaymentContants.TRUST_UNIVERSAL_LINK}');
    }
  }

}
