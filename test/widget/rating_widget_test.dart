import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/widgets/common/rating_widget.dart';

void main() {
  group('RatingWidget Tests', () {
    testWidgets('renders numeric rating and review count', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingWidget(
              rating: 4.8,
              reviewCount: 320,
            ),
          ),
        ),
      );

      expect(find.text('4.8'), findsOneWidget);
      expect(find.text('(320 reviews)'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
    });

    testWidgets('renders compact version properly without review text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingWidget(
              rating: 4.9,
              isCompact: true,
            ),
          ),
        ),
      );

      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('(320 reviews)'), findsNothing);
    });
  });
}
