class ListViewerPermissionDto {
  final String title;
  final int page;
  final int limit;

  ListViewerPermissionDto({required this.page, required this.limit, required this.title,});

  Map<String, dynamic> toJson() => {
    "title": title,
    "limit": limit,
    "page": page,
  };
}
