class MomoResponseDto {
  String requestId;
  String payUrl;
  String deeplink;
  String qrCodeUrl;

  MomoResponseDto(
      {
        required this.requestId,
        required this.payUrl,
        required this.deeplink,
        required this.qrCodeUrl,
      });

  factory MomoResponseDto.fromMap(Map<String, dynamic> json) => MomoResponseDto(
    requestId: json['requestId']??'',
    payUrl: json['payUrl']??'',
    deeplink: json['deeplink']??'',
    qrCodeUrl: json['qrCodeUrl']??'',
  );
}
