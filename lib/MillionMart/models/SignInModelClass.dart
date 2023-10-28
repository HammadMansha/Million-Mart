class SignIn {
  String? mobilenumber;
  String? password;

  SignIn({required this.mobilenumber, required this.password, required String email});

  SignIn.fromJson(Map<String, dynamic> json) {
    mobilenumber = json['phonenumber'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobilenumber'] = this.mobilenumber;
    data['password'] = this.password;
    return data;
  }
}