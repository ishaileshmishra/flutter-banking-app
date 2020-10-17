class DepositAmountRequestList {
  int transactionId;
  int accountNumber;
  String amount;
  String accountHolderName;
  String accountHolderPhoneNumber;

  DepositAmountRequestList(
      {this.transactionId,
      this.accountNumber,
      this.amount,
      this.accountHolderName,
      this.accountHolderPhoneNumber});

  factory DepositAmountRequestList.fromJson(Map<String, dynamic> json) =>
      DepositAmountRequestList(
        transactionId: json["transactionId"],
        accountNumber: json["accountNumber"],
        amount: json["amount"],
        accountHolderName: json["accountHolderName"],
        accountHolderPhoneNumber: json["accountHolderPhoneNumber"],
      );

  @override
  String toString() {
    return '${this.transactionId} (${this.accountHolderName})';
  }
}
