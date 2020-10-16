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

  Map<String, dynamic> toJson() => {
        'transactionId': transactionId,
        'accountNumber': accountNumber,
        'amount': amount,
        'accountHolderName': accountHolderName,
        'accountHolderPhoneNumber': accountHolderPhoneNumber,
      };
}

getRequestList() {
  List<DepositAmountRequestList> listRequestList =
      new List<DepositAmountRequestList>();

  listRequestList.add(DepositAmountRequestList(
      transactionId: 1000,
      accountNumber: 1001,
      accountHolderName: 'ravi.sen',
      accountHolderPhoneNumber: '983276736472'));

  listRequestList.add(DepositAmountRequestList(
      transactionId: 2000,
      accountNumber: 2002,
      accountHolderName: 'shailesh.mishra',
      accountHolderPhoneNumber: '82348367623'));

  listRequestList.add(DepositAmountRequestList(
      transactionId: 3000,
      accountNumber: 3003,
      accountHolderName: 'ramchandran',
      accountHolderPhoneNumber: '37483487823'));

  return listRequestList;
}
