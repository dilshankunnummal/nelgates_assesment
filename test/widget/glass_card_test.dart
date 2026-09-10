import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/widgets/glass/app_glass_card.dart';

void main() {
  group('AppGlassCard Widget Tests', () {
    testWidgets('renders child content properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppGlassCard(
              child: Text('Liquid Glass Stay'),
            ),
          ),
        ),
      );

      expect(find.text('Liquid Glass Stay'), findsOneWidget);
    });

    testWidgets('handles tap events when onTap is provided', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppGlassCard(
              onTap: () => tapped = true,
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
