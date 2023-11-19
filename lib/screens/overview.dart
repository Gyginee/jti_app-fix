import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jti_app/main.dart';
import 'package:jti_app/models/store.dart';
import 'package:jti_app/models/store_status.dart';
import 'package:jti_app/providers/api_provider.dart';
import 'package:jti_app/providers/constants.dart';
import 'package:jti_app/providers/shared.dart';
import 'package:jti_app/screens/bill.dart';
import 'package:jti_app/screens/fee.dart';
import 'package:jti_app/screens/homepage.dart';
import 'package:jti_app/screens/hot_zone.dart';
import 'package:jti_app/screens/posm.dart';
import 'package:jti_app/screens/posm_detail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jti_app/screens/store_list.dart';

class OverviewScreen extends StatefulWidget {
  final Store store;
  //List<String> localFilePaths = [];

  OverviewScreen({required this.store});
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  String? selectedOption; // Đây là giá trị được chọn từ Dropdown
  bool _isLoading = false;
  APIProvider apiProvider = APIProvider();
  List<StoreStatus> dropdownItems = [];
  StoreStatus dropdownValue = StoreStatus('', '');
  int? userId = UserData.getUserId();

  String latitude = '';
  String longitude = '';
  DateTime captureTime = DateTime.now();

  List<String> imagePathCheckIn = [];
  List<String> imagePathCheckOut = [];

  String posmId = '-1';

  TextEditingController controller = TextEditingController();

  bool _isCheckIn = false;
  bool _isCheckOut = false;

  bool _hotzone = false;
  bool _posm = false;
  bool _fee = false;
  bool _confirmation = false;

  //List<Store> stores = [];

  Future<void> loadLocalFilePathsImageCheckIn() async {
    List<String> paths =
        await UserData.getImageCheckIn(widget.store.id.toString());
    setState(() {
      imagePathCheckIn = paths;
      if (imagePathCheckIn.length > 0) {
        _isCheckIn = true;
      } else {
        _isCheckIn = false;
      }
    });
  }

  Future<void> loadLocalFilePathsImageCheckOut() async {
    List<String> paths =
        await UserData.getImageCheckOut(widget.store.id.toString());
    setState(() {
      imagePathCheckOut = paths;
      _isCheckOut = true;
    });
  }

  Future<bool> checkLocalFilePathsImageCheckOut() async {
    List<String> paths = await UserData.getImageCheckOut(widget.store.id.toString());
    imagePathCheckOut = paths;
    return imagePathCheckOut.isNotEmpty;
  }

  // Future<void> loadLocalFilePathsImageHotZone() async {
  //   List<String> paths =
  //       await UserData.getImageHotZone(widget.store.id.toString());
  //   setState(() {
  //     _hotzone = true;
  //   });
  // }

