class ApiSuccessResponse<T> {
  final String? status;
  final String? message;
  final T? data;

  ApiSuccessResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ApiSuccessResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic data) fromJsonT,
  ) {
    return ApiSuccessResponse(
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
