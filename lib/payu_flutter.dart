import 'dart:async';
import 'package:flutter/material.dart';
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
  PayUHttpService _payUHttpService;
  int _clientId;
  String _clientSecret;
  // MethodChannel _channel =
  //     const MethodChannel('payu_flutter');
  PayUFlutter({
    @required int clientId,
    @required String clientSecret,
    bool isProduction = false,
  }) {
    _clientId = clientId;
    _clientSecret = clientSecret;
    _payUHttpService = PayUHttpService(
      client: http.Client(),
      isProduction: isProduction,
    );
  }

  Future<PayUOrderResponse> prepareOrder(PayUOrder order) async {
    PayUAuthResponse authResponse = await _payUHttpService.authorize(_clientId, _clientSecret);
    return _payUHttpService.order(
        PayUOrderRequest(
          customerIp: '127.0.0.1',
          notifyUrl: 'https://127.0.0.1',
          order: order,
        ),
        authResponse);
  }
}
