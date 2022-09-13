import 'package:remitta_flutter_inline/remitta_flutter_inline.dart';

/// [RemittaPayment] contract that should be implemented to accept payment.
///
/// For an example implementation see [RemittaInlinePayment] class.
abstract class RemittaPayment {
  /// When called will open a remitta modal view to accept payment
  ///
  /// Must not be called before instantiating an implementation class
  Future<PaymentResponse> initiatePayment();

  /// Used to verify payment transaction before offering value to customers
  Future<PaymentResponse> verifyPayment();

  Future<PaymentResponse> cancelPayment();

  /*
  todo:: add more features:
   singleInlinePayment (without RRR)
   generateInvoice (standard),
   checkTransactionStatus + (using RRR, using OrderID)
   and many more...
   */
}
