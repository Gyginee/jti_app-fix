// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:jti_app/models/store.dart';
// import 'package:jti_app/providers/api_provider.dart';
// import 'package:jti_app/providers/constants.dart';
// import 'package:jti_app/screens/report_detail.dart';
// import 'package:jti_app/screens/store_detail.dart';
// import '../providers/shared.dart';

// class StorageList extends StatefulWidget {
//   @override
//   _StorageListState createState() => _StorageListState();
// }

// class _StorageListState extends State<StorageList> {
//   bool _isLoading = false;
//   int? userId = UserData.getUserId();
//   List<Store> entries = [];
//   List<Store> filteredStores = [];
//   TextEditingController searchController = TextEditingController();
//   bool isSearching = false;
//   final provider = APIProvider();

//   @override
//   void initState() {
//     super.initState();
//     getAllStore();
//     filteredStores = entries;
//   }

//   void getAllStore() async {
//     setState(() {
//       _isLoading = true;
//     });
//     final stores = await provider.getListStoreIsDone();
//     setState(() {
//       entries = stores;
//       _isLoading = false;
//     });
//   }

//   void filterStores(String searchTerm) {
//     setState(() {
//       filteredStores = entries
//           .where((store) =>
//               store.storeName
//                   .toLowerCase()
//                   .contains(searchTerm.toLowerCase()) ||
//               store.address.toLowerCase().contains(searchTerm.toLowerCase()))
//           .toList();

//       isSearching = searchTerm.isNotEmpty;
//     });
//   }

//   void _handleSaveButtonPressed() async {
//     setState(() {
//       _isLoading = true;
//     });

//     await Future.delayed(const Duration(seconds: 45)); // Chờ 1 phút

//     setState(() {
//       _isLoading = false;
//     });

//     // Hiển thị thông báo hoàn thành
//     Fluttertoast.showToast(
//       msg: "Lưu thành công",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.green,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );

//     // Điều hướng trở lại màn hình trang chủ
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Constants.backgroundColor,
//         appBar: AppBar(
//           title: const Text('Danh sách cửa hàng đã làm'),
//         ),
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: TextField(
//                     controller: searchController,
//                     onChanged: (value) {
//                       filterStores(value);
//                     },
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       hintText: 'Search',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount:
//                         isSearching ? filteredStores.length : entries.length,
//                     itemBuilder: (context, index) {
//                       final store =
//                           isSearching ? filteredStores[index] : entries[index];
//                       return ListTile(
//                         title: Text(store.storeName),
//                         subtitle: Text(store.address),
//                         onTap: () async {
//                           setState(() {
//                             _isLoading = true;
//                           });
//                           String storeId = store.id;
//                           Store storeDetail =
//                               await provider.getDetailStore(storeId);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => ReportDetail(
//                                 store: storeDetail,
//                               ),
//                             ),
//                           );
//                           setState(() {
//                             _isLoading = false;
//                           });
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _handleSaveButtonPressed,
//                   child: const Text("Lưu"),
//                 )
//               ],
//             ),
//             Visibility(
//               visible: _isLoading,
//               child: Container(
//                 color: const Color.fromRGBO(0, 0, 0, 0.3),
//                 child: const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jti_app/models/store.dart';
import 'package:jti_app/providers/api_provider.dart';
import 'package:jti_app/providers/constants.dart';
import 'package:jti_app/screens/report_detail.dart';
import 'package:jti_app/screens/store_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/shared.dart';

class StorageList extends StatefulWidget {
  @override
  _StorageListState createState() => _StorageListState();
}

class _StorageListState extends State<StorageList> {
  bool _isLoading = false;
  int? userId = UserData.getUserId();
  List<Store> entries = [];
  List<Store> filteredStores = [];
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  final provider = APIProvider();

  @override
  void initState() {
    super.initState();
    getAllStore();
    filteredStores = entries;
  }

  void getAllStore() async {
    setState(() {
      _isLoading = true;
    });
    List<Store>? stores = await UserData
        .getStoreList(); // Lấy danh sách store từ SharedPreferences

    if (stores != null) {
      setState(() {
        entries = stores;
        filteredStores = entries;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void filterStores(String searchTerm) {
    setState(() {
      filteredStores = entries
          .where((store) =>
              store.storeName
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase()) ||
              store.storeName.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();

      isSearching = searchTerm.isNotEmpty;
    });
  }

  // void _handleSaveButtonPressed() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   //await Future.delayed(const Duration(seconds: 45)); // Chờ 1 phút

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   // Hiển thị thông báo hoàn thành
  //   Fluttertoast.showToast(
  //     msg: "Lưu thành công",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.green,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );

  //   // Điều hướng trở lại màn hình trang chủ
  //   Navigator.pop(context);
  // }

  // void _handleSaveButtonPressed() async {
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   // Xoá danh sách cửa hàng từ SharedPreferences
  //   await SharedPreferences.getInstance().then((prefs) {
  //     prefs.remove('store_list');
  //   });

  //   setState(() {
  //     _isLoading = false;
  //   });

  //   // Hiển thị thông báo hoàn thành
  //   Fluttertoast.showToast(
  //     msg: "Đã lưu thành công",
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: Colors.green,
  //     textColor: Colors.white,
  //     fontSize: 16.0,
  //   );

  //   // Điều hướng trở lại màn hình trang chủ
  //   Navigator.pop(context);
  // }

  void _handleSaveButtonPressed() async {
    setState(() {
      _isLoading = true;
    });

    // Đợi 30 giây
    await Future.delayed(const Duration(seconds: 30));

    // Xoá danh sách cửa hàng từ SharedPreferences
    await SharedPreferences.getInstance().then((prefs) {
      prefs.remove('store_list');
    });

    setState(() {
      _isLoading = false;
    });

    // Hiển thị thông báo hoàn thành
    Fluttertoast.showToast(
      msg: "Danh sách cửa hàng đã được lưu",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    // Điều hướng trở lại màn hình trang chủ
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          title: const Text('Danh sách cửa hàng đã làm'),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filterStores(value);
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        isSearching ? filteredStores.length : entries.length,
                    itemBuilder: (context, index) {
                      final store =
                          isSearching ? filteredStores[index] : entries[index];
                      return ListTile(
                        title: Text(store.storeName),
                        subtitle: Text(store.address),
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          String storeId = store.id.toString();
                          Store storeDetail =
                              await provider.getDetailStore(storeId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDetail(
                                store: storeDetail,
                              ),
                            ),
                          );
                          setState(() {
                            _isLoading = false;
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _handleSaveButtonPressed,
                  child: const Text("Lưu"),
                )
              ],
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
}
