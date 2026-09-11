import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/utils/destination_utils.dart';

void main() {
  group('DestinationUtils Tests', () {
    test('getAliases expands Bangalore and Bengaluru interchangeably', () {
      final bangaloreAliases = DestinationUtils.getAliases('Bangalore');
      expect(bangaloreAliases, contains('bengaluru'));
      expect(bangaloreAliases, contains('bangalore'));

      final bengaluruAliases = DestinationUtils.getAliases('Bengaluru');
      expect(bengaluruAliases, contains('bengaluru'));
      expect(bengaluruAliases, contains('bangalore'));
    });

    test('getAliases expands Kochi and Cochin interchangeably', () {
      final kochiAliases = DestinationUtils.getAliases('Kochi');
      expect(kochiAliases, contains('cochin'));
      expect(kochiAliases, contains('kochi'));
    });

    test('getAliases expands Ooty and Udhagamandalam', () {
      final ootyAliases = DestinationUtils.getAliases('Ooty');
      expect(ootyAliases, contains('ooty'));
      expect(ootyAliases, contains('udhagamandalam'));
    });

    test('matchesDestination accurately matches city, destination, and state', () {
      // Bangalore / Bengaluru
      expect(
        DestinationUtils.matchesDestination(
          hotelDestination: 'Bengaluru',
          hotelCity: 'Bengaluru',
          hotelState: 'Karnataka',
          targetDestination: 'Bangalore',
        ),
        isTrue,
      );

      expect(
        DestinationUtils.matchesDestination(
          hotelDestination: 'Bengaluru',
          hotelCity: 'Bengaluru',
          hotelState: 'Karnataka',
          targetDestination: 'Bengaluru',
        ),
        isTrue,
      );

      // State matching (Karnataka)
      expect(
        DestinationUtils.matchesDestination(
          hotelDestination: 'Bengaluru',
          hotelCity: 'Bengaluru',
          hotelState: 'Karnataka',
          targetDestination: 'Karnataka',
        ),
        isTrue,
      );

      // Mismatch
      expect(
        DestinationUtils.matchesDestination(
          hotelDestination: 'Bengaluru',
          hotelCity: 'Bengaluru',
          hotelState: 'Karnataka',
          targetDestination: 'Kerala',
        ),
        isFalse,
      );

      // All matches all
      expect(
        DestinationUtils.matchesDestination(
          hotelDestination: 'Bengaluru',
          hotelCity: 'Bengaluru',
          hotelState: 'Karnataka',
          targetDestination: 'All',
        ),
        isTrue,
      );
    });
  });
}
