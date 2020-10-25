class KYCModel {
  int accountNumber;
  String accountHolderName;
  String accountMode;
  String amount;
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

  factory KYCModel.fromJson(dynamic json) {
    return KYCModel(
      accountNumber: json['accountNumber'] as int,
      accountHolderName: json['accountHolderName'] as String,
      accountMode: json['accountMode'] as String,
      amount: json['amount'] as String,
      accountHolderPhoneNumber: json['accountHolderPhoneNumber'] as String,
      identityCardNumber: json['identityCardNumber'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      pincode: json['pincode'] as String,
    );
  }
}
