import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCachedNetwork extends StatelessWidget {
  final String storageUrl;
  final String fileUrl;
  final String defaultAvatar;
  final BoxFit boxFit;
  const ImageCachedNetwork({Key? key, required this.storageUrl, required this.fileUrl, required this.defaultAvatar, this.boxFit = BoxFit.fitWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url = fileUrl.startsWith('http://') || fileUrl.startsWith('https://') ? fileUrl : (storageUrl + fileUrl);
    Widget img = fileUrl.isNotEmpty ? CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Image.asset(defaultAvatar),
      errorWidget: (context, url, error) => Image.asset(defaultAvatar), //CircleAvatar(backgroundImage: AssetImage(defaultAvatar), backgroundColor: Colors.white),
      imageBuilder: (context, imageProvider) =>  Image(
        image: imageProvider,
        fit: this.boxFit,
      ),
    ) : Image.asset(defaultAvatar) ;// CircleAvatar(backgroundImage: AssetImage(defaultAvatar), backgroundColor: Colors.white);
    return img;
  }
}
