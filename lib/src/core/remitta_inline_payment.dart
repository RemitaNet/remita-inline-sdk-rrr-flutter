import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:remitta_flutter_inline/src/core/remitta_payment.dart';
import 'package:remitta_flutter_inline/src/data/payment_request.dart';
import 'package:remitta_flutter_inline/src/data/payment_response.dart';
import 'package:remitta_flutter_inline/src/data/payment_response_data.dart';
import 'package:remitta_flutter_inline/src/data/view_customize.dart';
import 'package:remitta_flutter_inline/src/utils/constants.dart';
import 'package:remitta_flutter_inline/src/utils/utils.dart';
import 'package:remitta_flutter_inline/src/view/remitta_view.dart';

/// [RemittaInlinePayment], a class that implements [RemittaPayment] contract.
///
/// Helpful for processing inline payment with Remitta Retrieval Reference Number (RRR).
///
/// This class present a set of
/// method that can be used to accept payment from any [StatefulWidget] with a [BuildContext].
///
/// Quick how to use:
/// * instantiate class with required member instance
/// * call initiatePayment()
///
/// For usage see example in example/example.dart
///
class RemittaInlinePayment implements RemittaPayment {
  final BuildContext buildContext;
  final PaymentRequest paymentRequest;
  final Customizer? customizer;

  RemittaInlinePayment({required this.buildContext, required this.paymentRequest, this.customizer});

  @override
  Future<PaymentResponse> verifyPayment() {
    throw UnimplementedError();
  }

  @override
  Future<PaymentResponse> cancelPayment() {
    return Future.value(_getCancelledResponse());
  }

  /// This method will create a [RemittaInLineView] and push view into widget tree.
  ///
  /// When view widget is popped, this method will wrap [ConsoleMessage] to [PaymentResponse]
  ///
  /// Should be called after [RemittaInlinePayment] is instantiated with required member instance.
  ///
  /// For usage see example/example.dart
  @override
  Future<PaymentResponse> initiatePayment() async {
    RemittaUtils.isValidPaymentRequest(paymentRequest);
    var remittaInLineView = RemittaInLineView(paymentRequest: paymentRequest);
    ConsoleMessage response = await Navigator.of(buildContext).push(MaterialPageRoute(builder: (_) => remittaInLineView));
    return _getResponseAfterViewPop(response);
  }

  PaymentResponse _getResponseAfterViewPop(ConsoleMessage consoleLog) {
    String message = consoleLog.message;
    if (message.contains('paymentReference') && message.contains("transactionId")) {
      Map<String, dynamic> decoded = jsonDecode(message);
      return _getPaymentResponse(PaymentResponseData.fromJson(decoded));
    } else {
      String? errorMessage = message.runtimeType == String ? message : null;
      return _getCancelledResponse(errorMessage);
    }
  }

  PaymentResponse _getCancelledResponse([String? message]) {
    return PaymentResponse(message: message ?? "Transaction Cancelled");
  }

  PaymentResponse _getPaymentResponse(PaymentResponseData data) {
    if (data.paymentReference != null && data.transactionId != null) {
      return _getSuccessfulResponse(data);
    }
    return _getFailedResponse(data);
  }

  PaymentResponse _getSuccessfulResponse(PaymentResponseData responseData) {
    return PaymentResponse(
      message: RemittaConstants.successMessage,
      code: RemittaConstants.successCode,
      data: responseData,
    );
  }

  PaymentResponse _getFailedResponse(PaymentResponseData data) {
    return PaymentResponse(
      message: RemittaConstants.failedMessage,
      code: RemittaConstants.failedCode,
      data: data,
    );
  }
}
