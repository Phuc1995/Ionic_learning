class ListDataNotificationParamDto{
  final String type;
  final int page;
  final int limit;

  ListDataNotificationParamDto({required this.type, required this.page, required this.limit});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "searchType": type,
    "page": page,
  };

}