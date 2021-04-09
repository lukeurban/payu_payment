import 'dart:async';
import 'package:payu_flutter/models/payu_auth.dart';
import 'package:payu_flutter/models/payu_order.dart';
import 'package:payu_flutter/service/payu_http_service.dart';
import 'package:http/http.dart' as http;

export 'package:payu_flutter/models/payu_buyer.dart';
export 'package:payu_flutter/models/payu_product.dart';
export 'package:payu_flutter/models/payu_order.dart';
export 'package:payu_flutter/payu_webview.dart';
export 'package:webview_flutter/webview_flutter.dart';

class PayUFlutter {
  late PayUHttpService _payUHttpService;
  int clientId;
  String clientSecret;

  PayUFlutter({
    required this.clientId,
    required this.clientSecret,
    bool isProduction = false,
  }) {
    _payUHttpService = PayUHttpService(
      client: http.Client(),
      isProduction: isProduction,
    );
  }

  Future<PayUOrderResponse> prepareOrder(PayUOrder order) async {
    PayUAuthResponse authResponse = await _payUHttpService.authorize(clientId, clientSecret);
    return _payUHttpService.order(
        PayUOrderRequest(
          customerIp: '127.0.0.1',
          notifyUrl: 'https://127.0.0.1',
          order: order,
        ),
        authResponse);
  }
}
