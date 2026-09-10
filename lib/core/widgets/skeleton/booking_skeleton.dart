import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../glass/app_glass_card.dart';
import 'shimmer_container.dart';

/// Skeleton placeholder for individual booking cards on [BookingsPage].
class BookingSkeleton extends StatelessWidget {
  const BookingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: AppGlassCard(
        padding: const EdgeInsets.all(16),
        borderRadius: AppRadius.brLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status chip and booking id
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerContainer(
                  width: 110,
                  height: 14,
                  borderRadius: AppRadius.brSm,
                ),
                ShimmerContainer(
                  width: 75,
                  height: 22,
                  borderRadius: AppRadius.brFull,
                ),
              ],
            ),
            AppSpacing.gapH12,
            const Divider(height: 1),
            AppSpacing.gapH12,

            // Hotel info row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.brMd,
                  child: const ShimmerContainer(
                    width: 75,
                    height: 75,
                  ),
                ),
                AppSpacing.gapW14,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        width: 170,
                        height: 16,
                        borderRadius: AppRadius.brSm,
                      ),
                      AppSpacing.gapH8,
                      ShimmerContainer(
                        width: 120,
                        height: 12,
                        borderRadius: AppRadius.brSm,
                      ),
                      AppSpacing.gapH8,
                      ShimmerContainer(
                        width: 90,
                        height: 12,
                        borderRadius: AppRadius.brSm,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapH14,
            const Divider(height: 1),
            AppSpacing.gapH12,

            // Total amount & actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: 50,
                      height: 10,
                      borderRadius: AppRadius.brSm,
                    ),
                    AppSpacing.gapH4,
                    ShimmerContainer(
                      width: 90,
                      height: 16,
                      borderRadius: AppRadius.brSm,
                    ),
                  ],
                ),
                ShimmerContainer(
                  width: 95,
                  height: 32,
                  borderRadius: AppRadius.brMd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// List of booking skeletons
class BookingListSkeleton extends StatelessWidget {
  final int itemCount;

  const BookingListSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const BookingSkeleton(),
    );
  }
}
