class GatewayResponse {
  dynamic data;
  String? messageCode;
  String? message;

  GatewayResponse({
    this.data,
    this.messageCode,
    this.message,
  });

  factory GatewayResponse.fromMap(Map<String, dynamic> map) => GatewayResponse(
    data: map["data"],
    messageCode: map["messageCode"],
    message: map["message"],
  );
}