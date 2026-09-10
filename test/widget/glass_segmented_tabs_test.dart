import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/widgets/glass/glass_segmented_tabs.dart';

void main() {
  group('GlassSegmentedTabs Widget Tests', () {
    testWidgets('renders all tabs, icons and count badges', (tester) async {
      final controller = TabController(length: 3, vsync: const TestVSync());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassSegmentedTabs(
              controller: controller,
              tabs: const [
                GlassTabItem(label: 'Upcoming', icon: Icons.flight_takeoff_rounded, count: 2),
                GlassTabItem(label: 'Completed', icon: Icons.task_alt_rounded),
                GlassTabItem(label: 'Cancelled', icon: Icons.cancel_outlined, count: 1),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.byIcon(Icons.flight_takeoff_rounded), findsOneWidget);
    });

    testWidgets('tap animates tab selection', (tester) async {
      final controller = TabController(length: 3, vsync: const TestVSync());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GlassSegmentedTabs(
              controller: controller,
              tabs: const [
                GlassTabItem(label: 'Upcoming'),
                GlassTabItem(label: 'Completed'),
                GlassTabItem(label: 'Cancelled'),
              ],
            ),
          ),
        ),
      );

      expect(controller.index, equals(0));

      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();

      expect(controller.index, equals(1));
    });
  });
}
