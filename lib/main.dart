import 'package:flutter/material.dart';
import 'package:my_rabbit/qr_scanner.dart';
import 'login.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      title: 'QR Scanner',
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userdate = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userdate.writeIfNull('isLogged', false);
    Future.delayed(Duration.zero, () async {
      checkiflogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void checkiflogged() {
    userdate.read('isLogged')
        ? Get.offAll(HomeScreen())
        : Get.offAll(EnterValue());
  }
}
