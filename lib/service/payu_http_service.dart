import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:payu_payment/models/payu_auth.dart';
import 'package:payu_payment/models/payu_order.dart';

class PayUHttpService {
  final http.Client client;
  final bool isProduction;
  PayUHttpService({
    required this.client,
    this.isProduction = false,
  });

  Future<PayUAuthResponse> authorize(int? clientId, String? clientSecret) async {
    String data = 'grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret';
    http.Response res =
        await http.post(Uri.parse('$baseUrl/pl/standard/user/oauth/authorize?$data'));
    if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
    Map<String, dynamic> json = jsonDecode(res.body);
    return PayUAuthResponse.fromJson(json);
  }

  Future<PayUOrderResponse> order(PayUOrderRequest orderRequest, PayUAuthResponse auth) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ${auth.accessToken}',
    };
    http.Response res = await http.post(
      Uri.parse('$baseUrl/api/v2_1/orders'),
      headers: headers,
      body: jsonEncode(orderRequest.toJson()),
    );
    Map<String, dynamic> json = jsonDecode(res.body);
    print(json);
    if (json['status']['statusCode'] != 'SUCCESS')
      throw Exception('http.post error: statusCode= ${res.statusCode}');
    return PayUOrderResponse.fromJson(json);
  }

  String get baseUrl {
    return isProduction ? 'https://secure.payu.com' : 'https://secure.snd.payu.com';
  }
}
