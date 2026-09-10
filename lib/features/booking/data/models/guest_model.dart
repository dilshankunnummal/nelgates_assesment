import '../../../../core/utils/safe_parser.dart';
import '../../domain/entities/guest.dart';

class GuestModel extends Guest {
  const GuestModel({
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.specialRequests,
  });

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    return GuestModel(
      firstName: SafeParser.toStr(json['first_name'] ?? json['firstName'], fallback: 'Alex'),
      lastName: SafeParser.toStr(json['last_name'] ?? json['lastName'], fallback: 'Mercer'),
      email: SafeParser.toStr(json['email'], fallback: 'employee@hotel.com'),
      phone: SafeParser.toStr(json['phone'], fallback: '+91 9876543210'),
      specialRequests: json['special_requests'] != null || json['specialRequests'] != null
          ? SafeParser.toStr(json['special_requests'] ?? json['specialRequests'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'special_requests': specialRequests,
    };
  }

  factory GuestModel.fromEntity(Guest entity) {
    return GuestModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      specialRequests: entity.specialRequests,
    );
  }
}
