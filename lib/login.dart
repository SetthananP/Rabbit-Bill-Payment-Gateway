import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_rabbit/qr_scanner.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class EnterValue extends StatefulWidget {
  const EnterValue({Key? key}) : super(key: key);

  @override
  State<EnterValue> createState() => _EnterValueState();
}

class _EnterValueState extends State<EnterValue> {
  final appIdController = TextEditingController();
  final appSecretController = TextEditingController();

  final userdata = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter App ID and App Secret'),
        backgroundColor: Color(0xFFFC6C05),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 18,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: appIdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'App ID',
                    contentPadding: const EdgeInsets.all(10),
                    hintStyle: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: appSecretController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'App Secret',
                    contentPadding: const EdgeInsets.all(10),
                    hintStyle: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              MaterialButton(
                color: Color(0xFFFC6C05),
                child: Text(
                  "Submit",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () async {
                  String appId = appIdController.text;
                  String appSecret = appSecretController.text;

                  if (appId != '' && appSecret != '') {
                    print('Successfull');

                    userdata.write('isLogged', true);
                    userdata.write('appId', appId);
                    userdata.write('appSecret', appSecret);

                    Get.offAll(HomeScreen());
                  } else {
                    Get.snackbar("Error", "Please Enter Username & Password",
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
