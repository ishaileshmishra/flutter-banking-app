class UserAccountModel {
  var accountNumber;
  var accountHolderName;

  UserAccountModel({this.accountNumber, this.accountHolderName});

  factory UserAccountModel.fromJson(Map<String, dynamic> json) =>
      UserAccountModel(
        accountNumber: json["accountNumber"],
        accountHolderName: json["accountHolderName"],
      );

  @override
  String toString() {
    return '${this.accountNumber} (${this.accountHolderName})';
  }
}
