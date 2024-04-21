import 'package:common_module/common_module.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:live_stream/domain/service/live_stream_service.dart';

class ListViewerPermission extends UseCase<Map, ListViewerPermissionParam>{
  late Either<Failure, Map> _response;

  Either<Failure, Map> get response => _response;

  @override
  Future<Either<Failure, Map>> call(ListViewerPermissionParam param) async{
    final liveService = Modular.get<LiveStreamService>();
    _response = await liveService.getListViewerPermission(param);
    return await _response;
  }
}

class ListViewerPermissionParam extends Equatable {
  final String title;
  final int page;
  final int limit;

  ListViewerPermissionParam({required this.page, required this.limit, required this.title,});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  Map<String, dynamic> toJson() => {
    "title": title,
    "limit": limit,
    "page": page,
  };
}

