class InfoParamsDto {
  final String field;
  final dynamic content;

  @override
  List<Object> get props => [field, content];

  InfoParamsDto({required this.field, required this.content});
}
