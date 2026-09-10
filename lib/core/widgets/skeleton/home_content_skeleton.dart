import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../glass/app_glass_card.dart';
import 'hotel_card_skeleton.dart';
import 'shimmer_container.dart';

/// Skeleton placeholder precisely matching the [HomePage] layout.
class HomeContentSkeleton extends StatelessWidget {
  const HomeContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Destination Section Title
          ShimmerContainer(
            width: 160,
            height: 20,
            borderRadius: AppRadius.brSm,
          ),
          AppSpacing.gapH12,

          // Destinations Horizontal Carousel Shimmer
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (context, index) => AppSpacing.gapW12,
              itemBuilder: (context, index) => SizedBox(
                width: 140,
                child: AppGlassCard(
                  padding: EdgeInsets.zero,
                  borderRadius: AppRadius.brLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: ShimmerContainer(
                          width: double.infinity,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ShimmerContainer(
                          width: 80,
                          height: 12,
                          borderRadius: AppRadius.brSm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          AppSpacing.gapH24,

          // Search Filter Pill Row Shimmer
          Row(
            children: [
              ShimmerContainer(
                width: 80,
                height: 32,
                borderRadius: AppRadius.brFull,
              ),
              AppSpacing.gapW8,
              ShimmerContainer(
                width: 90,
                height: 32,
                borderRadius: AppRadius.brFull,
              ),
              AppSpacing.gapW8,
              ShimmerContainer(
                width: 110,
                height: 32,
                borderRadius: AppRadius.brFull,
              ),
            ],
          ),
          AppSpacing.gapH24,

          // Recommended Stays Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(
                width: 180,
                height: 20,
                borderRadius: AppRadius.brSm,
              ),
              ShimmerContainer(
                width: 60,
                height: 14,
                borderRadius: AppRadius.brSm,
              ),
            ],
          ),
          AppSpacing.gapH14,

          // Hotel Card Skeletons
          const HotelCardSkeleton(),
          AppSpacing.gapH12,
          const HotelCardSkeleton(),
        ],
      ),
    );
  }
}
