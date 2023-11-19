import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jti_app/models/store.dart';
import 'package:jti_app/providers/api_provider.dart';
import 'package:jti_app/providers/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jti_app/providers/shared.dart';

class HotZoneScreen extends StatefulWidget {
  final Store store;

  HotZoneScreen({required this.store});

  @override
  _HotZoneScreenState createState() => _HotZoneScreenState();
}

class _HotZoneScreenState extends State<HotZoneScreen> {
  bool _isLoading = false;
  bool _isTakePhoto = false;
  String latitude = '';
  String longitude = '';
  DateTime captureTime = DateTime.now();
  int? userId = UserData.getUserId();
  List<String> localFilePaths = [];
  late int _countPhoto;
  String posmId = '-1';

  @override
  void initState() {
    super.initState();
    loadLocalFilePaths();
    if (localFilePaths != null) {
      _isTakePhoto = true;
      _countPhoto = localFilePaths.length;
    }
  }

  Future<void> loadLocalFilePaths() async {
    List<String> paths =
        await UserData.getImageHotZone(widget.store.id.toString());
    setState(() {
      localFilePaths = paths;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Constants.backgroundColor,
          appBar: AppBar(
            title: const Text('Hot Zone'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 150,
                          height: 135,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black, // Màu viền
                              width: 1.0, // Độ dày của viền
                            ),
                            borderRadius: BorderRadius.circular(
                                8.0), // Góc bo tròn (tuỳ chọn)
                          ),
                          child: const SizedBox(
                            width: double
                                .infinity, // Để SizedBox sử dụng toàn bộ chiều rộng của Container
                            height: double
                                .infinity, // Để SizedBox sử dụng toàn bộ chiều cao của Container
                            child: Center(
                              child: Text(
                                'Lưu ý: Chụp hình ảnh khu vực bán hàng, tối thiểu 1 tấm',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 150,
                            height: 200,
                            child: InkWell(
                                child:
                                    Image.asset('assets/btn_photo_hotzone.png'),
                                onTap: () {
                                  captureImageHotZone();
                                })),
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
                        onTap: () {
                          handleCaptureImageHotZone();
                        })
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
          )),
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

  Future<List<String>> captureImageHotZone() async {
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

          await UserData.saveImageHotZone(
              widget.store.id.toString(), localFilePaths);

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

 

  Future<void> handleCaptureImageHotZone() async {
    setState(() {
      _isLoading = true;
    });

    List<String> imagePath = localFilePaths;

    if (imagePath != null && imagePath.length > 0) {
      await uploadImage(widget.store.id, imagePath, 'hot_zone', latitude,
          longitude); // Lưu danh sách hình ảnh hot zone

      Fluttertoast.showToast(
        msg: 'Hot zone',
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
