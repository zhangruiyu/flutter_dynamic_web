class NetException implements Exception {
  //正常数字错误码
  int code = 0;

  //后台可能返回奇怪的错误码
  String strCode;
  final String message;
  var data;

  NetException(code, this.message,[this.data]) {
    try {
      this.code = int.parse(code.toString());
    } catch (e) {
      strCode = code;
    }
  }

  String toString() {
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
