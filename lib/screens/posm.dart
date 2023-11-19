import 'package:flutter/material.dart';
import 'package:jti_app/models/posm.dart';
import 'package:jti_app/models/store.dart';
import 'package:jti_app/providers/api_provider.dart';
import 'package:jti_app/providers/constants.dart';
import 'package:jti_app/providers/shared.dart';
import 'package:jti_app/screens/overview.dart';
import 'package:jti_app/screens/posm_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';

class POSMScreen extends StatefulWidget {
  final Store store;

  POSMScreen({required this.store});
  @override
  _POSMScreenState createState() => _POSMScreenState();
}

class _POSMScreenState extends State<POSMScreen> {
  String? selectedOption; // Đây là giá trị được chọn từ Dropdown
  bool _isLoading = false;
  APIProvider provider = APIProvider();

  List<POSM> posmList = [];
  List<POSM> updatedPOSMList = [];
  List<String> selectedOptions = [];

  bool _takePhoto = false;

  @override
  void initState() {
    super.initState();
    provider.getListPOSM(widget.store.id).then((data) {
      setState(() {
        posmList = data;
        // Initialize selectedOptions with 'Chọn' as the default value
        selectedOptions = List.generate(posmList.length, (index) => 'Chọn');
      });
    });
  }

  Widget _buildPOSMCard(POSM posm) {
    return GestureDetector(
      onTap: () => _goToPOSMDetail(posm),
      child: Container(
        height: 100,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60, // Set width and height to create a square shape
                    height: 60,
                    margin: const EdgeInsets.all(8.0), // Add margin
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle, // Set shape to rectangle
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://jtiapi.hdcreative.vn/${posm.imagePath!}",
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        posm.name!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0), // Add padding to the DropdownButton

                child: DropdownButton<String>(
                  value: selectedOptions[posmList.indexOf(posm)],
                  onChanged: (String? newValue) {
                    setState(() {
                      // Only update selectedOptions if the newValue is not 'Chọn'
                      if (newValue != 'Chọn') {
                        selectedOptions[posmList.indexOf(posm)] = newValue!;
                        if (newValue == 'Có') {
                          posm.active = 'true';
                          _takePhoto = true;
                        } else if (newValue == 'Không') {
                          posm.active = 'false';
                        }
                      }
                    });
                  },
                  style: TextStyle(color: Colors.blueAccent),
                  items: ['Chọn', 'Có', 'Không']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> checkImagesTaken() async {
  //   bool allImagesTaken = true;

  //   for (var posm in posmList) {
  //     String posmId = posm.id.toString();
  //     List<String> filePaths =
  //         await UserData.getImagePosm(posmId, widget.store.id);

  //     if (filePaths.isEmpty) {
  //       allImagesTaken = false;
  //       break;
  //     }
  //   }

  //   if (allImagesTaken) {
  //     // Hình ảnh của tất cả các POSM đã được chụp
  //     // Tiếp tục xử lý hoàn thành
  //     updatePOSM(posmList);
  //   } else {
  //     _showMyDialog('Chưa chụp ảnh cho tất cả các POSM');
  //   }
  // }

  Future<void> checkImagesTaken() async {
    bool allImagesTaken = true;

    for (var posm in posmList) {
      String posmId = posm.id.toString();
      List<String> filePaths =
          await UserData.getImagePosm(posmId, widget.store.id);

      if (selectedOptions[posmList.indexOf(posm)] == 'Có' &&
          filePaths.isEmpty) {
        allImagesTaken = false;
        break;
      }
    }

    if (allImagesTaken) {
      // Hình ảnh của tất cả các POSM đã được chụp
      // Tiếp tục xử lý hoàn thành
      updatePOSM(posmList);
    } else {
      _showMyDialog('Chưa chụp ảnh cho tất cả các POSM đã chọn');
    }
  }

  void _goToPOSMDetail(POSM posm) {
    _takePhoto = true;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => POSMDetail(store: widget.store, posm: posm),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Stack(
      children: [
        Scaffold(
            backgroundColor: Constants.backgroundColor,
            appBar: AppBar(
              title: const Text('POSM'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 200,
                    margin: const EdgeInsets.all(8.0), // Add margin
                    padding: const EdgeInsets.all(8.0), // Add padding
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Màu viền
                        width: 1.0, // Độ dày của viền
                      ),
                      borderRadius:
                          BorderRadius.circular(8.0), // Góc bo tròn (tuỳ chọn)
                    ),
                    child: const SizedBox(
                      width: double
                          .infinity, // Để SizedBox sử dụng toàn bộ chiều rộng của Container
                      height: double
                          .infinity, // Để SizedBox sử dụng toàn bộ chiều cao của Container
                      child: Center(
                        child: Text(
                          'Guideline:\n- Hình chụp từ 50cm tới 180cm (từ đầu gối tới đỉnh đầu theo tầm mắt\n- Chụp chính diện POSM\n- Không bị che chắn bởi bất kì thứ khác (như snack, v.v)\nChụp tối thiểu 2 hình: \n+ Cách 1m\n+ Cách 3m',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                  const Text("Chọn loại POSM để chụp ảnh"),
                  Column(
                    children: posmList.map((posm) {
                      return _buildPOSMCard(posm);
                    }).toList(),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                      child: Image.asset('assets/btn_done.png'),
                      onTap: () async {
                        // if (_takePhoto == false) {
                        //   _showMyDialog("Chưa chụp ảnh POSM");
                        // } else {
                        //   updatePOSM(posmList);
                        // }
                        checkImagesTaken();
                      })
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

  Future<void> updatePOSM(List<POSM> posmList) async {
    setState(() {
      _isLoading = true;
    });

    var storeResponse = await provider.updatePOSMStatus(posmList);

    if (storeResponse['isSuccess']) {
      // Fluttertoast.showToast(
      //   msg: 'Đã lưu thông tin POSM',
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   toastLength: Toast.LENGTH_SHORT,
      // );
      Navigator.of(context).pop();
      // Sau khi xử lý xong một cửa hàng, bạn có thể thực hiện các tác vụ khác ở đây nếu cần.
    } else {
      // Fluttertoast.showToast(
      //   msg: 'Lỗi khi cập nhật thông tin POSM": ${storeResponse['message']}',
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   toastLength: Toast.LENGTH_SHORT,
      // );

      // Xử lý lỗi hoặc thực hiện các tác vụ khác ở đây nếu cần.
    }
  }

  // Future<void> updatePOSM(List<POSM> posmList) async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     List<List<String>> posmInfoList = [];

  //     for (POSM posm in posmList) {
  //       if (posm.active == 'true') {
  //         posmInfoList.add([posm.id, 'true']);
  //       } else {
  //         posmInfoList.add([posm.id, 'false']);
  //       }
  //     }

  //     await UserData.savePOSMInfo(widget.store.id, posmInfoList);

  //     Fluttertoast.showToast(
  //       msg: 'Upload thông tin POSM thành công',
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       toastLength: Toast.LENGTH_SHORT,
  //     );

  //     Navigator.of(context).pop();
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: 'Lỗi khi cập nhật thông tin POSM: $e',
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       toastLength: Toast.LENGTH_SHORT,
  //     );
  //   }
  // }

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
}
