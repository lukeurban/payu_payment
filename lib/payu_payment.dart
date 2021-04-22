import 'dart:async';
import 'package:payu_payment/models/payu_auth.dart';
import 'package:payu_payment/models/payu_order.dart';
import 'package:payu_payment/service/payu_http_service.dart';
import 'package:http/http.dart' as http;

export 'package:payu_payment/models/payu_buyer.dart';
export 'package:payu_payment/models/payu_product.dart';
export 'package:payu_payment/models/payu_order.dart';
export 'package:payu_payment/payu_webview.dart';
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

  ///  Does authorization and placing and order. Returns **PayUOrderResponse** which contains URL used by WebView
  Future<PayUOrderResponse> prepareOrder(PayUOrder order) async {
    PayUAuthResponse authResponse =
        await _payUHttpService.authorize(clientId, clientSecret);
    return _payUHttpService.order(
        PayUOrderRequest(
          customerIp: '127.0.0.1',
          notifyUrl: 'https://127.0.0.1',
          order: order,
        ),
        authResponse);
  }
}
