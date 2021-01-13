import 'dart:async';
import 'package:flutter/material.dart';
import 'package:payu_flutter/models/payu_auth.dart';
import 'package:payu_flutter/models/payu_order.dart';
import 'package:payu_flutter/payu_webview.dart';
import 'package:payu_flutter/service/payu_http_service.dart';
import 'package:http/http.dart' as http;

export 'package:payu_flutter/models/payu_buyer.dart';
export 'package:payu_flutter/models/payu_product.dart';
export 'package:payu_flutter/models/payu_order.dart';

class PayUFlutter {
  PayUHttpService _payUHttpService;
  int _clientId;
  String _clientSecret;
  String _redirectUrl;
  // MethodChannel _channel =
  //     const MethodChannel('payu_flutter');
  PayUFlutter({
    @required int clientId,
    @required String clientSecret,
    @required String redirectUrl,
    bool isProduction = false,
  }) {
    _clientId = clientId;
    _clientSecret = clientSecret;
    _redirectUrl = redirectUrl;
    _payUHttpService = PayUHttpService(
      client: http.Client(),
      isProduction: isProduction,
    );
  }

  Future<bool> orderInBottomModalSheed(BuildContext context, PayUOrder order,
      {Widget customLoadingWidegt}) async {
    PayUOrderResponse response = await _order(order);
    return showModalBottomSheet(
      useRootNavigator: true,
      elevation: 20,
      enableDrag: false,
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: PayUWebView(
            redirectUrl: _redirectUrl,
            orderResponse: response,
            customLoadingWidget: customLoadingWidegt,
          ),
        );
      },
    );
  }

  Future<Widget> getPayUWebView(PayUOrder order, {Widget customLoadingWidegt}) async {
    PayUOrderResponse response = await _order(order);
    return PayUWebView(
      redirectUrl: _redirectUrl,
      orderResponse: response,
      customLoadingWidget: customLoadingWidegt,
      showNavigation: false,
    );
  }

  Future<PayUOrderResponse> _order(PayUOrder order) async {
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
