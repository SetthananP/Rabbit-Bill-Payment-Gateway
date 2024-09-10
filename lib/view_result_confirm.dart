import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class ViewResultConfirm extends StatefulWidget {
  final String refId;

  const ViewResultConfirm({super.key, required this.refId});

  @override
  State<ViewResultConfirm> createState() => _ViewResultConfirmState();
}

class _ViewResultConfirmState extends State<ViewResultConfirm> {
  final userdata = GetStorage();

  String responseText = '';
  String statusCode = '';
  String statusDescription = '';
  String refId = '';
  int amount = 0;
  int fee = 0;
  String ref1 = '';

  @override
  void initState() {
    super.initState();
    confirmApiData();
  }

  void confirmApiData() async {
    var app_id = '${userdata.read('appId')}';
    var app_secret = '${userdata.read('appSecret')}';
    var request_id = 'ffffffff-ffff-ffff-ffff-ffffffffffff';
    var http_method = 'POST';
    var http_request_body = {"ref_id": widget.refId};
    var request_datetime = '1684058400';
    var http_path = '/v1/bill/confirm';
    var nonce = '0123456789AbCdEf';

    var data_to_hmac =
        '$app_id|$http_method|$http_path|$http_request_body|$request_id|$request_datetime|$nonce';

    var app_secret_to_hmac = base64.decode(app_secret);

    var data_to_hmac_buffer = utf8.encode(data_to_hmac);

    var hmacSha256 = Hmac(sha256, app_secret_to_hmac);
    var sign = hmacSha256.convert(data_to_hmac_buffer);

    var base64_1 = base64.encode(sign.bytes);

    var base64Url = base64_1
        .replaceAll(RegExp(r'=+'), '')
        .replaceAll(RegExp(r'\+'), '-')
        .replaceAll(RegExp(r'\/'), '_');

    var rabbitAuthenticationToken = '$app_id.$nonce.$base64Url';

    var rabbit_auth = rabbitAuthenticationToken;

    
    var apiUrl = 'http://127.0.0.1:5000/your-confirm';

    try {
      var headers = {
        'X-Rabbit-ID': request_id,
        'X-Rabbit-Datetime': request_datetime,
        'X-Rabbit-Auth': rabbit_auth,
        'Content-Type': 'application/json'
      };

      var request = http.Request(
        'POST',
        Uri.parse(apiUrl),
      );
      request.body = json.encode(http_request_body);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        responseText = await response.stream.bytesToString();
        var responseData = json.decode(responseText);
        setState(() {
          statusCode = responseData['status_code'];
          statusDescription = responseData['status_description'];
          refId = responseData['ref_id'];
          amount = responseData['result']['amount'];
          fee = responseData['result']['fee'];
          ref1 = responseData['result']['ref1'];
        });
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFFC6C05),
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
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 50),
                        child: Text(
                          'Confirm Data Succeed',
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: Colors.white,
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
              flex: 3,
              child: FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.9,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 25),
                            child: DataTable(
                              border: TableBorder.all(width: 1),
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFFFC6C05)),
                              columnSpacing: 18,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'status_code',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'status_description',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'ref_id',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                              rows: [
                                DataRow(
                                  cells: [
                                    DataCell(
                                      Center(
                                        child: Text(
                                          statusCode.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          statusDescription,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          refId.toString(),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Container(
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                (states) => const Color(0xFFFC6C05),
                              ),
                              border: TableBorder.all(),
                              columns: const [
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      "Amount",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      "Fee",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      "Ref1",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                              rows: [
                                DataRow(
                                  cells: [
                                    DataCell(
                                      Text(
                                        amount.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        fee.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        ref1.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
