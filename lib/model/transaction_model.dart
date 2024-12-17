class TransactionModel {
  final int? id;
  final String? type;
  final int? amount;
  final String? transactionDate;

  TransactionModel({this.id, this.type, this.amount, this.transactionDate});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: json['type'],
      amount: json['amount'],
      transactionDate: json['transaction_date'],
    );
  }
}
