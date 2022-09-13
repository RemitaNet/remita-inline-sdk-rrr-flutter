import 'package:remitta_flutter_inline/remitta_flutter_inline.dart';

/// [PaymentRequest] data object for accepting payment with RRR
class PaymentRequest {
  String key;
  String rrr;
  RemittaEnvironment environment;

  PaymentRequest({required this.key, required this.rrr, required this.environment});
}
