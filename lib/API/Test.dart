import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

String responseText = '';

void main() {
  apicall();
}

Future<void> apicall() async {
  var app_id = 'd4820a2a-2aec-41ad-a37c-0c5d09389a08';
  var app_secret = '5t5WqPBOel9d3R/wxlztKqvkGq6UBYAxcvaurdeJ0rU=';
  var request_id = 'ffffffff-ffff-ffff-ffff-ffffffffffff';
  var http_method = 'POST';
  var http_request_body =
      '{"service_code":"AIS_POSTPAID","query":"0910011918","device_type":1,"device_id":"AABBCCDD","location_id":"1","cashier_id":"0001"}';
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

  var headers = {
    'X-Rabbit-ID': request_id,
    'X-Rabbit-Datetime': request_datetime,
    'X-Rabbit-Auth': rabbit_auth,
    'Content-Type': 'application/json'
  };
  var request = http.Request(
      'POST', Uri.parse('https://bpg-test.api.rabbit.co.th/v1/bill/query'));
  request.body = json.encode(http_request_body);
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    responseText = await response.stream.bytesToString();
    print(responseText);
  } else {
    print(response.reasonPhrase);
  }
}
