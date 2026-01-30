class CreatePaymentData {
  final String? id;
  final String? order;
  final String? project;
  final String? amountPaid;
  final String? currency;
  final String? paymentMode;
  final String? transactionId;
  final String? paymentConfirmation;
  final bool? fullyPaid;
  final String? status;

  CreatePaymentData({
    this.id,
    this.order,
    this.project,
    this.amountPaid,
    this.currency,
    this.paymentMode,
    this.transactionId,
    this.paymentConfirmation,
    this.fullyPaid,
    this.status,
  });

  factory CreatePaymentData.fromJson(Map<String, dynamic> json) {
    return CreatePaymentData(
      id: json['id']?.toString(),
      order: json['order']?.toString(),
      project: json['project']?.toString(),
      amountPaid: json['amount_paid']?.toString(),
      currency: json['currency']?.toString(),
      paymentMode: json['payment_mode']?.toString(),
      transactionId: json['transaction_id']?.toString(),
      paymentConfirmation: json['payment_confirmation']?.toString(),
      fullyPaid: json['fully_paid'] as bool?,
      status: json['status']?.toString(),
    );
  }
}
