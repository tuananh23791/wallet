class Info {
  static final Info _singleton = Info._internal();

  Info._internal();

  factory Info() {
    return _singleton;
  }

  String password;
}
