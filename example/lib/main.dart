import 'package:flutter/material.dart';
import 'dart:async';
import 'package:payu_flutter/payu_flutter.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Make sure that this is the shop url set in PayU
  String redirectUrl = 'https://xyz.com';
  PayUOrder order = PayUOrder(
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
      ]);

  PayUFlutter payuFlutter = PayUFlutter(
    clientId: 1,
    clientSecret: 'SECRET',
    isProduction: false,
  );
  @override
  void initState() {
    super.initState();
  }

  openAsBottomModal(PayUOrderResponse payUOrderResponse) {
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
        return Center(
          child: Container(
            // height: MediaQuery.of(context).size.height,
            child: PayUWebView(
              builder: (WebViewController controller, Widget child) {
                return child;
              },
              orderResponse: payUOrderResponse,
              redirectUrl: redirectUrl,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              children: [
                FlatButton(
                  onPressed: () async {
                    PayUOrderResponse payUOrderResponse = await payuFlutter.prepareOrder(order);
                    openAsBottomModal(payUOrderResponse).then((value) {
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
                    PayUOrderResponse payUOrderResponse = await payuFlutter.prepareOrder(order);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(),
                                body: PayUWebView(
                                  builder: (WebViewController controller, Widget child) {
                                    return child;
                                  },
                                  orderResponse: payUOrderResponse,
                                  redirectUrl: redirectUrl,
                                ),
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
        ));
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // child: child,
        );
  }
}
