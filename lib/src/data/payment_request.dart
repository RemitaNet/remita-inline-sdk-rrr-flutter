import 'package:remita_flutter_inline/remita_flutter_inline.dart';

/// [PaymentRequest] data object for accepting payment with RRR
class PaymentRequest {
  String key;
  String rrr;
  RemitaEnvironment environment;

  PaymentRequest({required this.key, required this.rrr, required this.environment});
}
