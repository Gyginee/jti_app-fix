// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jti_app/models/store.dart';
import 'package:jti_app/providers/api_provider.dart';
import 'package:jti_app/providers/constants.dart';
import 'package:jti_app/screens/store_detail.dart';
import '../providers/shared.dart';

void main() {
  runApp(StoreListScreen());
}

class StoreListScreen extends StatefulWidget {
  @override
  _StoreListScreenState createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
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
    final stores = await provider.getListStoreByUser(userId!);
    setState(() {
      entries = stores;
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
              store.address.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();

      isSearching = searchTerm.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        appBar: AppBar(
          title: const Text('Danh sách cửa hàng'),
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
                        subtitle: Text("${store.address} Lịch: ${store.calendar}"),
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          String storeId = store.id;
                          Store storeDetail =
                              await provider.getDetailStore(storeId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreDetailScreen(
                                  store: storeDetail,),
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
