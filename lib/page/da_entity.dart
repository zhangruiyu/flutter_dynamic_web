class OkEntity {
  String method;
  String id;
  String jsonrpc;
  List<Null> params;

  OkEntity({this.method, this.id, this.jsonrpc, this.params});

  OkEntity.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    id = json['id'];
    jsonrpc = json['jsonrpc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['id'] = this.id;
    data['jsonrpc'] = this.jsonrpc;
    return data;
  }
}
