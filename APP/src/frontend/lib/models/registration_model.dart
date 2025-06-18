class RegistrationModel {
  String name = '';
  String email = '';
  String phoneNumber = '';
  String address = '';
  String password = '';  // パスワードフィールドを追加
  String? barcode;  // バーコードは自動生成または手動入力

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'password': password,  // パスワードをJSONに含める
      'barcode': barcode,
    };
  }
} 