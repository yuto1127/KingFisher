class RegistrationModel {
  String name = '';
  String email = '';
  String phoneNumber = '';
  String address = '';
  String password = '';  // パスワードフィールドを追加
  String? barcode;  // バーコードは自動生成または手動入力

  // 追加プロパティ
  String? gender;
  DateTime? barthDay;
  String? postalCode;
  String? prefecture;
  String? city;
  String? addressLine1;
  String? addressLine2;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'password': password,  // パスワードをJSONに含める
      'barcode': barcode,
      'gender': gender,
      'barth_day': barthDay?.toIso8601String(),
      'postal_code': postalCode,
      'prefecture': prefecture,
      'city': city,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
    };
  }
} 