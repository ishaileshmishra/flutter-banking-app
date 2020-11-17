class LoginResponse {
  int userId;
  String firstName;
  String lastName;
  String role;
  int isAccountCreated;
  int noOfDepositRequest;
  int availableBalance;
  List<String> bannerImages;

  LoginResponse(
      {this.userId,
      this.firstName,
      this.lastName,
      this.role,
      this.isAccountCreated,
      this.noOfDepositRequest,
      this.availableBalance,
      this.bannerImages});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        role: json["role"],
        isAccountCreated: json["isAccountCreated"],
        noOfDepositRequest: json["noOfDepositRequest"],
        availableBalance: json["availableBalance"],
        bannerImages: json['bannerImages'],
      );
}
