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

    testWidgets('DestinationCardSkeleton renders properly matching destination card', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DestinationCardSkeleton(),
          ),
        ),
      );

      expect(find.byType(DestinationCardSkeleton), findsOneWidget);
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
      expect(find.byType(DestinationCardSkeleton), findsWidgets);
      expect(find.byType(HotelCardSkeleton), findsWidgets);
    });

    testWidgets('HotelDetailsSkeleton renders gallery, room cards and sticky bottom bar', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: HotelDetailsSkeleton(),
          ),
        ),
      );

      expect(find.byType(HotelDetailsSkeleton), findsOneWidget);
      expect(find.byType(RoomCardSkeleton), findsWidgets);
      expect(find.byType(ShimmerContainer), findsWidgets);
    });

    testWidgets('RoomCardSkeleton renders specs and glass buttons', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RoomCardSkeleton(),
          ),
        ),
      );

      expect(find.byType(RoomCardSkeleton), findsOneWidget);
      expect(find.byType(ShimmerContainer), findsWidgets);
    });

    testWidgets('BookingSkeleton and BookingListSkeleton render properly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BookingListSkeleton(itemCount: 2),
          ),
        ),
      );

      expect(find.byType(BookingListSkeleton), findsOneWidget);
      expect(find.byType(BookingSkeleton), findsNWidgets(2));
      expect(find.byType(ShimmerContainer), findsWidgets);
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
      expect(find.byType(HotelCardSkeleton), findsWidgets);
    });
  });
}
