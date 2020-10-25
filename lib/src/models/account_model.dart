class AccountModel {
  String name;
  String value;

  AccountModel({this.name, this.value});

  String get getName => name;

  set setName(String name) => this.name = name;

  String get getValue => value;

  set setValue(String value) => this.value = value;

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        name: json["name"],
        value: json["value"],
      );
}
