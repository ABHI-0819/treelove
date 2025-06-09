abstract class ApiEvent {}

class ApiAdd<T> extends ApiEvent {
  final T data;
  ApiAdd(this.data);
}

class ApiFetch extends ApiEvent {}

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
