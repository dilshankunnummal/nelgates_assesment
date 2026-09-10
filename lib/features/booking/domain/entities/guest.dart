import 'package:equatable/equatable.dart';

class Guest extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? specialRequests;

  const Guest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.specialRequests,
  });

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [firstName, lastName, email, phone, specialRequests];
}
