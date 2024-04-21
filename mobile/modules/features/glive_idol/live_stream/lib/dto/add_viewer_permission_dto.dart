class AddViewerPermissionDto {
  final String userUuid;
  final String title;
  final bool isRemove;

  AddViewerPermissionDto({required this.userUuid, required this.title, required this.isRemove});

  Map<String, dynamic> toJson() => {
    "userUuid": userUuid,
    "title": title,
  };
}
