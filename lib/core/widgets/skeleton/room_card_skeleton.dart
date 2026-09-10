import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../glass/app_glass_card.dart';
import 'shimmer_container.dart';

/// Skeleton placeholder for [RoomCard] on the hotel details and room selection screens.
class RoomCardSkeleton extends StatelessWidget {
  const RoomCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: AppGlassCard(
        padding: const EdgeInsets.all(14),
        borderRadius: AppRadius.brLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: AppRadius.brMd,
                  child: const ShimmerContainer(
                    width: 90,
                    height: 80,
                  ),
                ),
                AppSpacing.gapW14,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        width: 150,
                        height: 16,
                        borderRadius: AppRadius.brSm,
                      ),
                      AppSpacing.gapH8,
                      ShimmerContainer(
                        width: 100,
                        height: 12,
                        borderRadius: AppRadius.brSm,
                      ),
                      AppSpacing.gapH8,
                      Row(
                        children: [
                          ShimmerContainer(
                            width: 60,
                            height: 14,
                            borderRadius: AppRadius.brSm,
                          ),
                          AppSpacing.gapW10,
                          ShimmerContainer(
                            width: 60,
                            height: 14,
                            borderRadius: AppRadius.brSm,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapH14,
            const Divider(height: 1),
            AppSpacing.gapH10,
            // Price & selection action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerContainer(
                  width: 100,
                  height: 20,
                  borderRadius: AppRadius.brSm,
                ),
                ShimmerContainer(
                  width: 85,
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
