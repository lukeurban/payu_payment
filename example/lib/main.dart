import 'package:flutter/material.dart';
import 'dart:async';
import 'package:payu_flutter/payu_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PayUFlutter payuFlutter = PayUFlutter(
    clientId: 398870,
    clientSecret: 'ee63c45f6df391939f3b8b1d354df198',
    redirectUrl: 'https://lukeurban.tech',
    isProduction: false,
  );
  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  FlatButton(
                    onPressed: () {
                      payuFlutter
                          .orderInBottomModalSheed(
                        context,
                        PayUOrder(
                            posId: 398870,
                            description: 'ZAKUPY',
                            currencyCode: 'PLN',
                            buyer: PayUBuyer(
                              email: 'lucius.urbanski@gmail.com',
                              firstName: 'null',
                              language: 'pl',
                              lastName: 'null',
                              phone: '555555555',
                            ),
                            products: [
                              PayUProduct(
                                name: 'Air',
                                unitPrice: 100,
                                quantity: 10,
                              )
                            ]),
                      )
                          .then((value) {
                        String result = value == true ? 'Successful' : 'Unsuccesfull';
                        print('Payment was: $result');
                      });
                    },
                    child: Text(
                      "Authorize in bottom modal",
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      Widget webView = await payuFlutter.getPayUWebView(PayUOrder(
                          posId: 398870,
                          description: 'ZAKUPY',
                          currencyCode: 'PLN',
                          buyer: PayUBuyer(
                            email: 'lucius.urbanski@gmail.com',
                            firstName: 'null',
                            language: 'pl',
                            lastName: 'null',
                            phone: '555555555',
                          ),
                          products: [
                            PayUProduct(
                              name: 'Air',
                              unitPrice: 100,
                              quantity: 10,
                            )
                          ]));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Scaffold(
                                  appBar: AppBar(),
                                  body: webView,
                                )),
                      ).then((value) {
                        String result = value == true ? 'Successful' : 'Unsuccesfull';
                        print('Payment was: $result');
                      });
                    },
                    child: Text(
                      "Authorize otherView",
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
