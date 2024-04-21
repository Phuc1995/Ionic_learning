import 'package:common_module/utils/socket-io/socket_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class SocketClient {
  static Logger logger = Modular.get<Logger>();
  static String userUuid = '';
  static SocketType type = SocketType.viewer;
  static init(SocketType socketType) {
    type = socketType;
    final socket = getInstance();
    socket.hasListeners('connect');

    socket.onConnect((_) {
      logger.d('Socket connected');
      join();
    });
  }
  static IO.Socket? _instance;
  static IO.Socket getInstance() {
    if (_instance == null) {
      final url = dotenv.env['GATEWAY_SERVER']!;
      var opts = {
        'transports': ['websocket'],
        'autoConnect': true,
      };
      _instance = IO.io(url, opts);
    } else if (!_instance!.connected){
      _instance!.connect();
    }
    return _instance!;
  }

  static join() {
    if (userUuid.isNotEmpty) {
      final socket = getInstance();
      socket.emit('join', {
        'type': type.toShortString(),
        'userUuid': userUuid,
      });
      logger.d('Socket ${type.toShortString()} joined');
    }
  }

  static leave() {
    if (userUuid.isNotEmpty) {
      final socket = getInstance();
      socket.emit('leave', {
        'type': type.toShortString(),
        'userUuid': userUuid,
      });
      userUuid = '';
    }
    logger.d('Socket ${type.toShortString()} left');
  }
}
