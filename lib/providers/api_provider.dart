import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jti_app/models/posm.dart';
import 'package:jti_app/models/posm_store_mapping.dart';
import 'package:jti_app/models/store.dart';
import 'package:jti_app/models/store_status.dart';
import 'package:jti_app/providers/constants.dart';

class APIProvider {
  Future<List<StoreStatus>> fetchDropdownItems() async {
    final response =
        await http.get(Uri.parse('${Constants.API_URL}storeStatusType/all'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<StoreStatus> dropdownItems =
          (jsonData['data'] as List<dynamic>).map((item) {
        return StoreStatus(
          item['id'],
          item['name'],
        );
      }).toList();
      return dropdownItems;
    } else {
      throw Exception('Failed to fetch dropdown items');
    }
  }

  Future<List<Store>> getListStoreByUser(int userId) async {
    final response = await http
        .get(Uri.parse('${Constants.API_URL}store/getByUserId/$userId'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<Store> store = (jsonData['data'] as List<dynamic>).map((item) {
        return Store(
            id: item['id'].toString(),
            storeName: item['storeName'].toString(),
            provinceId: item['provinceId'].toString(),
            districtId: item['districtId'].toString(),
            address: item['address'],
            lat: item['lat'],
            long: item['long'],
            status: item['status'] ?? '',
            contactName: item['contactName'],
            phoneNumber: item['phoneNumber'],
            userId: item['userId'].toString(),
            calendar: item['calendar'],
            reward: item['reward'].toString(),
            isDone: item['isDone'].toString(),
            provinceName: item['provinceName'],
            districName: item['districName'],
            statusName: item['statusName'] ?? '',
            userFirstName: item['userFirstName'],
            userLastName: item['userLastName'],
            note: item['note'] ?? '',
            winnerName: item['winnerName'] ?? '',
            winnerBankName: item['winnerBankName'] ?? '',
            winnerBankNumber: item['winnerBankNumber'] ?? '',
            winnerRelationship: item['winnerRelationship'] ?? '',
            storeCode: item['storeCode']);
      }).toList();

      return store;
    } else {
      throw Exception('Failed to fetch list store by user');
    }
  }

  Future<Store> getDetailStore(String storeId) async {
    final response =
        await http.get(Uri.parse('${Constants.API_URL}store/detail/$storeId'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      //print(jsonData);
      final storeApi = jsonData['data'];
      Store store = Store(
          id: storeApi['id'].toString(),
          storeName: storeApi['storeName'],
          provinceId: storeApi['provinceId'].toString(),
          districtId: storeApi['districtId'].toString(),
          address: storeApi['address'],
          lat: storeApi['lat'],
          long: storeApi['long'],
          status: storeApi['status'] ?? '',
          contactName: storeApi['contactName'],
          phoneNumber: storeApi['phoneNumber'],
          userId: storeApi['userId'].toString(),
          calendar: storeApi['calendar'],
          reward: storeApi['reward'].toString(),
          isDone: storeApi['isDone'].toString(),
          provinceName: storeApi['provinceName'],
          districName: storeApi['districName'],
          statusName: storeApi['statusName'] ?? '',
          userFirstName: storeApi['userFirstName'],
          userLastName: storeApi['userLastName'],
          note: storeApi['note'] ?? '',
          winnerName: storeApi['winnerName'] ?? '',
          winnerBankName: storeApi['winnerBankName'] ?? '',
          winnerBankNumber: storeApi['winnerBankNumber'] ?? '',
          winnerRelationship: storeApi['winnerRelationship'] ?? '',
          storeCode: storeApi['storeCode']);
      return store;
    } else {
      throw Exception('Failed to fetch detail store');
    }
  }

  Future<bool> uploadImage(String storeId, List<String> imagesPath,
      String typeCode, String lat, String long, String posmId) async {
    var uri = Uri.parse(
        '${Constants.API_URL}storeImage/uploadImages/$storeId/$typeCode/$lat/$long/$posmId');
    var request = http.MultipartRequest('POST', uri);
    var i = 0;
    for (var imagePath in imagesPath) {
      var file = File(imagePath);
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();
      var multipartFile = http.MultipartFile('images[$i]', stream, length,
          filename: file.path.split('/').last);
      request.files.add(multipartFile);
      request.fields['lat'] = lat;
      request.fields['long'] = long;
      request.fields['posmId'] = posmId;
      i++;
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Thành công");
      final respStr = await response.stream.bytesToString();
      print(respStr);
      return true; // Upload thành công
    } else {
      print("Thất bại");
      final respStr = await response.stream.bytesToString();
      print(respStr);
      return false; // Upload thất bại
    }
  }

  Future<dynamic> updateStore(Store store) async {
    try {
      final url = Uri.parse('${Constants.API_URL}store/update');
      final request = http.Request('POST', url);

      request.bodyFields = {
        'storeId': store.id,
        'storeName': store.storeName,
        'provinceId': store.provinceId,
        'districtId': store.districtId,
        'address': store.address,
        'lat': store.lat,
        'long': store.long,
        'status': store.status,
        'contactName': store.contactName,
        'phoneNumber': store.phoneNumber,
        'userId': store.userId,
        'calendar': store.calendar,
        'reward': store.reward,
        'isDone': store.isDone,
        'provinceName': store.provinceName,
        'districtName': store.districName,
        'statusName': store.statusName,
        'userFirstName': store.userFirstName,
        'userLastName': store.userLastName,
        'note': store.note,
        'storeCode': store.storeCode
      };

      // print('Sending request to update store...');
      // print(request.bodyFields);

      final response = await http.Client().send(request);
      final responseJson = await http.Response.fromStream(response);

      //print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseJson.body);
        //print('Response from server: $jsonData');
        return jsonData;
      } else {
        //print('Failed to update store. Status code: ${response.statusCode}');
        throw Exception('Failed to update store');
      }
    } catch (e) {
      //print('Error while updating store: $e');
      throw Exception('Failed to update store: $e');
    }
  }

  Future<List<Store>> getListStoreIsDone() async {
    try {
      final url = Uri.parse('${Constants.API_URL}store/filterReport');
      final request = http.Request('POST', url);

      request.bodyFields = {
        'isDone': '1',
      };

      final response = await http.Client().send(request);
      final responseJson = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseJson.body);
        final List<dynamic> data = jsonData['data'];

        List<Store> stores = data.map((item) {
          return Store(
              id: item['id'].toString(),
              storeName: item['storeName'],
              provinceId: item['provinceId'].toString(),
              districtId: item['districtId'].toString(),
              address: item['address'],
              lat: item['lat'],
              long: item['long'],
              status: item['status'],
              contactName: item['contactName'],
              phoneNumber: item['phoneNumber'],
              userId: item['userId'].toString(),
              calendar: item['calendar'],
              reward: item['reward'].toString(),
              isDone: item['isDone'].toString(),
              provinceName: item['provinceName'],
              districName: item['districName'],
              statusName: item['statusName'],
              userFirstName: item['userFirstName'],
              userLastName: item['userLastName'],
              note: item['note'] ?? '',
              winnerName: item['winnerName'] ?? '',
              winnerBankName: item['winnerBankName'] ?? '',
              winnerBankNumber: item['winnerBankNumber'] ?? '',
              winnerRelationship: item['winnerRelationship'] ?? '',
              storeCode: item['storeCode']);
        }).toList();

        return stores;
      } else {
        //print('Failed to fetch data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      //print('Error while fetching data: $e');
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<List<POSM>> getListPOSM(String storeId) async {
    final response = await http
        .get(Uri.parse('${Constants.API_URL}pposm/getByStore/$storeId'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<POSM> posm = (jsonData['data'] as List<dynamic>).map((item) {
        return POSM(
            id: item['pposmId'],
            name: item['pposmName'],
            imagePath: item['imagePath'],
            storeId: item['storeId'].toString(),
            active: item['active'].toString());
      }).toList();

      return posm;
    } else {
      throw Exception('Failed to fetch list store by user');
    }
  }

  Future<dynamic> updatePOSMStatus(List<POSM> posmList) async {
    try {
      final url = Uri.parse('${Constants.API_URL}pposm/updateMapping');
      final request = http.Request('POST', url);

      List<Map<String, dynamic>> posmData = posmList.map((posm) {
        return {
          'storeId': posm.storeId,
          'pposmId': posm.id,
          'status': posm.active
        };
      }).toList();

      request.body = jsonEncode(posmData);

      print('Sending request to update POSM...');
      print(request.body);

      final response = await http.Client().send(request);
      final responseJson = await http.Response.fromStream(response);

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseJson.body);
        print('Response from server: $jsonData');
        return jsonData;
      } else {
        print('Failed to update store. Status code: ${response.statusCode}');
        throw Exception('Failed to update store');
      }
    } catch (e) {
      //print('Error while updating store: $e');
      throw Exception('Failed to update store: $e');
    }
  }

  Future<dynamic> updateWinnerStore(
      String storeId,
      String winnerName,
      String winnerBankName,
      String winnerBankNumber,
      String winnerRelationship) async {
    try {
      final url = Uri.parse('${Constants.API_URL}store/updateWinnerToStore');
      final request = http.Request('POST', url);

      request.bodyFields = {
        'storeId': storeId,
        "winnerName": winnerName,
        "winnerBankName": winnerBankName,
        "winnerBankNumber": winnerBankNumber,
        "winnerRelationship": winnerRelationship
      };

      print('Sending request to update store...');
      print(request.bodyFields);

      final response = await http.Client().send(request);
      final responseJson = await http.Response.fromStream(response);

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseJson.body);
        print('Response from server: $jsonData');
        return jsonData;
      } else {
        print('Failed to update store. Status code: ${response.statusCode}');
        throw Exception('Failed to update store');
      }
    } catch (e) {
      print('Error while updating store: $e');
      throw Exception('Failed to update store: $e');
    }
  }

