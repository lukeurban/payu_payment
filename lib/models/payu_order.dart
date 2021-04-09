import 'package:payu_payment/models/payu_buyer.dart';
import 'package:payu_payment/models/payu_product.dart';

class PayUOrder {
  final int posId;
  final String description;
  final String currencyCode;
  final PayUBuyer buyer;
  final List<PayUProduct> products;
  PayUOrder({
    required this.posId,
    required this.description,
    required this.currencyCode,
    required this.buyer,
    this.products = const [],
  });
  Map<String, dynamic> toJson() => {
        'merchantPosId': posId,
        'description': description,
        'currencyCode': currencyCode,
        'buyer': buyer.toJson(),
        'products': List<Map<String, dynamic>>.from(
          products.map(
            (product) => product.toJson(),
          ),
        ),
      };
}

class PayUOrderRequest {
  final String notifyUrl;
  final String customerIp;
  final String extOrderId;
  final PayUOrder order;
  PayUOrderRequest({
    required this.order,
    required this.notifyUrl,
    required this.customerIp,
    this.extOrderId = '',
  });

  Map<String, dynamic> toJson() => {
        'notifyUrl': notifyUrl,
        'extOrderId': extOrderId,
        'customerIp': customerIp,
        'totalAmount': order.products
            .map((e) => e.quantity * e.unitPrice)
            .reduce((accumulator, current) => accumulator + current),
        ...order.toJson(),
      };
}

class PayUOrderResponse {
  final PayUOrderResponseStatus status;
  late final String redirectUri;
  late final String orderId;
  late final String extOrderId;

  PayUOrderResponse.fromJson(Map<String, dynamic> json)
      : status = PayUOrderResponseStatus.fromJson(json['status']),
        redirectUri = json['redirectUri'],
        orderId = json['orderId'],
        extOrderId = json['extOrderId'];
}

class PayUOrderResponseStatus {
  final PayUOrderStatus? statusCode;
  PayUOrderResponseStatus.fromJson(Map<String, dynamic> json)
      : statusCode = payUOrderStatusResponseMap[json['statusCode']];
}

enum PayUOrderStatus {
  Success,
  WarningContinueRedirect,
  WarningContinue_3Ds,
  WarningContinueCvv,
  ErrorSyntax,
  ErrorValueInvalid,
  ErrorValueMissing,
  ErrorOrderNotUnique,
  Unauthorized,
  UnauthorizedRequest,
  DataNotFound,
  Timeout,
  BusinessError,
  ErrorInternal,
  GeneralError,
  Warning,
  ServiceNotAvailable,
}

const Map<String, PayUOrderStatus> payUOrderStatusResponseMap = {
  'SUCCESS': PayUOrderStatus.Success,
  'WARNING_CONTINUE_REDIRECT': PayUOrderStatus.WarningContinueRedirect,
  'WARNING_CONTINUE_3DS': PayUOrderStatus.WarningContinue_3Ds,
  'WARNING_CONTINUE_CVV': PayUOrderStatus.WarningContinueCvv,
  'ERROR_SYNTAX': PayUOrderStatus.ErrorSyntax,
  'ERROR_VALUE_INVALID': PayUOrderStatus.ErrorValueInvalid,
  'ERROR_VALUE_MISSING': PayUOrderStatus.ErrorValueMissing,
  'ERROR_ORDER_NOT_UNIQUE': PayUOrderStatus.ErrorOrderNotUnique,
  'UNAUTHORIZED': PayUOrderStatus.Unauthorized,
  'UNAUTHORIZED_REQUEST': PayUOrderStatus.UnauthorizedRequest,
  'DATA_NOT_FOUND': PayUOrderStatus.DataNotFound,
  'TIMEOUT': PayUOrderStatus.Timeout,
  'BUSINESS_ERROR': PayUOrderStatus.BusinessError,
  'ERROR_INTERNAL': PayUOrderStatus.ErrorInternal,
  'GENERAL_ERROR': PayUOrderStatus.GeneralError,
  'WARNING': PayUOrderStatus.Warning,
  'SERVICE_NOT_AVAILABLE': PayUOrderStatus.ServiceNotAvailable,
};
