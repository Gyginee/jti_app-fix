import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jti_app/models/posm.dart';
import 'package:jti_app/models/posm_store_mapping.dart';
import 'package:jti_app/models/store.dart';
import 'package:jti_app/providers/api_provider.dart';
import 'package:jti_app/providers/constants.dart';
import 'package:jti_app/providers/shared.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class POSMDetail extends StatefulWidget {
  final Store store;
  final POSM posm;

  POSMDetail({required this.store, required this.posm});

  @override
  _POSMDetailState createState() => _POSMDetailState();
}

class _POSMDetailState extends State<POSMDetail> {
  String? selectedOption1; // Đây là giá trị được chọn từ Dropdown
  String? selectedOption2; // Đây là giá trị được chọn từ Dropdown
  String? selectedOption3; // Đây là giá trị được chọn từ Dropdown
  String? selectedOption4; // Đây là giá trị được chọn từ Dropdown
  String? selectedOption5; // Đây là giá trị được chọn từ Dropdown

  TextEditingController controller = TextEditingController();

  bool _isLoading = false;

  int? userId = UserData.getUserId();
  List<String> localFilePaths = [];
  int _countPhoto = 0;
  bool _isTakePhoto = false;
  String latitude = '';
  String longitude = '';
  DateTime captureTime = DateTime.now();

  String posmId = '-1';

  @override
  void initState() {
    super.initState();
    loadLocalFilePaths();
    if (localFilePaths != null) {
      _isTakePhoto = true;
    }
  }

