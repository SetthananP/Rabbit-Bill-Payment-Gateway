import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_rabbit/view_result.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scan/scan.dart';
import 'package:get_storage/get_storage.dart';

import 'login.dart';

Barcode? result;
String? qrcode, userPost;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double height, width;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * 0.5,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFC6C05),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: Text(
                        "Barcode & QR code Scanner ",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "If you want to scan, click this button.",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: height * 0.25,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: QRViewExample(),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        width: 170,
                        height: 50,
                        color: Color(0xFFF06706),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFFF06706),
                            side: BorderSide(
                              width: 2,
                              color: Color(0xFFF06706),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewResult(),
                              ),
                            );
                          },
                          child: Text(
                            "View Result",
                            style: GoogleFonts.inter(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFF06706),
                          fixedSize: Size(150, 50),
                          side: BorderSide(width: 2, color: Color(0xFFF06706)),
                        ),
                        onPressed: () {
                          userdata.write('isLogged', false);
                          userdata.remove('username');
                          Get.offAll(EnterValue());
                        },
                        child: Text(
                          "Setting",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: Color(0xFFF06706),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnterNumberPage extends StatelessWidget {
  final mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 60.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 30,
                    color: const Color(0xFFFC6C05),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 50),
                      child: Text(
                        'Enter Your Number',
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: const Color(0xFFFC6C05),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Material(
                      child: TextFormField(
                        controller: mobileController,
                        validator: (val) {
                          if (mobileController.text.length != 10) {
                            return 'Please Enter valid mobile number';
                          }
                          return null;
                        },
                        keyboardType: Platform.isIOS
                            ? TextInputType.number
                            : TextInputType.text,
                        maxLength: 10,
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.5),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          hintText: 'Enter your number',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        elevation: 1,
                        backgroundColor: const Color(0xFFFC6C05),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          userPost = mobileController.text;
                          print(userPost);
                          result = null;
                          qrcode = null;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        }
                      },
                      child: Text(
                        "Save",
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

final userdata = GetStorage();

class _QRViewExampleState extends State<QRViewExample> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    setState(() {
      result = null;
      qrcode = null;
    });

    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File(pickedImage.path);
      String? str = await Scan.parse(pickedImage.path);
      if (str != null) {
        setState(() {
          File(pickedImage.path);
          qrcode = str;
        });
      }
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  void _goToEnterNumberPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterNumberPage(),
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      } else if (Platform.isIOS) {
        controller!.resumeCamera();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: _goToEnterNumberPage,
                      child: Container(
                        width: 50,
                        height: 90,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: const Color(0xFFFC6C05),
                        ),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: _goToEnterNumberPage,
                              icon: Icon(
                                Icons.phone,
                                size: 45,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Enter your number',
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 175,
                    height: 90,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: const Color(0xFFFC6C05),
                    ),
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => _buildQrView(context),
                              ),
                            );
                          },
                          icon: Icon(Icons.qr_code_scanner_rounded),
                          iconSize: 45,
                          color: Colors.white,
                        ),
                        Text(
                          'Scan',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text(
                      'Result Data: ${result!.code} ', //Barcode Type: ${describeEnum(result!.format)}
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (qrcode != null)
                    Text(
                      'Result Data: $qrcode',
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (userPost != null)
                    Text(
                      "Result Data: $userPost",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return Scaffold(
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: const Color(0xFFF06706),
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea,
            ),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
          Positioned(
            top: 60,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.white,
                iconSize: 35,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              color: Colors.white,
              child: Center(
                child: FloatingActionButton(
                  onPressed: _openImagePicker,
                  child: Icon(
                    Icons.image,
                    size: 35,
                    color: Colors.white,
                  ),
                  backgroundColor: Color(0xFFF06706),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(
    QRViewController controller,
  ) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        qrcode = null;
      });
      if (result != null) {
        controller.pauseCamera();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
