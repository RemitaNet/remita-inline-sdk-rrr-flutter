class PaymentResponseData {
  late String? paymentReference;
  late String? processorId;
  late String? transactionId;
  late String? message;
  late int? amount;

  Map<String, dynamic> map = {};

  PaymentResponseData({
    this.message,
    this.transactionId,
    this.amount,
    this.paymentReference,
    this.processorId,
  });

  factory PaymentResponseData.fromJson(Map<String, dynamic> json) {
    return PaymentResponseData(
        message: json['message'],
        transactionId: json['transactionId'],
        amount: json['amount'],
        paymentReference: json['paymentReference'],
        processorId: json['processId']);
  }

  dynamic toJson() {
    return {
      'paymentReference': paymentReference,
      'processorId': processorId,
      'transactionId': transactionId,
      'message': message,
      'amount': '$amount',
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
