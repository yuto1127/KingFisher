class RegistrationModel {
  String name = '';
  String email = '';
  String phoneNumber = '';
  String gender = '';
  DateTime? barthDay;
  String postalCode = '';
  String prefecture = '';
  String city = '';
  String addressLine1 = '';
  String addressLine2 = '';
  String password = '';
  String? barcode;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'barth_day': barthDay?.toIso8601String(),
      'postal_code': postalCode,
      'prefecture': prefecture,
      'city': city,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'password': password,
      'barcode': barcode,
    };
  }
}
