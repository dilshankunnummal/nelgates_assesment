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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results count and sort button header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerContainer(
                  width: 130,
                  height: 14,
                  borderRadius: AppRadius.brSm,
                ),
                ShimmerContainer(
                  width: 50,
                  height: 14,
                  borderRadius: AppRadius.brSm,
                ),
              ],
            ),
          ),

          // Hotel Card Skeletons List
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: const [
                HotelCardSkeleton(),
                AppSpacing.gapH16,
                HotelCardSkeleton(),
                AppSpacing.gapH16,
                HotelCardSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
