# payu_payment

Simple PayU integration for Flutter.

## Usage

For now, you can use `PayUWebView` widget to build your PayU WebView. First you need to:

1. create and configure `PayUFlutter` object
2. create and place `PayUOrder` using using `prepareOrder` method
3. pass response from `prepareOrder` it to `PayUWebView` widget.

## Example:

### Crating and configure `PayUFlutter` object

```dart
 PayUFlutter payuFlutter = PayUFlutter(
    clientId: 1,
    clientSecret: 'SECRET',
    isProduction: false,
  );
```

### Create and place `PayUOrder` using using `prepareOrder` method

```dart
  PayUOrder order = PayUOrder(
      posId: 398870,
      description: 'ZAKUPY',
      currencyCode: 'PLN',
      buyer: PayUBuyer(
        email: 'thatlukeurban@gmail.com',
        firstName: 'null',
        language: 'pl',
        lastName: 'null',
        phone: '555555555',
      ),
      products: [
        PayUProduct(
          name: 'poo',
          unitPrice: 100,
          quantity: 10,
        )
      ]);
    PayUOrderResponse payUOrderResponse = await payuFlutter.prepareOrder(order);
```

### Pass response from `prepareOrder` it to `PayUWebView` widget.

```dart
 PayUWebView(
        builder: (WebViewController controller, Widget child) {
            return child;
        },
        orderResponse: payUOrderResponse,
        redirectUrl: redirectUrl,
        onPaymentEnd: (bool paymentSuccessful) {
          // If you don't override onPaymentEnd method that Navigator pop will be done by default
          Navigator.of(context).pop(paymentSuccessful);
        }
    )

```

- `builder`- required - builder is public in order to access `WebViewController`. This allows devs to wrap `child` with some widgets that provide features like reload, refresh go back etc. See [WebViewController documentation](https://pub.dev/documentation/webview_flutter/latest/webview_flutter/WebViewController-class.html)
- `orderResponse` - required - **PayUOrderResponse** - response object from **payuFlutter.prepareOrder(order);**
- `onPaymentEnd` - optional - **Function(bool)** - by default it does **Navigator.of(context).pop();** but you can override this behavior

- `customLoadingWidget` - optional - **Widget** - Shows when webView is loading. By default it's `CircularProgressIndicator`
- `redirectUrl` - required - **String** - Redirect url is a crucial part of `payu_payment` is setting. It needs to be the same url as in PayU shop `Website address *:`(shown on screenshot). That URL is where the PayU flow ends in the WebView. The plugin uses that to detect when user payment was successful.

!['payU screen](https://i.imgur.com/ORRIkO4.png)

See example where I implemented 2 different flows of displaying the WebView. **Remember to place there your valid PayU account settings**
