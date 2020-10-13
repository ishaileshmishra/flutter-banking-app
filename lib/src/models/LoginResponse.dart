class LoginResponse {
  String uid;
  String createdAt;
  String updatedAt;
  String email;
  String firstName;
  String lastName;
  String authToken;
  String profileType;

  LoginResponse(
      {this.uid,
      this.createdAt,
      this.updatedAt,
      this.email,
      this.firstName,
      this.lastName,
      this.authToken,
      this.profileType});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        authToken: json["authtoken"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        uid: json["uid"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        email: json["email"],
        profileType: json["profile_type"],
      );

  Map<String, dynamic> toJson() => {
        "authtoken": authToken,
        "first_name": firstName,
        'last_name': lastName,
        'uid': uid,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'email': email,
        'profile_type': profileType
      };
}
