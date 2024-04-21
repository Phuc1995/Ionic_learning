import 'package:common_module/common_module.dart';

class AllListViewerPermissionEntity {
  String userUuid;
  String title;
  String fullName;
  String imageUrl;
  String gId;

  AllListViewerPermissionEntity(
      {
        required this.userUuid,
        required this.title,
        required this.fullName,
        required this.imageUrl,
        required this.gId,
      });

  factory AllListViewerPermissionEntity.fromMap(Map<String, dynamic> json) => AllListViewerPermissionEntity(
    userUuid: json['userUuid'],
    title: json['title'],
    fullName: json['viewer'][0]['fullName'],
    imageUrl: json['viewer'][0]['imageUrl'],
    gId: json['viewer'][0]['gId'],
  );
}
