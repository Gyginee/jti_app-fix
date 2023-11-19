import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jti_app/models/store.dart';
import 'package:jti_app/providers/api_provider.dart';
import 'package:jti_app/providers/constants.dart';
import 'package:jti_app/providers/shared.dart';
import 'package:jti_app/screens/overview.dart';

class FeeInforScreen extends StatefulWidget {
  final Store store;

  FeeInforScreen({required this.store});

  @override
  _FeeInforScreenState createState() => _FeeInforScreenState();
}

class _FeeInforScreenState extends State<FeeInforScreen> {
  bool _isLoading = false;
  //TextEditingController controllerRelationship = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController bankNumberController = TextEditingController();
  APIProvider provider = APIProvider();
  String? selectedOption5; // Đây là giá trị được chọn từ Dropdown

  String selectedBank = '';
  List<DropdownMenuItem<String>> menuItems = [];

  @override
  void initState() {
    super.initState();
    provider.fetchBankData().then((value) {
      var menus = value.map((bank) {
        return DropdownMenuItem<String>(
          value: bank,
          child: Text(bank),
        );
      }).toList();

      // Thêm DropdownMenuItem mặc định vào đầu danh sách
      menus.insert(
        0,
        DropdownMenuItem<String>(
          value: '',
          child: Text("Không có thông tin"),
        ),
      );

      setState(() {
        nameController.text = widget.store.winnerName ?? "Không có thông tin";
        bankNumberController.text =
            widget.store.winnerBankNumber ?? "Không có thông tin";
        menuItems = menus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          title: const Text('Thông tin trả phí'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/label_user.png'),
                            const SizedBox(
                                width: 8), // Khoảng cách giữa ảnh và Text
                            const Text("Tên người nhận",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ))
                          ],
                        ),
                        const SizedBox(
                            height:
                                8), // Khoảng cách giữa dòng đầu tiên và dòng thứ hai
                        Row(
                          children: [
                            // Text(
                            //   widget.store.winnerName,
                            //   style: const TextStyle(
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 16,
                            //   ),
                            // ),
                            Container(
                              margin: EdgeInsets.all(10.0), // Adding margin of 8 pixels on all sides
                              constraints: const BoxConstraints(
                                  maxWidth: 320), // Đặt độ rộng tối đa của Container
                              child: TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/label_cash.png'),
                            const SizedBox(
                                width: 8), // Khoảng cách giữa ảnh và Text
                            const Text("Ngân hàng",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ))
                          ],
                        ),

                        DropdownButton(
                          value: widget.store.winnerBankName.trim(),
                          items: menuItems,
                          hint: const Text('Select a bank'),
                          onChanged: (value) {
                            setState(() {
                              widget.store.winnerBankName = value!;
                            });
                          },
                          isExpanded: true,
                          itemHeight: 90,
                        ),
                        const SizedBox(height: 16),
                        // Text(
                        //   "STK: ${widget.store.winnerBankNumber}",
                        //   style: const TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 16,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset('assets/label_user.png'),
                      const SizedBox(width: 8), // Khoảng cách giữa ảnh và Text
                      const Text("Số tài khoản",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ))
                    ],
                  ),
                  const SizedBox(
                      height:
                          8), // Khoảng cách giữa dòng đầu tiên và dòng thứ hai
                  Row(
                    children: [
                      // Text(
                      //   widget.store.winnerName,
                      //   style: const TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 16,
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.all(10.0), // Adding margin of 8 pixels on all sides
                        constraints: const BoxConstraints(
                            maxWidth: 320), // Đặt độ rộng tối đa của Container
                        child: TextField(
                          controller: bankNumberController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/label_friends.png'),
                            const SizedBox(
                                width: 8), // Khoảng cách giữa ảnh và Text
                            const Text("Xác nhận số tài khoản",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                                DropdownButton<String>(
                              value: selectedOption5,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOption5 = newValue!;
                                });
                              },
                              items: <String>[
                                'Đúng',
                                'Sai',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(
                            height:
                                16), // Khoảng cách giữa dòng đầu tiên và dòng thứ hai
                        // Container(
                        //   constraints: const BoxConstraints(
                        //       maxWidth:
                        //           200), // Đặt độ rộng tối đa của Container
                        //   child: TextField(
                        //     controller: controllerRelationship,
                        //     decoration: InputDecoration(
                        //       border: OutlineInputBorder(
                        //         borderSide: const BorderSide(
                        //           color: Colors.blue,
                        //           width: 2.0,
                        //         ),
                        //         borderRadius: BorderRadius.circular(8.0),
                        //       ),
                        //       contentPadding: const EdgeInsets.symmetric(
                        //           vertical: 8.0, horizontal: 12.0),
                        //     ),
                        //   ),
                        // ),
                        
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                                child: Image.asset('assets/btn_confirm.png'),
                                onTap: () async {
                                  updateStores(
                                      widget.store.id,
                                      nameController.text,
                                      widget.store.winnerBankName,
                                      bankNumberController.text,
                                      selectedOption5!);
                                }),
                            // const SizedBox(width: 8),
                            // InkWell(
                            //   child: Image.asset('assets/btn_confirm.png'),
                            //   onTap: () {
                            //     Navigator.of(context).pop();
                            //   },
                            // )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
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

  Future<void> updateStores(
      String storeId,
      String winnerName,
      String winnerBankName,
      String winnerBankNumber,
      String winnerRelationship) async {
    setState(() {
      _isLoading = true;
    });

    var storeResponse = await provider.updateWinnerStore(storeId, winnerName,
        winnerBankName, winnerBankNumber, winnerRelationship);

    if (storeResponse['isSuccess']) {
      Fluttertoast.showToast(
        msg: 'Upload thông tin cửa hàng thành công',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );

      Navigator.of(context).pop();
      // Sau khi xử lý xong một cửa hàng, bạn có thể thực hiện các tác vụ khác ở đây nếu cần.
    } else {
      Fluttertoast.showToast(
        msg: 'Lỗi khi cập nhật thông tin cửa hàng: ${storeResponse['message']}',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );

      // Xử lý lỗi hoặc thực hiện các tác vụ khác ở đây nếu cần.
    }
  }
}
