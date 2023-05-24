import 'package:remita_flutter_inline/remita_flutter_inline.dart';

/// [RemitaPayment] contract that should be implemented to accept payment.
///
/// For an example implementation see [RemitaInlinePayment] class.
abstract class RemitaPayment {
  /// When called will open a remita modal view to accept payment
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
