class POSM {
  String id;
  String name;
  String imagePath;
  String storeId;
  String active;

  POSM({required this.id, required this.name, required this.imagePath, required this.storeId, required this.active});

  factory POSM.fromJson(dynamic json) {
    return POSM(
        id: json['id'], name: json['name'], imagePath: json['imagePath'], storeId: json['storeId'], active: json['active']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pposmId'] = this.id;
    data['pposmName'] = this.name;
    data['imagePath'] = this.imagePath;
    data['storeId'] = this.storeId;
    data['active'] = this.active;
    return data;
  }

  POSM copyWith({String? id, String? name, String? active, String? storeId, String? imagePath}) {
    return POSM(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
      imagePath: imagePath ?? this.imagePath,
      storeId: storeId ?? this.storeId
    );
  }
}