  Future<void> loadLocalFilePaths() async {
    List<String> paths =
        await UserData.getImagePosm(widget.posm.id.toString(), widget.store.id);
    setState(() {
      localFilePaths = paths;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Scaffold(
            backgroundColor: Constants.backgroundColor,
            appBar: AppBar(
              title: const Text('Chi tiết POSM'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Điều chỉnh các phần tử theo chiều ngang
                    children: [
                      Flexible(
                        child: Text(
                          "1. POSM có nằm trong tầm mắt không?",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                          width: 10), // Khoảng cách giữa Text và DropdownButton
                      DropdownButton<String>(
                        value: selectedOption1,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption1 = newValue!;
                          });
                        },
                        items: <String>['Có', 'Không']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Điều chỉnh các phần tử theo chiều ngang
                    children: [
                      Flexible(
                        child: Text(
                          "2. POSM có đối diện với người mua hàng không?",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                          width: 10), // Khoảng cách giữa Text và DropdownButton
                      DropdownButton<String>(
                        value: selectedOption2,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption2 = newValue!;
                          });
                        },
                        items: <String>['Có', 'Không']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Điều chỉnh các phần tử theo chiều ngang
                    children: [
                      Flexible(
                        child: Text(
                          "3. POSM có bị che chắn bởi các vật dụng khác không?",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                          width: 10), // Khoảng cách giữa Text và DropdownButton
                      DropdownButton<String>(
                        value: selectedOption3,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption3 = newValue!;
                          });
                        },
                        items: <String>['Có', 'Không']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Text("4. Tình trạng POSM",
                  //         style: TextStyle(fontSize: 16)),
                  //     TextField(
                  //       controller: controller,
                  //       maxLines: 3, // Đây là số dòng hiển thị trong text area
                  //       decoration: InputDecoration(
                  //         border: OutlineInputBorder(
                  //           borderSide: const BorderSide(
                  //               color: Colors.blue, width: 2.0),
                  //           borderRadius: BorderRadius.circular(8.0),
                  //         ),
                  //         hintText: 'Nhập tình trạng POSM', // Gợi ý nội dung
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Điều chỉnh các phần tử theo chiều ngang
                    children: [
                      const Flexible(
                        child: Text(
                          "4. Tình trạng POSM",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                          width: 10), // Khoảng cách giữa Text và DropdownButton
                      DropdownButton<String>(
                        value: selectedOption4,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption4 = newValue!;
                          });
                        },
                        items: <String>['Tốt', 'Hư hỏng', 'Bị che phủ']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Điều chỉnh các phần tử theo chiều ngang
                    children: [
                      Flexible(
                        child: Text(
                          "5. % che phủ",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                          width: 10), // Khoảng cách giữa Text và DropdownButton
                      DropdownButton<String>(
                        value: selectedOption5,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedOption5 = newValue!;
                          });
                        },
                        items: <String>['0%', '< 25%', '50%', '> 75%']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ghi chú", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 4), // Adding vertical margin of 8 pixels
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16), // Adding horizontal margin of 16 pixels
                        child: TextField(
                          controller: controller,
                          maxLines: 3,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            hintText: 'Nhập ghi chú',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 150,
                        height: 135,

                        // decoration: BoxDecoration(
                        //   border: Border.all(
                        //     color: Colors.black, // Màu viền
                        //     width: 1.0, // Độ dày của viền
                        //   ),
                        //   borderRadius: BorderRadius.circular(8.0), // Góc bo tròn (tuỳ chọn)
                        // ),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      75, // Set the desired width of the square
                                  height:
                                      75, // Set the desired height of the square
                                  decoration: BoxDecoration(
                                    shape: BoxShape
                                        .rectangle, // Set the shape to rectangle
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "https://jtiapi.hdcreative.vn/${widget.posm.imagePath}"),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  widget.posm.name!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 200,
                        child: InkWell(
                          child: Image.asset('assets/btn_photo_hotzone.png'),
                          onTap: () {
                            captureImagePOSM();
                          },
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8.0, // Khoảng cách giữa các phần tử
                    runSpacing: 8.0, // Khoảng cách giữa các dòng
                    children:
                        buildImageWidgets(), // Danh sách các widget hình ảnh
                  ),
                  InkWell(
                      child: Image.asset('assets/btn_done.png'),
                      onTap: () async {
                        await handleCaptureImagePOSM();
                        // await updateQuestion();
                        // Navigator.of(context).pop();
                      })
                ],
              ),
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
      ),
    );
  }

  List<Widget> buildImageWidgets() {
    List<Widget> imageWidgets = [];

    if (localFilePaths != null) {
      for (String imagePath in localFilePaths) {
        imageWidgets.add(buildImageCard(imagePath));
      }
    }

    return imageWidgets;
  }

  Future<List<String>> captureImagePOSM() async {
    setState(() {
      _isLoading = true;
    });

    _isTakePhoto = true;

    _countPhoto += 1;

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
            _isLoading = false;
            localFilePaths
                .add(compressedImageFile.path); // Thêm đường dẫn ảnh vào mảng
          });

          // Lưu danh sách đường dẫn hình ảnh vào UserData
          await UserData.saveImagePosm(
              widget.posm.id.toString(), localFilePaths, widget.store.id);

          return localFilePaths;
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

  Future<void> updateQuestion() async {
    setState(() {
      _isLoading = true;
    });
    if (selectedOption1 != null &&
        selectedOption2 != null &&
        selectedOption3 != null &&
        selectedOption4 != null &&
        selectedOption5 != null &&
        controller.text.isNotEmpty) {
      List<POSMStore> stores = [];
      POSMStore posmStore = POSMStore(
          storeId: widget.store.id,
          pposmId: widget.posm.id,
          question1: selectedOption1!,
          question2: selectedOption2!,
          question3: selectedOption3!,
          question4: selectedOption4!,
          question5: selectedOption5!,
          description: controller.text);
      stores.add(posmStore);
      APIProvider provider = APIProvider();
      provider.updateQuestionsList(stores);
    } else {
      _showMyDialog("Bạn chưa trả lời đủ các câu hỏi");
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Future<void> handleCaptureImagePOSM() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   List<String> imagePath = localFilePaths;
  //   if (imagePath != null && _countPhoto > 1) {
  //     await uploadImage(widget.store.id, imagePath, "posm", latitude, longitude,
  //         widget.posm.id!);

  //     Fluttertoast.showToast(
  //       msg: 'POSM',
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       toastLength: Toast.LENGTH_SHORT,
  //     );
  //     Navigator.of(context).pop();
  //   } else {
  //     _showMyDialog("Bạn chưa chụp đủ ảnh");
  //   }
  //   await updateQuestion();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  // Future<void> handleCaptureImagePOSM() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   List<String> imagePath = localFilePaths;

  //   if (imagePath != null && imagePath.isNotEmpty && _countPhoto > 1) {
  //     await uploadImage(widget.store.id, imagePath, "posm", latitude, longitude,
  //         widget.posm.id!);

  //     Fluttertoast.showToast(
  //       msg: 'POSM',
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       toastLength: Toast.LENGTH_SHORT,
  //     );
  //     //await updateQuestion(); // Gọi updateQuestion khi điều kiện đều thoả mãn
  //     // Navigator.of(context).pop();
  //   } else {
  //     _showMyDialog("Bạn chưa chụp đủ ảnh");
  //   }

  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  Future<void> handleCaptureImagePOSM() async {
    bool _isQuestion = false;
    setState(() {
      _isLoading = true;
    });

    List<String> imagePath = localFilePaths;

    if (imagePath != null && imagePath.isNotEmpty && _countPhoto > 1) {
      if (selectedOption1 != null &&
          selectedOption2 != null &&
          selectedOption3 != null &&
          selectedOption4 != null &&
          selectedOption5 != null &&
          controller.text.isNotEmpty) {
        List<POSMStore> stores = [];
        POSMStore posmStore = POSMStore(
            storeId: widget.store.id,
            pposmId: widget.posm.id,
            question1: selectedOption1!,
            question2: selectedOption2!,
            question3: selectedOption3!,
            question4: selectedOption4!,
            question5: selectedOption5!,
            description: controller.text);
        stores.add(posmStore);
        APIProvider provider = APIProvider();
        provider.updateQuestionsList(stores);
        _isQuestion = true;
      } else {
        _showMyDialog("Bạn chưa trả lời đủ các câu hỏi");
      }
      // Tải lên hình ảnh
      if (_isQuestion == true) {
        await uploadImage(widget.store.id, imagePath, "posm", latitude,
            longitude, widget.posm.id!);
      } else {
        _showMyDialog("Bạn chưa trả lời đủ các câu hỏi");
      }

      Fluttertoast.showToast(
        msg: 'POSM',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );

      Navigator.of(context).pop();
    } else {
      _showMyDialog("Bạn chưa chụp đủ ảnh");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> uploadImage(String storeId, List<String> imagePath,
      String typeCode, String lat, String long, String posmId) async {
    APIProvider provider = APIProvider();

    bool uploadedSuccessfully = false;

    while (!uploadedSuccessfully) {
      var storeResponse = await provider.uploadImage(
          storeId, imagePath, typeCode, lat, long, posmId);

      if (storeResponse == true) {
        uploadedSuccessfully = true;
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
      height: 150,
      fit: BoxFit.cover,
    ),
  );
}
