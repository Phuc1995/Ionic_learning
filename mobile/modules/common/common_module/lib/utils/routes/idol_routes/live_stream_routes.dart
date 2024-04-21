part of 'idol_routes.dart';

class _LiveStreamRoutes {
  const _LiveStreamRoutes();
  final String root = '/live';

  final String livePreview = '/preview';
  String get livePreviewPage => root + livePreview;

  final String liveEnd = '/end';
  String get liveEndPage => root + liveEnd;
}
