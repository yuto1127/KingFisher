class LoginModel {
  String email = '';
  String password = '';

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
} 