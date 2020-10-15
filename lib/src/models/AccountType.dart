class AccountType {
  int id;
  String name;
  AccountType({this.id, this.name});

  factory AccountType.fromJson(Map<String, dynamic> json) => AccountType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
