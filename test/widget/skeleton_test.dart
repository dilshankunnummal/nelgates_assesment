import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nelegate_assessment/core/widgets/skeleton/skeleton.dart';

void main() {
  group('Skeleton & Shimmer Widgets', () {
    testWidgets('HotelCardSkeleton renders shimmer container elements', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HotelCardSkeleton(),
          ),
        ),
      );

      expect(find.byType(HotelCardSkeleton), findsOneWidget);
      expect(find.byType(ShimmerContainer), findsWidgets);
    });

    testWidgets('ImageSkeleton renders placeholder icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ImageSkeleton(width: 100, height: 100),
          ),
        ),
      );

      expect(find.byType(ImageSkeleton), findsOneWidget);
      expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    });

    testWidgets('HomeContentSkeleton renders destinations and hotel skeletons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HomeContentSkeleton(),
          ),
        ),
      );

      expect(find.byType(HomeContentSkeleton), findsOneWidget);
      expect(find.byType(HotelCardSkeleton), findsWidgets);
    });

    testWidgets('SearchResultSkeleton renders properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SearchResultSkeleton(),
          ),
        ),
      );

      expect(find.byType(SearchResultSkeleton), findsOneWidget);
    });
  });
}
