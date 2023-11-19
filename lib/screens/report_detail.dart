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

class ReportDetail extends StatefulWidget {
  final Store store;

  ReportDetail({required this.store});

  @override
  _ReportDetailState createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  bool _isLoading = false;
  int? userId = UserData.getUserId();
  List<String> imagePath = [];
  APIProvider provider = APIProvider();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      List<String> fetchedImagePaths = await provider.fetchImages(widget.store.id);
      setState(() {
        imagePath = fetchedImagePaths;
      });
    } catch (e) {
      print('Error: $e');
      // Xử lý lỗi (hiển thị thông báo lỗi, v.v.)
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          title: const Text('Thông tin cửa hàng'),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    color: Colors.white,
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset('assets/label_store_name.png'),
                                const Text(
                                  "Tên cửa hàng",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.right,
                                )
                              ],
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.store.storeName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    color: Colors.white,
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset('assets/label_address.png'),
                                const Text(
                                  "Địa chỉ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.right,
                                )
                              ],
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${widget.store.address} ${widget.store.districName} ${widget.store.provinceName}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    color: Colors.white,
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset('assets/label_user.png'),
                                const Text(
                                  "Chủ cửa hàng",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.right,
                                )
                              ],
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.store.contactName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    color: Colors.white,
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset('assets/label_phone_number.png'),
                                const Text(
                                  "Số điện thoại",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.right,
                                )
                              ],
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 200,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.store.phoneNumber,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    color: Colors.white,
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset('assets/label_gift.png'),
                                const Text(
                                  "Trả thưởng",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textAlign: TextAlign.right,
                                )
                              ],
                            )),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: 200,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  widget.store.reward == '1' ? 'Có' : 'Không',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0, // Khoảng cách giữa các phần tử
                    runSpacing: 8.0, // Khoảng cách giữa các dòng
                    children:
                        buildImageWidgets(), // Danh sách các widget hình ảnh
                  ),
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

  List<Widget> buildImageWidgets() {
    List<Widget> imageWidgets = [];

    if (imagePath != null) {
      for (String imagePath in imagePath) {
        imageWidgets.add(buildImageCard(imagePath));
      }
    }

    return imageWidgets;
  }
}

Widget buildImageCard(String imageUrl) {
  return Card(
    child: Image.network(
      Constants.API_IMAGE+imageUrl,
      width: 150,
      height: 150,
      fit: BoxFit.cover,
    ),
  );
}
