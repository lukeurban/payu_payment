import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payu_flutter/payu_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('payu_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await PayuFlutter.platformVersion, '42');
  });
}