  // Future<void> loadLocalFilePathsImageBill() async {
  //   List<String> paths =
  //       await UserData.getImageBill(widget.store.id.toString());
  //   setState(() {
  //     _confirmation = true;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    fetchDropdownItems();
    loadLocalFilePathsImageCheckIn();
    loadLocalFilePathsImageCheckOut();
    //loadLocalFilePathsImageHotZone();
    //loadLocalFilePathsImageBill();
    //getStoreLocal();
  }

  Future<void> fetchDropdownItems() async {
    try {
      List<StoreStatus> items = await apiProvider.fetchDropdownItems();
      var selectedItem = dropdownValue;
      if (items.isNotEmpty) {
        selectedItem = items[0];
      }
      setState(() {
        dropdownItems = items;
        dropdownValue = selectedItem;
      });
    } catch (e) {
      print('Error: $e');
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Stack(
      children: [
        Scaffold(
            backgroundColor: Constants.backgroundColor,
            appBar: AppBar(
              title: const Text('Overview'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (imagePathCheckIn.isEmpty)
                        SizedBox(
                          width: 150,
                          height: 200,
                          child: InkWell(
                              child: Image.asset('assets/btn_checkin.png'),
                              onTap: () async {
                                handleCaptureImageCheckIn();
                              }),
                        )
                      else
                        buildImageCard(imagePathCheckIn[0]),
                      if (imagePathCheckOut.isEmpty)
                        SizedBox(
                          width: 150,
                          height: 200,
                          child: InkWell(
                              child: Image.asset('assets/btn_checkout.png'),
                              onTap: () async {
                                if (_isCheckIn == false) {
                                  _showMyDialog("Bạn chưa chụp ảnh check in");
                                } else if (selectedOption == 'Thành công') {
                                  if (_hotzone == false) {
                                    _showMyDialog('Bạn chưa chụp ảnh Hot Zone');
                                  } else if (_posm == false) {
                                    _showMyDialog('Bạn chưa chụp ảnh POSM');
                                  } else if (_fee == false) {
                                    _showMyDialog(
                                        'Bạn chưa xác nhận tài khoản');
                                  } else if (_confirmation == false) {
                                    _showMyDialog(
                                        'Bạn chưa chụp ảnh Phiếu xác nhận');
                                  } else {
                                    handleCaptureImageCheckOut();
                                    _isCheckOut = true;
                                  }
                                } else {
                                  handleCaptureImageCheckOut();
                                  _isCheckOut = true;
                                }
                              }),
                        )
                      else
                        buildImageCard(imagePathCheckOut[0]),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Check in",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text("Check out",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/label_store_name.png'),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                          value: selectedOption,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          underline: Container(),
                          onChanged: (String? newValue) {
                            // This is called when the user selects an item.
                            setState(() {
                              if (newValue != null) {
                                dropdownValue = dropdownItems.firstWhere(
                                  (element) => element.name == newValue,
                                );
                                selectedOption = newValue;
                              }
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text('Chọn trạng thái cửa hàng'),
                            ),
                            ...dropdownItems.map<DropdownMenuItem<String>>(
                                (StoreStatus value) {
                              return DropdownMenuItem<String>(
                                value: value.name,
                                child: Text(value.name),
                              );
                            }).toList(),
                          ]),
                    ],
                  ),

                  if (selectedOption == 'KTC - Đóng cửa tạm thời' ||
                      selectedOption == 'KTC - Đóng cửa vĩnh viễn' ||
                      selectedOption == 'KTC - Từ chối tiếp xúc' ||
                      selectedOption == 'KTC - Không tìm thấy cửa hàng' ||
                      selectedOption == 'KTC - Khác')
                    Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              controller: controller,
                              maxLines:
                                  10, // Đây là số dòng hiển thị trong text area
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                hintText:
                                    'Nhập ghi chú ở đây (nếu có)', // Gợi ý nội dung
                              ),
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                                child: Image.asset('assets/btn_done.png'),
                                onTap: () async {
                                  // Check if a store status is selected
                                  if (selectedOption == null) {
                                    // Show a dialog or perform some action to notify the user
                                    _showMyDialog(
                                        "Bạn chưa chọn trạng thái cửa hàng");
                                    return; // Don't proceed further if the condition is not met
                                  }
                                  // Print the values of _isCheckOut and _isCheckIn
                                  print(_isCheckOut.toString());
                                  print(_isCheckIn.toString());
                                  bool hasImageCheckOut = await checkLocalFilePathsImageCheckOut();
                                  // Check conditions and show dialog accordingly
                                  if (_isCheckIn == false) {
                                    _showMyDialog("Bạn chưa chụp ảnh Check in");
                                  } else if (hasImageCheckOut == false) {
                                    _showMyDialog(
                                        "Bạn chưa chụp ảnh Check out");
                                  } else {
                                    // If both conditions are true, call the notSuccess() function
                                    await notSuccess();
                                  }
                                })
                          ],
                        )),

                  if (selectedOption == 'Thành công')
                    Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            InkWell(
                                child: Image.asset('assets/btn_hot_zone.png'),
                                onTap: () {
                                  _hotzone = true;
                                  if (_isCheckIn != true) {
                                    _showMyDialog("Bạn chưa chụp ảnh check in");
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HotZoneScreen(
                                            store: widget.store,
                                          ),
                                        ));
                                  }
                                }),
                            const SizedBox(height: 16),
                            InkWell(
                                child: Image.asset('assets/btn_posm.png'),
                                onTap: () {
                                  _posm = true;
                                  if (_isCheckIn != true) {
                                    // Fluttertoast.showToast(
                                    //   msg: 'Bạn chưa chụp ảnh check in',
                                    //   backgroundColor: Colors.green,
                                    //   textColor: Colors.white,
                                    //   toastLength: Toast.LENGTH_SHORT,
                                    // );
                                    _showMyDialog("Bạn chưa chụp ảnh check in");
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => POSMScreen(
                                                store: widget.store)));
                                  }
                                }),
                            const SizedBox(height: 16),
                            InkWell(
                                child: Image.asset('assets/btn_fee.png'),
                                onTap: () {
                                  _fee = true;
                                  if (_isCheckIn != true) {
                                    // Fluttertoast.showToast(
                                    //   msg: 'Bạn chưa chụp ảnh check in',
                                    //   backgroundColor: Colors.green,
                                    //   textColor: Colors.white,
                                    //   toastLength: Toast.LENGTH_SHORT,
                                    // );
                                    _showMyDialog("Bạn chưa chụp ảnh check in");
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FeeInforScreen(
                                              store: widget.store),
                                        ));
                                  }
                                }),
                            const SizedBox(height: 16),
                            InkWell(
                              child: Image.asset(
                                  'assets/btn_phieu_nghiem_thu.png'),
                              onTap: () {
                                _confirmation = true;
                                if (_isCheckIn != true) {
                                  // Fluttertoast.showToast(
                                  //   msg: 'Bạn chưa chụp ảnh check in',
                                  //   backgroundColor: Colors.green,
                                  //   textColor: Colors.white,
                                  //   toastLength: Toast.LENGTH_SHORT,
                                  // );
                                  _showMyDialog("Bạn chưa chụp ảnh check in");
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PhieuXacNhanScreen(
                                                store: widget.store),
                                      ));
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            InkWell(
                                child: Image.asset('assets/btn_done.png'),
                                onTap: () async {
                                  if (selectedOption == "Thành công" &&
                                      _isCheckOut == true) {
                                    if (_hotzone != true) {
                                      _showMyDialog(
                                          "Bạn chưa chụp ảnh Hotzone");
                                    } else if (_posm != true) {
                                      _showMyDialog("Bạn chưa chụp ảnh POSM");
                                    } else if (_fee != true) {
                                      _showMyDialog(
                                          "Bạn chưa chụp ảnh trả phí");
                                    } else if (_confirmation != true) {
                                      _showMyDialog(
                                          "Bạn chưa chụp ảnh Phiếu xác nhận");
                                    } else if (_isCheckOut == true &&
                                        _hotzone == true &&
                                        _isCheckIn == true &&
                                        _posm == true &&
                                        _fee == true &&
                                        _confirmation == true &&
                                        _isCheckOut == true) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      await done();
                                      setState(() {
                                        _isLoading = true;
                                      });
                                    }
                                  } else {
                                    _showMyDialog(
                                        "Bạn chưa chụp ảnh Check out");
                                  }
                                  // if (_isCheckOut == true &&
                                  //     _hotzone == true &&
                                  //     _isCheckIn == true &&
                                  //     _posm == true &&
                                  //     _fee == true &&
                                  //     _confirmation == true) {

                                  // }
                                })
                          ],
                        )),
                  // Thêm các điều kiện khác tùy theo lựa chọn
                ],
              ),
            )),
        Visibility(
          visible: _isLoading,
          child: Container(
            color: const Color.fromRGBO(0, 0, 0, 0.3),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> done() async {
    String dropdownStatus = 'TC';

    Store storeUpdate = Store(
        id: widget.store.id,
        storeName: widget.store.storeName,
        provinceId: widget.store.provinceId,
        districtId: widget.store.districtId,
        address: widget.store.address,
        status: dropdownStatus,
        contactName: widget.store.contactName,
        userId: widget.store.userId,
        calendar: widget.store.calendar,
        reward: widget.store.reward,
        lat: widget.store.lat,
        long: widget.store.long,
        phoneNumber: widget.store.phoneNumber,
        provinceName: widget.store.provinceName,
        districName: widget.store.districName,
        statusName: selectedOption!,
        userFirstName: widget.store.userFirstName,
        userLastName: widget.store.userLastName,
        note: "",
        isDone: '1',
        winnerName: widget.store.winnerName,
        winnerBankName: widget.store.winnerBankName,
        winnerBankNumber: widget.store.winnerBankNumber,
        winnerRelationship: widget.store.winnerRelationship,
        storeCode: widget.store.storeCode);

    await updateStores(storeUpdate);
    List<Store> shopList = await UserData.getStoreList();
    await UserData.saveStoreList(shopList, widget.store);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));
  }

  // Future<void> done() async {
  //   String dropdownStatus = 'TC';

  //   Map<String, dynamic> storeUpdate = {
  //     "id": widget.store.id,
  //     "storeName": widget.store.storeName,
  //     "provinceId": widget.store.provinceId,
  //     "districtId": widget.store.districtId,
  //     "address": widget.store.address,
  //     "status": dropdownStatus,
  //     "contactName": widget.store.contactName,
  //     "userId": widget.store.userId,
  //     "calendar": widget.store.calendar,
  //     "reward": widget.store.reward,
  //     "lat": widget.store.lat,
  //     "long": widget.store.long,
  //     "phoneNumber": widget.store.phoneNumber,
  //     "provinceName": widget.store.provinceName,
  //     "districName": widget.store.districName,
  //     "statusName": selectedOption!,
  //     "userFirstName": widget.store.userFirstName,
  //     "userLastName": widget.store.userLastName,
  //     "note": "",
  //     "isDone": '1',
  //     "winnerName": widget.store.winnerName,
  //     "winnerBankName": widget.store.winnerBankName,
  //     "winnerBankNumber": widget.store.winnerBankNumber,
  //     "winnerRelationship": widget.store.winnerRelationship,
  //     "storeCode": widget.store.storeCode,
  //   };

  //   await UserData.saveStoreInfo(widget.store.id, storeUpdate);
  // }

  Future<void> notSuccess() async {
    String dropdownStatus;

    switch (selectedOption) {
      case "Thành công":
        dropdownStatus = "TC";
        break;
      case "KTC - Đóng cửa tạm thời":
        dropdownStatus = "DONG_TAM_THOI";
        break;
      case "KTC - Đóng cửa vĩnh viễn":
        dropdownStatus = "DONG_VINH_VIEN";
        break;
      case "KTC - Khác":
        dropdownStatus = "KHAC";
        break;
      case "KTC - Không tìm thấy cửa hàng":
        dropdownStatus = "KHONG_TIM_THAY";
        break;
      case "KTC - Từ chối tiếp xúc":
        dropdownStatus = "TU_CHOI_TX";
        break;
      default:
        dropdownStatus = "DONG_TAM_THOI";
    }
    bool hasImageCheckOut = await checkLocalFilePathsImageCheckOut();
    if (selectedOption == "KTC - Khác" ||
        selectedOption == "KTC - Từ chối tiếp xúc") {
      if (controller.text.isNotEmpty) {

        if (hasImageCheckOut == false) {
          _showMyDialog("Bạn chưa chụp ảnh Check out");

        } else {
          Store storeUpdate = Store(
              id: widget.store.id,
              storeName: widget.store.storeName,
              provinceId: widget.store.provinceId,
              districtId: widget.store.districtId,
              address: widget.store.address,
              status: dropdownStatus,
              contactName: widget.store.contactName,
              userId: widget.store.userId,
              calendar: widget.store.calendar,
              reward: widget.store.reward,
              lat: widget.store.lat,
              long: widget.store.long,
              phoneNumber: widget.store.phoneNumber,
              provinceName: widget.store.provinceName,
              districName: widget.store.districName,
              statusName: selectedOption!,
              userFirstName: widget.store.userFirstName,
              userLastName: widget.store.userLastName,
              note: controller.text,
              isDone: '1',
              winnerName: widget.store.winnerName,
              winnerBankName: widget.store.winnerBankName,
              winnerBankNumber: widget.store.winnerBankNumber,
              winnerRelationship: widget.store.winnerRelationship,
              storeCode: widget.store.storeCode);

          await updateStores(storeUpdate);
          List<Store> shopList = await UserData.getStoreList();
          await UserData.saveStoreList(shopList, widget.store);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(),
              ));
        }
      } else {
        //_showMyDialog(hasImageCheckOut.toString());
        _showMyDialog("Bạn chưa nhập lý do");
      }
    } else if (hasImageCheckOut == false) {
            _showMyDialog("Bạn chưa chụp ảnh Check out");

        } else {
        Store storeUpdate = Store(
            id: widget.store.id,
            storeName: widget.store.storeName,
            provinceId: widget.store.provinceId,
            districtId: widget.store.districtId,
            address: widget.store.address,
            status: dropdownStatus,
            contactName: widget.store.contactName,
            userId: widget.store.userId,
            calendar: widget.store.calendar,
            reward: widget.store.reward,
            lat: widget.store.lat,
            long: widget.store.long,
            phoneNumber: widget.store.phoneNumber,
            provinceName: widget.store.provinceName,
            districName: widget.store.districName,
            statusName: selectedOption!,
            userFirstName: widget.store.userFirstName,
            userLastName: widget.store.userLastName,
            note: controller.text,
            isDone: '1',
            winnerName: widget.store.winnerName,
            winnerBankName: widget.store.winnerBankName,
            winnerBankNumber: widget.store.winnerBankNumber,
            winnerRelationship: widget.store.winnerRelationship,
            storeCode: widget.store.storeCode);

        await updateStores(storeUpdate);
        List<Store> shopList = await UserData.getStoreList();
        await UserData.saveStoreList(shopList, widget.store);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(),
            ));
    }
  }

  // Future<void> notSuccess() async {
  //   String dropdownStatus;

  //   switch (selectedOption) {
  //     case "KTC - Đóng cửa tạm thời":
  //       dropdownStatus = "DONG_TAM_THOI";
  //       break;
  //     case "KTC - Đóng cửa vĩnh viễn":
  //       dropdownStatus = "DONG_VINH_VIEN";
  //       break;
  //     case "KTC - Khác":
  //       dropdownStatus = "KHAC";
  //       break;
  //     case "KTC - Không tìm thấy cửa hàng":
  //       dropdownStatus = "KHONG_TIM_THAY";
  //       break;
  //     case "Thành công":
  //       dropdownStatus = "TC";
  //       break;
  //     case "KTC - Từ chối tiếp xúc":
  //       dropdownStatus = "TU_CHOI_TX";
  //       break;
  //     default:
  //       dropdownStatus = "DONG_TAM_THOI";
  //   }

  //   if (controller.text.isNotEmpty) {
  //     Map<String, dynamic> storeUpdate = {
  //       'id': widget.store.id,
  //       'storeName': widget.store.storeName,
  //       'provinceId': widget.store.provinceId,
  //       'districtId': widget.store.districtId,
  //       'address': widget.store.address,
  //       'status': dropdownStatus,
  //       'contactName': widget.store.contactName,
  //       'userId': widget.store.userId,
  //       'calendar': widget.store.calendar,
  //       'reward': widget.store.reward,
  //       'lat': widget.store.lat,
  //       'long': widget.store.long,
  //       'phoneNumber': widget.store.phoneNumber,
  //       'provinceName': widget.store.provinceName,
  //       'districName': widget.store.districName,
  //       'statusName': selectedOption,
  //       'userFirstName': widget.store.userFirstName,
  //       'userLastName': widget.store.userLastName,
  //       'note': controller.text,
  //       'isDone': '1',
  //       'winnerName': widget.store.winnerName,
  //       'winnerBankName': widget.store.winnerBankName,
  //       'winnerBankNumber': widget.store.winnerBankNumber,
  //       'winnerRelationship': widget.store.winnerRelationship,
  //       'storeCode': widget.store.storeCode
  //     };

  //     await UserData.saveStoreInfo(widget.store.id, storeUpdate);
  //   } else {
  //     _showMyDialog("Bạn chưa nhập lý do");
  //   }
  // }

  Future<void> updateStores(Store entries) async {
    setState(() {
      _isLoading = true;
    });

    var storeResponse = await apiProvider.updateStore(entries);

    if (storeResponse['isSuccess']) {
      // Fluttertoast.showToast(
      //   msg: 'Upload thông tin cửa hàng "${entries.storeName}" thành công',
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   toastLength: Toast.LENGTH_SHORT,
      // );

      // Sau khi xử lý xong một cửa hàng, bạn có thể thực hiện các tác vụ khác ở đây nếu cần.
    } else {
      // Fluttertoast.showToast(
      //   msg:
      //       'Lỗi khi cập nhật thông tin cửa hàng "${entries.storeName}": ${storeResponse['message']}',
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   toastLength: Toast.LENGTH_SHORT,
      // );

      // Xử lý lỗi hoặc thực hiện các tác vụ khác ở đây nếu cần.
    }
  }

  Future<List<String>> captureImageCheckIn() async {
    setState(() {
      _isLoading = true;
    });

    // _isCheckIn = true;

    PickedFile? pickedFile;

    pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Lấy thông tin vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return [];
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });

      // Nén ảnh
      File? compressedImageFile =
          await compressFile(File(pickedFile.path), quality: 20);

      // Kiểm tra xem việc nén ảnh thành công
      if (compressedImageFile != null && compressedImageFile.existsSync()) {
        // Tiến hành lưu ảnh đã nén vào máy
        final result =
            await ImageGallerySaver.saveFile(compressedImageFile.path);

        if (result['isSuccess']) {
          Fluttertoast.showToast(
            msg: 'Đã lưu ảnh về máy',
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );

          setState(() {
            //imagePathCheckIn.add(pickedFile!.path);
            _isLoading = false;
            //widget.localFilePaths.add(compressedImageFile.path); // Thêm đường dẫn ảnh vào mảng
            imagePathCheckIn.add(compressedImageFile.path);
            _isCheckIn = true;
          });

          await UserData.saveImageCheckIn(
              widget.store.id.toString(), imagePathCheckIn);

          return imagePathCheckIn;
        }
      }

      Fluttertoast.showToast(
        msg: 'Ảnh chưa được nén hoặc lưu về máy',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    }

    setState(() {
      _isLoading = false;
    });
    return [];
  }

  // Future<List<String>> captureImageCheckIn() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   PickedFile? pickedFile;

  //   pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

  //   if (pickedFile != null) {
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied ||
  //           permission == LocationPermission.deniedForever) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //         return [];
  //       }
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     setState(() {
  //       latitude = position.latitude.toString();
  //       longitude = position.longitude.toString();
  //     });

  //     Directory appDir = await getApplicationDocumentsDirectory();
  //     String appDirPath = appDir.path;

  //     File? compressedImageFile =
  //         await compressFile(File(pickedFile.path), quality: 20);

  //     if (compressedImageFile != null && compressedImageFile.existsSync()) {
  //       final result =
  //           await ImageGallerySaver.saveFile(compressedImageFile.path);

  //       if (result['isSuccess']) {
  //         Fluttertoast.showToast(
  //           msg: 'Đã lưu ảnh về máy',
  //           backgroundColor: Colors.green,
  //           textColor: Colors.white,
  //           toastLength: Toast.LENGTH_SHORT,
  //         );

  //         setState(() {
  //           _isLoading = false;
  //           imagePathCheckIn.add(
  //               appDirPath); // Sử dụng appDirPath thay cho compressedImageFile.path
  //           _isCheckIn = true;
  //         });

  //         await UserData.saveImageCheckIn(
  //             widget.store.id.toString(), imagePathCheckIn);

  //         return imagePathCheckIn;
  //       }
  //     }

  //     Fluttertoast.showToast(
  //       msg: 'Ảnh chưa được nén hoặc lưu về máy',
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       toastLength: Toast.LENGTH_SHORT,
  //     );
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   return [];
  // }

  Future<void> handleCaptureImageCheckIn() async {
    setState(() {
      _isLoading = true;
    });
    List<String> imagePath = await captureImageCheckIn();
    if (imagePath != null) {
      await uploadImage(
          widget.store.id, imagePath, "check_in", latitude, longitude);

      // Fluttertoast.showToast(
      //   msg: 'Check in',
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   toastLength: Toast.LENGTH_SHORT,
      // );
    } else {
      _showMyDialog("Bạn cần chụp ảnh trước khi tiếp tục.");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<List<String>> captureImageCheckOut() async {
    setState(() {
      _isLoading = true;
    });

    //_isCheckOut = true;

    PickedFile? pickedFile;

    pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      // Lấy thông tin vị trí
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return [];
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });

      // Nén ảnh
      File? compressedImageFile =
          await compressFile(File(pickedFile.path), quality: 20);

      // Kiểm tra xem việc nén ảnh thành công
      if (compressedImageFile != null && compressedImageFile.existsSync()) {
        // Tiến hành lưu ảnh đã nén vào máy
        final result =
            await ImageGallerySaver.saveFile(compressedImageFile.path);

        if (result['isSuccess']) {
          Fluttertoast.showToast(
            msg: 'Đã lưu ảnh về máy',
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
          );

          setState(() {
            //imagePathCheckOut.add(pickedFile!.path);
            _isLoading = false;
            //widget.localFilePaths.add(compressedImageFile.path); // Thêm đường dẫn ảnh vào mảng
            imagePathCheckOut.add(compressedImageFile.path);
            _isCheckOut = true;
          });

          // Lưu danh sách đường dẫn hình ảnh vào UserData
          await UserData.saveImageCheckOut(
              widget.store.id.toString(), imagePathCheckOut);

          return imagePathCheckOut;
        }
      }

      Fluttertoast.showToast(
        msg: 'Ảnh chưa được nén hoặc lưu về máy',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    }

    setState(() {
      _isLoading = false;
    });
    return [];
  }

  // Future<List<String>> captureImageCheckOut() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   PickedFile? pickedFile;

  //   pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

  //   if (pickedFile != null) {
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied ||
  //           permission == LocationPermission.deniedForever) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //         return [];
  //       }
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );

  //     setState(() {
  //       latitude = position.latitude.toString();
  //       longitude = position.longitude.toString();
  //     });

  //     Directory appDir = await getApplicationDocumentsDirectory();
  //     String appDirPath = appDir.path;

  //     File? compressedImageFile =
  //         await compressFile(File(pickedFile.path), quality: 20);

  //     if (compressedImageFile != null && compressedImageFile.existsSync()) {
  //       final result =
  //           await ImageGallerySaver.saveFile(compressedImageFile.path);

  //       if (result['isSuccess']) {
  //         Fluttertoast.showToast(
  //           msg: 'Đã lưu ảnh về máy',
  //           backgroundColor: Colors.green,
  //           textColor: Colors.white,
  //           toastLength: Toast.LENGTH_SHORT,
  //         );

  //         setState(() {
  //           _isLoading = false;
  //           imagePathCheckOut.add(
  //               appDirPath); // Sử dụng appDirPath thay cho compressedImageFile.path
  //           _isCheckOut = true;
  //         });

  //         await UserData.saveImageCheckOut(
  //             widget.store.id.toString(), imagePathCheckOut);

  //         return imagePathCheckOut;
  //       }
  //     }

  //     Fluttertoast.showToast(
  //       msg: 'Ảnh chưa được nén hoặc lưu về máy',
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       toastLength: Toast.LENGTH_SHORT,
  //     );
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   return [];
  // }

  Future<void> handleCaptureImageCheckOut() async {
    setState(() {
      _isLoading = true;
    });
    List<String> imagePath = await captureImageCheckOut();
    if (imagePath != null) {
      await uploadImage(
          widget.store.id, imagePath, "check_out", latitude, longitude);

      Fluttertoast.showToast(
        msg: 'Check out',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      _showMyDialog("Bạn cần chụp ảnh trước khi tiếp tục.");
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> uploadImage(String storeId, List<String> imagePath,
      String typeCode, String lat, String long) async {
    APIProvider provider = APIProvider();

    bool uploadedSuccessfully = false;

    while (!uploadedSuccessfully) {
      var storeResponse = await provider.uploadImage(
          storeId, imagePath, typeCode, lat, long, posmId);

      if (storeResponse == true) {
        uploadedSuccessfully = true;
        // Fluttertoast.showToast(
        //   msg: 'Upload ảnh thành công',
        //   backgroundColor: Colors.green,
        //   textColor: Colors.white,
        //   toastLength: Toast.LENGTH_SHORT,
        // );
        print("Up load thành công");
      }
      // else {
      //   Fluttertoast.showToast(
      //     msg: 'Upload ảnh thất bại. Đang thử lại...',
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     toastLength: Toast.LENGTH_SHORT,
      //   );
      // }
    }
  }

  Future<void> _showMyDialog(String? content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content!),
                //Text('Vui lòng quay lại và chụp checkin lại')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<File?> compressFile(File file, {int quality = 20}) async {
    if (file == null || !file.existsSync()) {
      return null; // Xử lý trường hợp tệp gốc không tồn tại
    }

    try {
      File compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        quality: quality,
      );
      return compressedFile;
    } catch (e) {
      print('Lỗi khi nén ảnh: $e');
      return null; // Xử lý lỗi khi nén ảnh
    }
  }
}

Widget buildImageCard(String imagePath) {
  return Card(
    child: Image(
      image: FileImage(File(imagePath)),
      width: 150,
      height: 200,
      fit: BoxFit.cover,
    ),
  );
}
