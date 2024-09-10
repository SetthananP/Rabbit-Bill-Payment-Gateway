import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_rabbit/qr_scanner.dart';
import 'package:my_rabbit/view_result_validate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

class ViewResult extends StatefulWidget {
  const ViewResult({Key? key}) : super(key: key);

  @override
  State<ViewResult> createState() => _ViewResultState();
}

class _ViewResultState extends State<ViewResult> {
  final userdata = GetStorage();

  String responseText = '';
  String statusCode = '';
  String statusDescription = '';
  String refId = '';
  List<Map<String, dynamic>> invoiceList = [];
  String amount = '';

  @override
  void initState() {
    super.initState();
    queryApiData();
  }

  String getFirstNonNullValue() {
    if (result != null && result!.code != null) {
      return result!.code!;
    } else if (qrcode != null) {
      return qrcode!;
    } else if (userPost != null) {
      return userPost!;
    } else {
      return 'No Value Found';
    }
  }

  void queryApiData() async {
    var app_id =
        '${userdata.read('appId')}'; //'d4820a2a-2aec-41ad-a37c-0c5d09389a08';
    var app_secret =
        '${userdata.read('appSecret')}'; //'5t5WqPBOel9d3R/wxlztKqvkGq6UBYAxcvaurdeJ0rU=';
    var request_id = 'ffffffff-ffff-ffff-ffff-ffffffffffff';
    var http_method = 'POST';
    var http_request_body =
        '{"service_code":"AIS_POSTPAID","query": $getFirstNonNullValue() ,"device_type":1,"device_id":"AABBCCDD","location_id":"1","cashier_id":"0001"}';
    var request_datetime = '1684058400';
    var http_path = '/v1/bill/query';
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

    var apiUrl = 'http://127.0.0.1:5000/your-query';

    //var apiUrl = 'https://bpg-test.api.rabbit.co.th/v1/bill/query';

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
          invoiceList = List<Map<String, dynamic>>.from(
              responseData['result']['invoice_list']);
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 20.0),
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
                            'Query Data Succeed',
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              border: TableBorder.all(width: 1),
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => const Color(0xFFFC6C05)),
                              columnSpacing: 18,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'Status Code',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Description',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Ref ID',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
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
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          statusDescription,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          refId.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => const Color(0xFFFC6C05)),
                            border: TableBorder.all(width: 1),
                            columns: const [
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'ID',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Date',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Amount',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'Fee',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                            rows: invoiceList
                                .map(
                                  (invoice) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          invoice['id'].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          invoice['date'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          invoice['amount'].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          invoice['fee'].toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewResultValidate(
                                    refId: refId,
                                    amount:
                                        invoiceList[0]['amount'].toString()),
                              ),
                            );
                          },
                          child: const Text('Validate'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFC6C05),
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(2.0),
                              ),
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
        ),
      ),
    );
  }
}
