import 'dart:convert';
import 'package:jti_app/models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveUserId(int userId) async {
    await init();
    _prefs?.setInt('user_id', userId);
  }

  static int? getUserId() {
    return _prefs?.getInt('user_id');
  }

  static Future<void> saveUsername(String userId) async {
    await init();
    _prefs?.setString('username', userId);
  }

  static String? getUsername() {
    return _prefs?.getString('username');
  }

  static void removeUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  // Lưu danh sách hình ảnh cho cửa hàng có ID là storeId
  static Future<void> saveImageOverview(
      String storeId, List<String> localFilePaths) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'localFilePaths_overview_${storeId}', localFilePaths);
  }

  // Khôi phục danh sách hình ảnh cho cửa hàng có ID là storeId
  static Future<List<String>> getImageOverview(String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? filePaths =
        prefs.getStringList('localFilePaths_overview_${storeId}');

    return filePaths ?? [];
  }

  static Future<void> saveImageCheckIn(
      String storeId, List<String> localFilePaths) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'localFilePaths_checkIn_${storeId}', localFilePaths);
  }

  static Future<List<String>> getImageCheckIn(String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? filePaths =
        prefs.getStringList('localFilePaths_checkIn_${storeId}');

    return filePaths ?? [];
  }

  static Future<void> saveImageCheckOut(
      String storeId, List<String> localFilePaths) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'localFilePaths_checkOut_${storeId}', localFilePaths);
  }

  static Future<List<String>> getImageCheckOut(String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? filePaths =
        prefs.getStringList('localFilePaths_checkOut_${storeId}');

    return filePaths ?? [];
  }

  static Future<void> saveImageHotZone(
      String storeId, List<String> localFilePaths) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'localFilePaths_hotZone_${storeId}', localFilePaths);
  }

  static Future<List<String>> getImageHotZone(String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? filePaths =
        prefs.getStringList('localFilePaths_hotZone_${storeId}');

    return filePaths ?? [];
  }

  // static Future<void> saveImageFee(
  //     String storeId, List<String> localFilePaths) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setStringList('localFilePaths_fee', localFilePaths);
  // }

  // static Future<List<String>> getImageHotFee(String storeId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? filePaths = prefs.getStringList('localFilePaths_fee');

  //   return filePaths ?? [];
  // }

  static Future<void> saveImageBill(
      String storeId, List<String> localFilePaths) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('localFilePaths_bill_${storeId}', localFilePaths);
  }

  static Future<List<String>> getImageBill(String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? filePaths =
        prefs.getStringList('localFilePaths_bill_${storeId}');

    return filePaths ?? [];
  }

  static Future<void> saveImagePosm(
      String posmId, List<String> localFilePaths, String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'localFilePaths_posm_${posmId}_${storeId}', localFilePaths);
  }

  static Future<List<String>> getImagePosm(
      String posmId, String storeId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? filePaths =
        prefs.getStringList('localFilePaths_posm_${posmId}_${storeId}');

    return filePaths ?? [];
  }

  static Future<void> saveImagesPOSM(String storeId, List<String> imagePaths,
      String typeCode, String latitude, String longitude, String posmId) async {
    List<Map<String, dynamic>>? imagesData = await getImagesPOSM();

    if (imagesData == null) {
      imagesData = [];
    }

    Map<String, dynamic> data = {
      'storeId': storeId,
      'imagePaths': imagePaths,
      'typeCode': typeCode,
      'latitude': latitude,
      'longitude': longitude,
      'posmId': posmId,
    };

    imagesData.add(data);

    await init();
    await _prefs?.setString('images_data', jsonEncode(imagesData));
  }

  static Future<List<Map<String, dynamic>>?> getImagesPOSM() async {
    await init();
    String? imagesDataString = _prefs?.getString('images_data');
    if (imagesDataString != null) {
      return jsonDecode(imagesDataString).cast<Map<String, dynamic>>();
    }
    return null;
  }

  // static Future<void> saveStoreInfo(
  //     String storeId, Map<String, dynamic> storeInfo) async {
  //   await init();
  //   _prefs?.setString('store_info_$storeId', jsonEncode(storeInfo));
  // }

  // static Map<String, dynamic>? getStoreInfo(String storeId) {
  //   String? storeInfoString = _prefs?.getString('store_info_$storeId');
  //   if (storeInfoString != null) {
  //     return jsonDecode(storeInfoString);
  //   }
  //   return null;
  // }

  // static Future<void> saveStoreInfoList(
  //     List<Map<String, dynamic>> storeList) async {
  //   await init();
  //   for (int i = 0; i < storeList.length; i++) {
  //     String storeId = storeList[i]['id'].toString(); // Chọn một key phù hợp
  //     _prefs?.setString('store_info_$storeId', jsonEncode(storeList[i]));
  //   }
  // }

  // static List<Map<String, dynamic>> getStoreInfoList(List<String> storeIds) {
  //   List<Map<String, dynamic>> resultList = [];
  //   for (int i = 0; i < storeIds.length; i++) {
  //     String? storeInfoString = _prefs?.getString('store_info_${storeIds[i]}');
  //     if (storeInfoString != null) {
  //       Map<String, dynamic> storeInfo = jsonDecode(storeInfoString);
  //       resultList.add(storeInfo);
  //     }
  //   }
  //   return resultList;
  // }

