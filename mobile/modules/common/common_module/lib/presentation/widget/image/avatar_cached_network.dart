import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_module/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarCachedNetwork extends StatelessWidget {
  final String storageUrl;
  final String fileUrl;
  final String defaultAvatar;
  final bool isBlur;
  const AvatarCachedNetwork({Key? key, required this.storageUrl, required this.fileUrl, required this.defaultAvatar, this.isBlur = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url = fileUrl.startsWith('http://') || fileUrl.startsWith('https://') ? fileUrl : (storageUrl + fileUrl);
    Widget img = fileUrl.isNotEmpty ? CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => CircleAvatar(backgroundImage: AssetImage(defaultAvatar), backgroundColor: Colors.white),
      errorWidget: (context, url, error) => CircleAvatar(backgroundImage: AssetImage(defaultAvatar), backgroundColor: Colors.white),
      imageBuilder: (context, imageProvider) => CircleAvatar(backgroundImage: imageProvider, backgroundColor:  Colors.white, child: this.isBlur ? Container(
        decoration: BoxDecoration(
          gradient: AppColors.backgroundLoadingGradient,
          borderRadius: BorderRadius.all(Radius.circular(50.r)),
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.white.withOpacity(0.6), BlendMode.srcATop),
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
        ),
      ) : Container()),
    ) : CircleAvatar(backgroundImage: AssetImage(defaultAvatar), backgroundColor: Colors.white);
    return img;
  }
}
