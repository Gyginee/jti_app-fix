import 'package:flutter/material.dart';
import 'package:jti_app/providers/shared.dart';
import 'package:jti_app/screens/login.dart';
import 'package:jti_app/screens/report.dart';
import 'package:jti_app/screens/storage_list.dart';
import 'package:jti_app/screens/store_list.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key}) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? userId = UserData.getUserId();
  String username = UserData.getUsername().toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2FD),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trang chủ'),
        actions: [
          ElevatedButton(
            onPressed: () {
              logout();
            },
            child: const Text("Đăng xuất"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Center(
              child: Image(image: AssetImage('assets/logo.png')),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 10),
              child: Text(
                "Hello user: $username",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 10),
              child: Wrap(
                alignment: WrapAlignment.start, // Căn trái
                spacing: 16.0, // Khoảng cách giữa các cột
                runSpacing: 16.0, // Khoảng cách giữa các hàng
                children: [
                  SizedBox(
                    width: 160,
                    height: 200,
                    child: InkWell(
                      child: Image.asset('assets/btn_store.png'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoreListScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  InkWell(
                    child: Image.asset('assets/btn_report.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportScreen(),
                        ),
                      );
                    },
                  ),
                  InkWell(
                    child: Image.asset('assets/btn_luutru.png'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StorageList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout() {
    UserData.removeUserId();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
    );
  }
}
