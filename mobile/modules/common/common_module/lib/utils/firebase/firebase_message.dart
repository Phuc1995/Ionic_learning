import 'dart:convert';

import 'package:common_module/common_module.dart';
import 'package:common_module/utils/firebase/firebase_constants.dart';
import 'package:common_module/utils/notification/notification_subjects.dart';
import 'package:common_module/utils/socket-io/socket_message.dart';
import 'package:common_module/utils/extension/string_extension.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class FirebaseMessage {
  FirebaseConstants constants = FirebaseConstants();

  static final NotificationChannel defaultChannel = NotificationChannel(
      channelGroupKey: 'default_group',
      channelKey: 'default_channel',
      channelName: 'Default channel',
      channelDescription: 'Notification default channel',
      defaultColor: AppColors.pink[500]!,
      ledColor: Colors.green,
      importance: NotificationImportance.High
  );

  static Future<NotificationSettings> requestPermissions() async {
    return await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future<void> show(RemoteMessage message) async {
    String? imageUrl = message.data[FirebaseConstants.IMAGE_URL];
    if (imageUrl != null && imageUrl.isNotEmpty) {
      imageUrl = await imageUrl.normalizeFileUrl();
    }
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: message.hashCode,
        channelKey: defaultChannel.channelKey!,
        title: message.data[FirebaseConstants.TITLE],
        body: message.data[FirebaseConstants.BODY],
        notificationLayout: AwesomeStringUtils.isNullOrEmpty(imageUrl) ? NotificationLayout.Default : NotificationLayout.BigPicture,
        bigPicture: imageUrl,
        largeIcon: imageUrl,
        payload: {
          FirebaseConstants.TYPE: message.data[FirebaseConstants.TYPE],
          FirebaseConstants.DETAIL: message.data[FirebaseConstants.DETAIL],
        },
      )
    );
  }

  static Future<void> showMessage(SocketMessage message) async {
    String? imageUrl = message.imageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      imageUrl = await imageUrl.normalizeFileUrl();
    }
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: message.hashCode,
          channelKey: defaultChannel.channelKey!,
          title: message.title,
          body: message.body,
          notificationLayout: AwesomeStringUtils.isNullOrEmpty(imageUrl) ? NotificationLayout.Default : NotificationLayout.BigPicture,
          bigPicture: imageUrl,
          largeIcon: imageUrl,
          payload: {
            FirebaseConstants.TYPE: message.type,
            FirebaseConstants.DETAIL: message.data != null ? jsonEncode(message.data) : '',
          },
        )
    );
  }

  static Future<void> initialize() async {
    await requestPermissions();
    AwesomeNotifications().initialize(
        'resource://drawable/ic_notification',
        [
          defaultChannel,
        ],
        channelGroups: [
          NotificationChannelGroup(channelGroupkey: 'default_group', channelGroupName: 'Default channel'),
        ],
        debug: true,
    );
    AwesomeNotifications().actionStream.listen((receivedAction) {
      NotificationSubjects.actionSink.add(receivedAction);
    });
  }

  static void loadSingletonPage({required String targetPage, required Object arguments}){
    BuildContext context = GlobalState.navigatorKey.currentContext!;
    // Avoid to open the notification details page over another details page already opened
    Navigator.pushNamedAndRemoveUntil(context, targetPage,
            (route) => (route.settings.name != targetPage) || route.isFirst,
        arguments: arguments);
  }
}
