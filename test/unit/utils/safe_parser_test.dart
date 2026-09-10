import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/utils/safe_parser.dart';

void main() {
  group('SafeParser', () {
    test('toInt parses int, double, numeric string, null safely', () {
      expect(SafeParser.toInt(123), 123);
      expect(SafeParser.toInt(123.7), 123);
      expect(SafeParser.toInt('456'), 456);
      expect(SafeParser.toInt('456.89'), 456);
      expect(SafeParser.toInt('1,234'), 1234);
      expect(SafeParser.toInt(null, fallback: 10), 10);
      expect(SafeParser.toInt('invalid', fallback: 5), 5);
    });

    test('toDouble parses double, int, numeric string, null safely', () {
      expect(SafeParser.toDouble(12.5), 12.5);
      expect(SafeParser.toDouble(100), 100.0);
      expect(SafeParser.toDouble('250.75'), 250.75);
      expect(SafeParser.toDouble('1,500.50'), 1500.50);
      expect(SafeParser.toDouble(null, fallback: 0.0), 0.0);
      expect(SafeParser.toDouble('abc', fallback: 9.9), 9.9);
    });

    test('toStr parses String, num, null safely', () {
      expect(SafeParser.toStr('hello'), 'hello');
      expect(SafeParser.toStr(42), '42');
      expect(SafeParser.toStr(null, fallback: 'default'), 'default');
    });

    test('toBool parses bool, string, num safely', () {
      expect(SafeParser.toBool(true), isTrue);
      expect(SafeParser.toBool('true'), isTrue);
      expect(SafeParser.toBool('yes'), isTrue);
      expect(SafeParser.toBool(1), isTrue);
      expect(SafeParser.toBool(false), isFalse);
      expect(SafeParser.toBool('false'), isFalse);
      expect(SafeParser.toBool(0), isFalse);
      expect(SafeParser.toBool(null, fallback: false), isFalse);
    });

    test('toImageUrl extracts from String, Map with large/url/image_url safely', () {
      expect(SafeParser.toImageUrl('https://hotel.com/pic.jpg'), 'https://hotel.com/pic.jpg');
      expect(SafeParser.toImageUrl({'large': 'https://hotel.com/large.jpg'}), 'https://hotel.com/large.jpg');
      expect(SafeParser.toImageUrl({'url': 'https://hotel.com/url.jpg'}), 'https://hotel.com/url.jpg');
      expect(SafeParser.toImageUrl({'image_url': 'https://hotel.com/image.jpg'}), 'https://hotel.com/image.jpg');
      expect(SafeParser.toImageUrl(null, fallback: 'fallback.jpg'), 'fallback.jpg');
    });

    test('toImageList parses List of strings and maps into valid URLs', () {
      final list = SafeParser.toImageList([
        'https://hotel.com/1.jpg',
        {'large': 'https://hotel.com/2.jpg'},
      ]);
      expect(list.length, 2);
      expect(list[0], 'https://hotel.com/1.jpg');
      expect(list[1], 'https://hotel.com/2.jpg');
    });
  });
}
