class RegistrationModel {
  String name = '';
  String gender = '';
  DateTime? barthDay;
  String phoneNumber = '';
  String postalCode = '';
  String prefecture = '';
  String city = '';
  String addressLine1 = '';
  String addressLine2 = '';
  String email = '';
  String password = '';

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'postal_code': postalCode,
      'prefecture': prefecture,
      'city': city,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'password': password,
      'gender': gender,
      'barth_day': barthDay,
    };
  }
} 