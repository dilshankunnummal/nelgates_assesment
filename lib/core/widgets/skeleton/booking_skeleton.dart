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
    return AppGlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: AppRadius.brXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Booking ID and Status Badge Shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerContainer(
                width: 100,
                height: 14,
                borderRadius: AppRadius.brSm,
              ),
              ShimmerContainer(
                width: 75,
                height: 24,
                borderRadius: AppRadius.brFull,
              ),
            ],
          ),
          const Divider(height: 20),

          // Hotel & Room Info Row Shimmer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppRadius.brMd,
                child: const ShimmerContainer(
                  width: 72,
                  height: 72,
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: 160,
                      height: 16,
                      borderRadius: AppRadius.brSm,
                    ),
                    AppSpacing.gapH4,
                    ShimmerContainer(
                      width: 120,
                      height: 12,
                      borderRadius: AppRadius.brSm,
                    ),
                    AppSpacing.gapH4,
                    Row(
                      children: [
                        ShimmerContainer(
                          width: 12,
                          height: 12,
                          borderRadius: AppRadius.brSm,
                        ),
                        const SizedBox(width: 4),
                        ShimmerContainer(
                          width: 130,
                          height: 11,
                          borderRadius: AppRadius.brSm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          // Footer: Total & Actions Shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerContainer(
                    width: 55,
                    height: 10,
                    borderRadius: AppRadius.brSm,
                  ),
                  AppSpacing.gapH4,
                  ShimmerContainer(
                    width: 95,
                    height: 18,
                    borderRadius: AppRadius.brSm,
                  ),
                ],
              ),
              ShimmerContainer(
                width: 95,
                height: 36,
                borderRadius: AppRadius.brLg,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// List of booking skeletons matching the list layout on [BookingsPage].
class BookingListSkeleton extends StatelessWidget {
  final int itemCount;

  const BookingListSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => AppSpacing.gapH12,
      itemBuilder: (context, index) => const BookingSkeleton(),
    );
  }
}
