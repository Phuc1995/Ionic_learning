import 'dart:async';
import './main.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.prod");
  FlavorConfig();
  return await run();
}
