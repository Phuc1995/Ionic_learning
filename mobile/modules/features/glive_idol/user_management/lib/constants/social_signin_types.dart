enum SocialSignInType {
  google,
  facebook,
  apple,
  zalo,
}

extension ParseToString on SocialSignInType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}