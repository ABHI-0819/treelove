abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiSuccess<T> extends ApiState {
  final T data;
  ApiSuccess(this.data);
}

class ApiFailure extends ApiState {
  final String message;
  ApiFailure(this.message);
}

class TokenExpired extends ApiState {
  final String message;
  TokenExpired(this.message);
}
