class ImagePath {
  String path;

  String type;

  bool isSuccess;

  String message;

  ImagePath({required this.path, required this.type, this.isSuccess = true, this.message = ''});
}
