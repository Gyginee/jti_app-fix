class User {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? active;

  User({this.id, this.firstName, this.lastName, this.username, this.active});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> User = new Map<String, dynamic>();
    User['id'] = this.id;
    User['firstName'] = this.firstName;
    User['lastName'] = this.lastName;
    User['username'] = this.username;
    User['active'] = this.active;
    return User;
  }
}