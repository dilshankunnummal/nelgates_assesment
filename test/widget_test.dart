import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/constants/app_constants.dart';

void main() {
  test('AppConstants smoke test', () {
    expect(AppConstants.appName, 'Booking.com by Dilshan');
    expect(AppConstants.hrEmail, 'hr@hotel.com');
    expect(AppConstants.employeeEmail, 'employee@hotel.com');
  });
}
