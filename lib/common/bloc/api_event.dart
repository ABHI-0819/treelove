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
  ApiListFetch({this.page, this.pageSize, this.filter, this.search});
}

class ApiFetch extends ApiEvent {
  final String ? id;
  ApiFetch({this.id});
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



