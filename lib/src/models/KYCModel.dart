class KYCModel {
  int accountNumber;
  String accountHolderName;
  String accountMode;
  double amount;
  String accountHolderPhoneNumber;
  String identityCardNumber;
  String address;
  String city;
  String pincode;

  KYCModel(
      {this.accountNumber,
      this.accountHolderName,
      this.accountMode,
      this.amount,
      this.accountHolderPhoneNumber,
      this.identityCardNumber,
      this.address,
      this.city,
      this.pincode});

  factory KYCModel.fromJson(Map<String, dynamic> json) => KYCModel(
      accountNumber: json['accountNumber'],
      accountHolderName: json['accountHolderName'],
      accountMode: json['accountMode'],
      amount: json['amount'],
      accountHolderPhoneNumber: json['accountHolderPhoneNumber'],
      identityCardNumber: json['identityCardNumber'],
      address: json['address'],
      city: json['city'],
      pincode: json['pincode']);

  @override
  String toString() {
    return '${this.accountNumber}';
  }
}