  Future<List<String>> fetchBankData() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.vietqr.io/v2/banks'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> banksData = data['data'];
        List<String> bankNames = ["Không có thông tin"];
        for (var item in banksData) {
          String bankName = '${item['name']} - ${item['shortName']}';
          bankNames.add(bankName);
        }
        return bankNames;
      } else {
        throw Exception('Failed to load banks');
      }
    } catch (e) {
      //print('Error: $e');
      throw e;
    }
  }

  Future<List<String>> fetchImages(String storeId) async {
    final response = await http
        .get(Uri.parse('${Constants.API_URL}storeImage/getByStore/$storeId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];

      List<String> imagePaths = [];

      for (var item in data) {
        String imagePath = item['imagePath'];
        imagePaths.add(imagePath);
      }

      return imagePaths;
    } else {
      throw Exception('Failed to load images');
    }
  }

  // Future<dynamic> updateQuestionPOSM(
  //     String storeId,
  //     String posmId,
  //     String question_1,
  //     String question_2,
  //     String question_3,) async {
  //   try {
  //     final url = Uri.parse('${Constants.API_URL}pposm/updateQuestion');
  //     final request = http.Request('POST', url);

  //     request.bodyFields = {
  //       'storeId': storeId,
  //       "pposmId": posmId,
  //       "question1": question_1,
  //       "question2": question_2,
  //       "question3": question_3
  //     };

  //     print('Sending request to update store...');
  //     print(request.bodyFields);

  //     final response = await http.Client().send(request);
  //     final responseJson = await http.Response.fromStream(response);

  //     print('Response status code: ${response.statusCode}');

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(responseJson.body);
  //       print('Response from server: $jsonData');
  //       return jsonData;
  //     } else {
  //       print('Failed to update store. Status code: ${response.statusCode}');
  //       throw Exception('Failed to update store');
  //     }
  //   } catch (e) {
  //     print('Error while updating store: $e');
  //     throw Exception('Failed to update store: $e');
  //   }
  // }

  // Future<dynamic> updateQuestionsList(
  //     String storeId, String posmId, String quuestion1, String question2, String question3) async {
  //   try {
  //     final url = Uri.parse('${Constants.API_URL}pposm/updateQuestion');
  //     final request = http.Request('POST', url);

  //     request.bodyFields = {
  //       'storeId': storeId,
  //       'pposmId': posmId,
  //       'quuestion1': quuestion1,
  //       'question2': question2,
  //       'question3': question3
  //     };

  //     print('Sending request to update store...');
  //     print(request.bodyFields);

  //     final response = await http.Client().send(request);
  //     final responseJson = await http.Response.fromStream(response);

  //     print('Response status code: ${response.statusCode}');

  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(responseJson.body);
  //       print('Response from server: $jsonData');
  //       return jsonData;
  //     } else {
  //       print('Failed to update store. Status code: ${response.statusCode}');
  //       throw Exception('Failed to update store');
  //     }
  //   } catch (e) {
  //     print('Error while updating store: $e');
  //     throw Exception('Failed to update store: $e');
  //   }
  // }

  Future<dynamic> updateQuestionsList(List<POSMStore> posmList) async {
    try {
      final url = Uri.parse('${Constants.API_URL}pposm/updateQuestion');
      final request = http.Request('POST', url);

      List<Map<String, dynamic>> posmData = posmList.map((posm) {
        return {
          'storeId': posm.storeId,
          'pposmId': posm.pposmId,
          'question1': posm.question1,
          'question2': posm.question2,
          'question3': posm.question3,
          'question4': posm.question4,
          'question5': posm.question5,
          'description': posm.description
        };
      }).toList();

      request.body = jsonEncode(posmData);

      print('Sending request to update POSM...');
      print(request.body);

      final response = await http.Client().send(request);
      final responseJson = await http.Response.fromStream(response);

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(responseJson.body);
        print('Response from server: $jsonData');
        return jsonData;
      } else {
        print('Failed to update store. Status code: ${response.statusCode}');
        throw Exception('Failed to update store');
      }
    } catch (e) {
      //print('Error while updating store: $e');
      throw Exception('Failed to update store: $e');
    }
  }
}
