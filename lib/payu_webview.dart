import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payu_payment/payu_payment.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayUWebView extends StatefulWidget {
  const PayUWebView({
    Key? key,
    required this.builder,
    required this.redirectUrl,
    this.onPaymentEnd,
    required this.orderResponse,
    this.customLoadingWidget,
  }) : super(key: key);
  final Function(WebViewController? controller, Widget child) builder;
  final PayUOrderResponse orderResponse;
  final Widget? customLoadingWidget;
  final String redirectUrl;
  final Function(bool paymentSuccessful)? onPaymentEnd;
  @override
  _PayUWebViewState createState() => _PayUWebViewState();
}

class _PayUWebViewState extends State<PayUWebView> {
  WebViewController? controller;
  double opacity = 0;

  callback(bool result) {
    if (widget.onPaymentEnd != null) {
      widget.onPaymentEnd!(result);
    } else {
      Navigator.of(context).pop(result);
    }
  }

  Widget webViewBody() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.customLoadingWidget ?? CircularProgressIndicator(),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 150),
            opacity: opacity,
            child: WebView(
              navigationDelegate: (NavigationRequest request) {
                // TO remmove this strange button overlay BUG in webView or PayU
                controller?.scrollBy(0, 1);
                if (request.url.contains('error')) {
                  callback(false);

                  return NavigationDecision.prevent;
                } else if (request.url.contains(widget.redirectUrl)) {
                  callback(true);
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
              onWebViewCreated: (WebViewController webViewController) {
                controller = webViewController;
              },
              onPageFinished: (url) async {
                if (mounted) {
                  setState(() {
                    opacity = 1;
                  });
                }
              },
              userAgent:
                  "Mozilla/5.0 (iPhone; CPU iPhone OS 14_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1",
              initialUrl: widget.orderResponse.redirectUri,
              javascriptMode: JavascriptMode.unrestricted,
              gestureRecognizers: Set()
                ..add(
                    Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = webViewBody();
    return Scaffold(
      body: widget.builder(controller, child),
    );
  }
}
