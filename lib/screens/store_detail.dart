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
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class StoreDetailScreen extends StatefulWidget {
  final Store store;

  StoreDetailScreen({required this.store});

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  bool _isLoading = false;
  String latitude = '';
  String longitude = '';
  DateTime captureTime = DateTime.now();
  int? userId = UserData.getUserId();

  bool _isTakePhoto = false;
  List<String> localFilePaths = [];

  @override
  void initState() {
    super.initState();
    loadLocalFilePaths();
  }

  Future<void> loadLocalFilePaths() async {
    List<String> paths =
        await UserData.getImageOverview(widget.store.id.toString());
    setState(() {
      localFilePaths = paths;
    });
    if (localFilePaths.length > 0) {
      _isTakePhoto = true;
    }
  }

  String posmId = '-1';

  String imagePathOverview = '';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () async {
                          await handleCaptureImageOverview();
                        },
                        child: Image.asset('assets/btn_overview.png'),
                      ),
                      const SizedBox(height: 16),
                      localFilePaths.isNotEmpty
                          ? buildImageCard(
                              localFilePaths[0]) // Nếu imagePath không null
                          : const Text('Chưa chụp hình Overview')
                    ],
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                      child: Image.asset('assets/btn_make_report.png'),
                      onTap: () {
                        if (_isTakePhoto == false) {
                          _showMyDialog("Bạn chưa chụp ảnh Overview");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OverviewScreen(
                                  store: widget.store,
                                ),
                              ));
                        }
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
        ));
  }

  Future<List<String>> captureImageOverview() async {
    setState(() {
      _isLoading = true;
    });

    _isTakePhoto = true;

    PickedFile? pickedFile;

    pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _isLoading = false;
          });
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

      File? compressedImageFile =
          await compressFile(File(pickedFile.path), quality: 20);

      if (compressedImageFile != null && compressedImageFile.existsSync()) {
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
            //imagePathOverview = pickedFile!.path;
            localFilePaths.add(compressedImageFile.path);
          });

          // Lưu danh sách đường dẫn hình ảnh vào UserData
          await UserData.saveImageOverview(
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

  Future<void> handleCaptureImageOverview() async {
    setState(() {
      _isLoading = true;
    });
    List<String> imagePath = await captureImageOverview();
    if (imagePath != null) {
      await uploadImage(
          widget.store.id, imagePath, "overview", latitude, longitude);

      // Fluttertoast.showToast(
      //   msg: 'Overview',
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

  Future<void> uploadImage(String storeId, List<String> imagePath,
      String typeCode, String lat, String long) async {
    APIProvider provider = APIProvider();

    bool uploadedSuccessfully = false;

    while (!uploadedSuccessfully) {
      var storeResponse = await provider.uploadImage(
          storeId, imagePath, typeCode, lat, long, posmId);

      if (storeResponse == true) {
        uploadedSuccessfully = true;
        //print("Uploaded Successfully");
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
      return null;
    }

    try {
      Uint8List? compressedData = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: quality,
      );

      List<int> compressedList = compressedData ?? [];

      File compressedFile = File('${file.path}_compressed.jpg');
      await compressedFile.writeAsBytes(compressedList);

      return compressedFile;
    } catch (e) {
      print('Lỗi khi nén ảnh: $e');
      return null;
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
