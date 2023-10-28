class Signup {
  String? fullname;
  String? email;
  String? phonenumber;
  String? password;

  Signup(
      {required this.fullname, required this.email, required this.phonenumber, required this.password, required String mobilenumber});

  Signup.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    email = json['email'];
    phonenumber = json['phonenumber'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['phonenumber'] = this.phonenumber;
    data['password'] = this.password;
    return data;
  }
}