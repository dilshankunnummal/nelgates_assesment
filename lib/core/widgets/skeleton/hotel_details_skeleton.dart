import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../glass/app_glass_card.dart';
import 'room_card_skeleton.dart';
import 'shimmer_container.dart';

/// Skeleton placeholder precisely matching [HotelDetailsPage].
class HotelDetailsSkeleton extends StatelessWidget {
  const HotelDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gallery Shimmer Hero
          const ShimmerContainer(
            width: double.infinity,
            height: 310,
            borderRadius: BorderRadius.zero,
          ),
          AppSpacing.gapH16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Star rating chips
                Row(
                  children: [
                    ShimmerContainer(
                      width: 80,
                      height: 24,
                      borderRadius: AppRadius.brFull,
                    ),
                    AppSpacing.gapW8,
                    ShimmerContainer(
                      width: 70,
                      height: 24,
                      borderRadius: AppRadius.brFull,
                    ),
                  ],
                ),
                AppSpacing.gapH12,
                // Hotel Name
                const ShimmerContainer(
                  width: double.infinity,
                  height: 26,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                AppSpacing.gapH8,
                // Location line
                ShimmerContainer(
                  width: 200,
                  height: 16,
                  borderRadius: AppRadius.brSm,
                ),
                AppSpacing.gapH20,

                // Amenities row
                AppGlassCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: AppRadius.brLg,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      4,
                      (index) => Column(
                        children: [
                          const ShimmerContainer(
                            width: 44,
                            height: 44,
                            shape: BoxShape.circle,
                          ),
                          AppSpacing.gapH8,
                          ShimmerContainer(
                            width: 50,
                            height: 10,
                            borderRadius: AppRadius.brSm,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AppSpacing.gapH20,

                // Description Title & Lines
                ShimmerContainer(
                  width: 120,
                  height: 20,
                  borderRadius: AppRadius.brSm,
                ),
                AppSpacing.gapH10,
                const ShimmerContainer(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                AppSpacing.gapH6,
                const ShimmerContainer(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                AppSpacing.gapH6,
                ShimmerContainer(
                  width: 240,
                  height: 14,
                  borderRadius: AppRadius.brSm,
                ),
                AppSpacing.gapH24,

                // Available Rooms Header
                ShimmerContainer(
                  width: 140,
                  height: 20,
                  borderRadius: AppRadius.brSm,
                ),
                AppSpacing.gapH12,
                const RoomCardSkeleton(),
                const RoomCardSkeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
