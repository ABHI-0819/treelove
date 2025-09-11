abstract class ApiEvent {}

class ApiAdd<T> extends ApiEvent {
  final T data;
  ApiAdd(this.data);
}

class ApiListFetch extends ApiEvent {
  final int? page;
  final int? pageSize;
  final String? filter;
  final String? search;
  final String? serviceName;
  final String? projectAreaId;
  //String? areaId,   String? vendorId,   String? createdBy,
  final String? areaId;
  final String? diseasesId;
  final  String? vendorId;
  final String ? maintenanceStatus;
  final String? createdBy;
  ApiListFetch({this.page, this.pageSize, this.filter, this.search, this.serviceName, this.projectAreaId,this.areaId,this.diseasesId,this.vendorId,this.maintenanceStatus,this.createdBy});
}

class ApiFetch extends ApiEvent {
  final String ? id;
  final String ? projectId;
  final String ? projectAreaId;
  final String ? orderId;
  ApiFetch({this.id,this.projectId,this.projectAreaId,this.orderId});
}

class ApiSearch extends ApiEvent {
  final String query;
  ApiSearch(this.query);
}

class ApiUpdate<T> extends ApiEvent {
  final T data;
  ApiUpdate(this.data);
}

class ApiDelete extends ApiEvent {
  final dynamic id;
  ApiDelete(this.id);
}

class ApiLogout extends ApiEvent {
  final String refreshToken;

  ApiLogout(this.refreshToken);
}

/*
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_event.freezed.dart';

@freezed
class ApiEvent<T> with _$ApiEvent<T> {
  const factory ApiEvent.add(T data) = ApiAdd<T>;
  const factory ApiEvent.fetch() = ApiFetch<T>;
  const factory ApiEvent.search(String query) = ApiSearch<T>;
  const factory ApiEvent.update(T data) = ApiUpdate<T>;
  const factory ApiEvent.delete(dynamic id) = ApiDelete<T>;
}

 */



