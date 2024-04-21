enum SocketType {
  idol,
  viewer
}

extension SocketTypeToString on SocketType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
