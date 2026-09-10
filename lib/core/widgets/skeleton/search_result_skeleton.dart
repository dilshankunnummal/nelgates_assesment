import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import 'hotel_card_skeleton.dart';
import 'shimmer_container.dart';

/// Skeleton placeholder for [HotelSearchPage] search results.
class SearchResultSkeleton extends StatelessWidget {
  const SearchResultSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(
                width: 130,
                height: 16,
                borderRadius: AppRadius.brSm,
              ),
              ShimmerContainer(
                width: 70,
                height: 28,
                borderRadius: AppRadius.brFull,
              ),
            ],
          ),
          AppSpacing.gapH14,

          // Hotel Card Skeletons
          const HotelCardSkeleton(),
          AppSpacing.gapH12,
          const HotelCardSkeleton(),
          AppSpacing.gapH12,
          const HotelCardSkeleton(),
        ],
      ),
    );
  }
}
