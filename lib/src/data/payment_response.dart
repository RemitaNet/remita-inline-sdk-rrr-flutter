import 'package:remitta_flutter_inline/src/data/payment_response_data.dart';

class PaymentResponse {
  String? code = "";
  String? message = "";
  PaymentResponseData? data;

  PaymentResponse({
    this.code,
    this.message,
    this.data,
  });

  Map<String, String?> toJson() =>
      {'code': code, 'message': message, 'data': data.toString()};

  @override
  String toString() {
    return toJson().toString();
  }
}
