import 'dart:async';
import 'dart:io';
import 'package:common_module/common_module.dart';
import 'package:common_module/utils/firebase/firebase_message.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';
import 'package:zalo_flutter/zalo_flutter.dart';
import 'app_module.dart';
import 'app_widget.dart';

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
  if (Platform.isIOS) SharedPreferencesIOS.registerWith();
  await Firebase.initializeApp();

  print('Handling a background message ${message.messageId}');
  await FirebaseMessage.show(message);
}

// Add this function
Future<void> _initZaloFlutter() async {
  if (Platform.isAndroid) {
    final hashKey = await ZaloFlutter.getHashKeyAndroid();
    print('HashKey: $hashKey');
  }
}

Future<void> initSharedPreference() async {
  final _sharedPreference = await SharedPreferenceHelper.getInstance();
  _sharedPreference.setStorageServer(dotenv.env['STORAGE_SERVER']!);
  _sharedPreference.setBucketName(dotenv.env['ENV_NAME']!);
}

Future<dynamic> run() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
  if (Platform.isIOS) SharedPreferencesIOS.registerWith();
  await initSharedPreference();
  await Firebase.initializeApp();
  await FirebaseMessage.initialize();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SocketClient.init(SocketType.idol);
  await setPreferredOrientations();
  await _initZaloFlutter();
  return runZonedGuarded(() async {

    //config flutter_modular library
    runApp(ModularApp(module: AppModule(), child: AppWidget()));

  }, (error, stack) {
    print(stack);
    print(error);
  });
}


Future<void> main() async {
  await dotenv.load(fileName: ".env");
  FlavorConfig(
    name: dotenv.env['ENV_NAME']??'dev',
  );
  return await run();
}
