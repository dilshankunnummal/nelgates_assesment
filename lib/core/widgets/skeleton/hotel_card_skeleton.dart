import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../glass/app_glass_card.dart';
import 'shimmer_container.dart';

/// Skeleton placeholder precisely matching the dimensions and layout of [HotelCard].
class HotelCardSkeleton extends StatelessWidget {
  final double? width;
  final double imageHeight;

  const HotelCardSkeleton({
    super.key,
    this.width,
    this.imageHeight = 175,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: AppGlassCard(
        padding: EdgeInsets.zero,
        borderRadius: AppRadius.brLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image shimmer with rounded top
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: ShimmerContainer(
                width: double.infinity,
                height: imageHeight,
              ),
            ),
            // Info Area
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title shimmer
                      const Expanded(
                        child: ShimmerContainer(
                          height: 18,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Rating pill shimmer
                      ShimmerContainer(
                        width: 48,
                        height: 22,
                        borderRadius: AppRadius.brFull,
                      ),
                    ],
                  ),
                  AppSpacing.gapH8,
                  // Location line shimmer
                  ShimmerContainer(
                    width: 140,
                    height: 14,
                    borderRadius: AppRadius.brSm,
                  ),
                  AppSpacing.gapH12,
                  // Divider
                  const Divider(height: 1),
                  AppSpacing.gapH10,
                  // Price and CTA row shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerContainer(
                            width: 60,
                            height: 10,
                            borderRadius: AppRadius.brSm,
                          ),
                          AppSpacing.gapH4,
                          ShimmerContainer(
                            width: 90,
                            height: 18,
                            borderRadius: AppRadius.brSm,
                          ),
                        ],
                      ),
                      ShimmerContainer(
                        width: 75,
                        height: 32,
                        borderRadius: AppRadius.brMd,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
