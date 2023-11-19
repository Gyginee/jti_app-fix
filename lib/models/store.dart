class Store {
  String id;
  String storeName;
  String provinceId;
  String districtId;
  String address;
  String lat;
  String long;
  String status;
  String contactName;
  String phoneNumber;
  String userId;
  String calendar;
  String reward;
  String isDone;
  String provinceName;
  String districName;
  String statusName;
  String userFirstName;
  String userLastName;
  String note = '';
  String winnerName;
  String winnerBankName;
  String winnerBankNumber;
  String winnerRelationship;
  String storeCode;

  Store(
      {required this.id,
      required this.storeName,
      required this.provinceId,
      required this.districtId,
      required this.address,
      required this.lat,
      required this.long,
      required this.status,
      required this.contactName,
      required this.phoneNumber,
      required this.userId,
      required this.calendar,
      required this.reward,
      required this.isDone,
      required this.provinceName,
      required this.districName,
      required this.statusName,
      required this.userFirstName,
      required this.userLastName,
      required this.note,
      required this.winnerName,
      required this.winnerBankName,
      required this.winnerBankNumber,
      required this.winnerRelationship,
      required this.storeCode
      });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storeName': storeName,
      'provinceId': provinceId,
      'districtId': districtId,
      'address': address,
      'lat': lat,
      'long': long,
      'status': status,
      'contactName': contactName,
      'phoneNumber': phoneNumber,
      'userId': userId,
      'calendar': calendar,
      'reward': reward,
      //'isDone': isDone,
      'provinceName': provinceName,
      'districtName': districName,
      'statustName': statusName,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'note': note,
      'winnerName': winnerName,
      'winnerBankName': winnerBankName,
      'winnerBankNumber': winnerBankNumber,
      'winnerRelationship': winnerRelationship,
      'storeCode': storeCode
    };
  }

  factory Store.fromJson(dynamic json) {
    return Store(
        id: json['id'],
        storeName: json['storeName'],
        provinceId: json['provinceId'],
        districtId: json['districtId'],
        address: json['address'],
        lat: json['lat'],
        long: json['long'],
        status: json['status'],
        contactName: json['contactName'],
        phoneNumber: json['phoneNumber'],
        userId: json['userId'],
        calendar: json['calendar'],
        reward: json['reward'],
        isDone: json['isDone'] ?? '',
        provinceName: json['provinceName'],
        districName: json['districName'] ?? '',
        statusName: json['statusName'] ?? '',
        userFirstName: json['userFirstName'],
        userLastName: json['userLastName'],
        note: json['note'],
        winnerName: json['winnerName'],
        winnerBankName: json['winnerBankName'],
        winnerBankNumber: json['winnerBankNumber'],
        winnerRelationship: json['winnerRelationship'],
        storeCode: json['storeCode']);
  }
}
