class ViewerPermissionDto {
  String userUuid;
  String title;
  String fullName;
  String imageUrl;
  String gId;

  ViewerPermissionDto(
      {
        required this.userUuid,
        required this.title,
        required this.fullName,
        required this.imageUrl,
        required this.gId,
      });

  factory ViewerPermissionDto.fromMap(Map<String, dynamic> json) => ViewerPermissionDto(
    userUuid: json['userUuid'] ?? "",
    title: json['title'] ?? "",
    fullName: json['viewer'][0]['fullName'] ?? "",
    imageUrl: json['viewer'][0]['imageUrl'] ?? "",
    gId: json['viewer'][0]['id'] ?? "",
  );
}
