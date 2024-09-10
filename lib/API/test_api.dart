import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String statusCode = '';
  String statusDescription = '';
  String refId = '';
  List<Map<String, dynamic>> invoiceList = [];

  @override
  void initState() {
    super.initState();
    fetchApiData();
  }

  void fetchApiData() async {
    var apiUrl = 'http://127.0.0.1:5000/your-endpoint';

    try {
      var response = await http.post(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('API Data'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DataTable(
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.amber),
                  border: TableBorder.all(),
                  columns: [
                    DataColumn(
                        label:
                            Text('Status Code', textAlign: TextAlign.center)),
                    DataColumn(
                        label: Text('Status Description',
                            textAlign: TextAlign.center)),
                    DataColumn(
                        label: Text('Ref ID', textAlign: TextAlign.center)),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text(statusCode, textAlign: TextAlign.center)),
                        DataCell(Text(statusDescription,
                            textAlign: TextAlign.center)),
                        DataCell(Text(refId, textAlign: TextAlign.center)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                DataTable(
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.amber),
                  border: TableBorder.all(),
                  columns: [
                    DataColumn(label: Text('ID', textAlign: TextAlign.center)),
                    DataColumn(
                        label: Text('Date', textAlign: TextAlign.center)),
                    DataColumn(
                        label: Text('Amount', textAlign: TextAlign.center)),
                    DataColumn(label: Text('Fee', textAlign: TextAlign.center)),
                  ],
                  rows: invoiceList
                      .map(
                        (invoice) => DataRow(
                          cells: [
                            DataCell(Text(invoice['id'],
                                textAlign: TextAlign.center)),
                            DataCell(Text(invoice['date'],
                                textAlign: TextAlign.center)),
                            DataCell(Text(invoice['amount'].toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Text(invoice['fee'].toString(),
                                textAlign: TextAlign.center)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
