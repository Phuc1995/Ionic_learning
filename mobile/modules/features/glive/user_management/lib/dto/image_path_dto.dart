class ImagePathDto {
  String path;

  String type;

  bool isSuccess;

  String message;

  ImagePathDto({required this.path, required this.type, this.isSuccess = true, this.message = ''});
}
