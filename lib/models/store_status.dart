class StoreStatus {
  String id = '';
  String name = '';

  StoreStatus(this.id, this.name);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    return map;
  }

  StoreStatus.fromJson(dynamic json) {
    id = json["id"];
    name = json["name"];
  }
}
