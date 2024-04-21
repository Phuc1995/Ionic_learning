import '../preference/shared_preference_helper.dart';

extension StringExtension on String {
  String shortUuid() {
    if (this.trim().isNotEmpty) {
      final split = this.trim().split('-');
      return split.last;
    }
    return this;
  }

  Future<String> normalizeFileUrl() async {
    SharedPreferenceHelper _pre = await SharedPreferenceHelper.getInstance();
    await _pre.reload();
    final storageUrl = '${_pre.storageServer}/${_pre.bucketName}/';
    String url = this.startsWith('http://') || this.startsWith('https://') ? this : (storageUrl + this);
    return url;
  }

  String formatPhoneVerify(){
    if (this.isEmpty) return this;
    if (this.length == 8) {
      return this.substring(0, 4) + '***' + this.substring(this.length - 2);
    } else if (this.length > 8) {
      return this.substring(0, 4) + '***' + this.substring(this.length - 4);
    } else {
      return this;
    }
  }

  String formatEmailVerify(){
    if (this.isEmpty) return this;
    List<String> strs = this.split('@');
    if (strs.length > 1) {
      String start = strs[0];
      if (strs[0].length > 3) {
        start = strs[0].substring(0, 3);
      }
      int dotIndex = strs[1].indexOf('.');
      String end = strs[1].substring(dotIndex);
      return start + '***@***' + end;
    } else {
      return this;
    }
  }
}
