class PayUBuyer {
  final String email;
  final String phone;
  final String firstName;
  final String lastName;
  final String language;

  PayUBuyer({
    required this.email,
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.language,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'firstName': firstName,
        'lastName': lastName,
        'language': language,
      };
}
