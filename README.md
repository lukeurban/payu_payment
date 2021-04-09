# payu_flutter

Simple PayU integration for Flutter.

## Usage

For now, you can use `PayUWebView` widget to build your PayU WebView. First you need to:

1. create and configure `PayUFlutter` object
2. create and place `PayUOrder` using using `prepareOrder` method
3. pass response from `prepareOrder` it to `PayUWebView` widget.

## Example:

#### Crating and configure `PayUFlutter` object

```dart
 PayUFlutter payuFlutter = PayUFlutter(
    clientId: 1,
    clientSecret: 'SECRET',
    isProduction: false,
  );
```

#### Create and place `PayUOrder` using using `prepareOrder` method

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

#### Pass response from `prepareOrder` it to `PayUWebView` widget.

```dart
 PayUWebView(
        builder: (WebViewController controller, Widget child) {
            return child;
        },
        orderResponse: payUOrderResponse,
        redirectUrl: redirectUrl,
    )

```

See example where I implemented 2 different flows of displaying the WebView. **Remember to place there your valid PayU account settings**
`WebViewController` is available in builder to allow doing some webview magic like reload, refresh go back etc.