//   static Future<void> saveStoreInfo(
//       String storeId, Store storeInfo) async {
//     List<Store>? storeList =
//         await getStoreList(); // Lấy danh sách store từ SharedPreferences

//     if (storeList == null) {
//       storeList = [];
//     }

//     // Tìm cửa hàng trong danh sách theo storeId
//     int index = storeList.indexWhere((store) => store.id == storeId);

//     if (index != -1) {
//       // Nếu cửa hàng đã tồn tại trong danh sách, cập nhật thông tin
//       storeList[index] = storeInfo;
//     } else {
//       // Nếu cửa hàng chưa tồn tại, thêm vào danh sách
//       storeList.add(storeInfo);
//     }

//     await init();
//     await _prefs?.setString('store_list',
//         jsonEncode(storeList)); // Lưu danh sách store vào SharedPreferences
//   }

// // Hàm này dùng để lấy danh sách store từ SharedPreferences
//   static Future<List<Store>?> getStoreList() async {
//     await init();
//     String? storeListString = _prefs?.getString('store_list');
//     if (storeListString != null) {
//       return jsonDecode(storeListString).cast<Map<String, dynamic>>();
//     }
//     return null;
//   }

  // static Future<void> saveImageHotZoneToUpdate(
  //     String storeId,
  //     List<String> imagePaths,
  //     String type,
  //     String latitude,
  //     String longitude) async {
  //   await init();
  //   _prefs?.setStringList('imagePaths_hot_zone_$storeId', imagePaths);
  //   _prefs?.setString('type_hot_zone_$storeId', type);
  //   _prefs?.setString('latitude_hot_zone_$storeId', latitude);
  //   _prefs?.setString('longitude_hot_zone_$storeId', longitude);
  // }

  // static Future<Map<String, dynamic>> getImageHotZoneToUpdate(
  //     String storeId) async {
  //   await init();
  //   List<String>? imagePaths =
  //       _prefs?.getStringList('imagePaths_hot_zone_$storeId');
  //   String? type = _prefs?.getString('type_hot_zone_$storeId');
  //   String? latitude = _prefs?.getString('latitude_hot_zone_$storeId');
  //   String? longitude = _prefs?.getString('longitude_hot_zone_$storeId');

  //   return {
  //     'imagePaths': imagePaths ?? [],
  //     'type': type,
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  // }

  // static Future<void> savePOSMInfo(
  //     String storeId, List<List<String>> posmInfoList) async {
  //   await init();
  //   String key = 'posm_info_$storeId';
  //   await _prefs!.setStringList(
  //       key, posmInfoList.map((info) => info.join('|')).toList());
  // }

  // static Future<List<List<String>>?> getPOSMInfo(String storeId) async {
  //   await init();
  //   String key = 'posm_info_$storeId';
  //   List<String>? posmInfoStrings = _prefs!.getStringList(key);
  //   if (posmInfoStrings != null) {
  //     return posmInfoStrings.map((info) => info.split('|')).toList();
  //   } else {
  //     return null;
  //   }
  // }

  // static Future<void> saveImageOverviewToUpdate(
  //     String storeId,
  //     List<String> imagePaths,
  //     String type,
  //     String latitude,
  //     String longitude) async {
  //   await init();
  //   _prefs?.setStringList('imagePaths_overview_$storeId', imagePaths);
  //   _prefs?.setString('type_overview_$storeId', type);
  //   _prefs?.setString('latitude_overview_$storeId', latitude);
  //   _prefs?.setString('longitude_overview_$storeId', longitude);
  // }

  // static Future<Map<String, dynamic>> getImageOverviewToUpdate(
  //     String storeId) async {
  //   await init();
  //   List<String>? imagePaths =
  //       _prefs?.getStringList('imagePaths_overview_$storeId');
  //   String? type = _prefs?.getString('type_overview_$storeId');
  //   String? latitude = _prefs?.getString('latitude_overview_$storeId');
  //   String? longitude = _prefs?.getString('longitude_overview_$storeId');

  //   return {
  //     'imagePaths': imagePaths ?? [],
  //     'type': type,
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  // }

  // static Future<void> saveImageCheckinToUpdate(
  //     String storeId,
  //     List<String> imagePaths,
  //     String type,
  //     String latitude,
  //     String longitude) async {
  //   await init();
  //   _prefs?.setStringList('imagePaths_checkin_$storeId', imagePaths);
  //   _prefs?.setString('type_checkin_$storeId', type);
  //   _prefs?.setString('latitude_checkin_$storeId', latitude);
  //   _prefs?.setString('longitude_checkin_$storeId', longitude);
  // }

  // static Future<Map<String, dynamic>> getImageCheckinToUpdate(
  //     String storeId) async {
  //   await init();
  //   List<String>? imagePaths =
  //       _prefs?.getStringList('imagePaths_checkin_$storeId');
  //   String? type = _prefs?.getString('type_checkin_$storeId');
  //   String? latitude = _prefs?.getString('latitude_checkin_$storeId');
  //   String? longitude = _prefs?.getString('longitude_checkin_$storeId');

  //   return {
  //     'imagePaths': imagePaths ?? [],
  //     'type': type,
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  // }

  // static Future<void> saveImageCheckoutToUpdate(
  //     String storeId,
  //     List<String> imagePaths,
  //     String type,
  //     String latitude,
  //     String longitude) async {
  //   await init();
  //   _prefs?.setStringList('imagePaths_checkout_$storeId', imagePaths);
  //   _prefs?.setString('type_checkout_$storeId', type);
  //   _prefs?.setString('latitude_checkout_$storeId', latitude);
  //   _prefs?.setString('longitude_checkout_$storeId', longitude);
  // }

  // static Future<Map<String, dynamic>> getImageCheckoutToUpdate(
  //     String storeId) async {
  //   await init();
  //   List<String>? imagePaths =
  //       _prefs?.getStringList('imagePaths_checkout_$storeId');
  //   String? type = _prefs?.getString('type_checkout_$storeId');
  //   String? latitude = _prefs?.getString('latitude_checkout_$storeId');
  //   String? longitude = _prefs?.getString('longitude_checkout_$storeId');

  //   return {
  //     'imagePaths': imagePaths ?? [],
  //     'type': type,
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  // }

  // static Future<void> saveImageFeeToUpdate(
  //     String storeId,
  //     List<String> imagePaths,
  //     String type,
  //     String latitude,
  //     String longitude) async {
  //   await init();
  //   _prefs?.setStringList('imagePaths_fee_$storeId', imagePaths);
  //   _prefs?.setString('type_fee_$storeId', type);
  //   _prefs?.setString('latitude_fee_$storeId', latitude);
  //   _prefs?.setString('longitude_fee_$storeId', longitude);
  // }

  // static Future<Map<String, dynamic>> getImageFeeToUpdate(
  //     String storeId) async {
  //   await init();
  //   List<String>? imagePaths = _prefs?.getStringList('imagePaths_fee_$storeId');
  //   String? type = _prefs?.getString('type_fee_$storeId');
  //   String? latitude = _prefs?.getString('latitude_fee_$storeId');
  //   String? longitude = _prefs?.getString('longitude_fee_$storeId');

  //   return {
  //     'imagePaths': imagePaths ?? [],
  //     'type': type,
  //     'latitude': latitude,
  //     'longitude': longitude,
  //   };
  // }

  // static Future<void> savePOSMAnswers(
  //   String storeId,
  //   String posmId,
  //   String answer1,
  //   String answer2,
  //   String answer3,
  // ) async {
  //   List<Map<String, dynamic>>? posmAnswers =
  //       await getPOSMAnswers(storeId, posmId);

  //   if (posmAnswers == null) {
  //     posmAnswers = [];
  //   }

  //   posmAnswers.add({
  //     'posmId': posmId,
  //     'answer1': answer1,
  //     'answer2': answer2,
  //     'answer3': answer3,
  //   });

  //   await init();
  //   await _prefs?.setString('posm_answers_$storeId', jsonEncode(posmAnswers));
  // }

  // static Future<List<Map<String, dynamic>>?> getPOSMAnswers(
  //   String storeId,
  //   String posmId,
  // ) async {
  //   await init();
  //   String? posmAnswersString = _prefs?.getString('posm_answers_$storeId');
  //   if (posmAnswersString != null) {
  //     return jsonDecode(posmAnswersString).cast<Map<String, dynamic>>();
  //   }
  //   return null;
  // }

  static Future<void> saveStoreList(
      List<Store> storeList, Store newStore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Đầu tiên, lấy danh sách cửa hàng hiện có từ SharedPreferences
    List<Store> existingStoreList = await getStoreList();

    // Thêm cửa hàng mới vào danh sách hiện có
    existingStoreList.add(newStore);

    // Chuyển đổi danh sách mới thành chuỗi JSON và lưu vào SharedPreferences
    List<String> encodedList =
        existingStoreList.map((store) => jsonEncode(store.toJson())).toList();
    await prefs.setStringList('store_list', encodedList);
  }

  static Future<List<Store>> getStoreList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedList = prefs.getStringList('store_list');
    if (encodedList != null) {
      List<Store> storeList = encodedList
          .map((encodedStore) => Store.fromJson(jsonDecode(encodedStore)))
          .toList();
      return storeList;
    }
    return [];
  }

  Future<void> clearStoreList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('store_list');
}
}
