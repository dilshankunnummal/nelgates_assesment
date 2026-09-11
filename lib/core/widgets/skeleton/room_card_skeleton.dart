import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../glass/app_glass_card.dart';
import 'shimmer_container.dart';

class RoomCardSkeleton extends StatelessWidget {
  const RoomCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: AppRadius.brXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: AppRadius.brMd,
                child: const ShimmerContainer(
                  width: 90,
                  height: 90,
                ),
              ),
              AppSpacing.gapW16,

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: 140,
                      height: 16,
                      borderRadius: AppRadius.brSm,
                    ),
                    AppSpacing.gapH6,
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        ShimmerContainer(
                          width: 55,
                          height: 12,
                          borderRadius: AppRadius.brSm,
                        ),
                        ShimmerContainer(
                          width: 60,
                          height: 12,
                          borderRadius: AppRadius.brSm,
                        ),
                        ShimmerContainer(
                          width: 50,
                          height: 12,
                          borderRadius: AppRadius.brSm,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const ShimmerContainer(
                width: 24,
                height: 24,
                shape: BoxShape.circle,
              ),
            ],
          ),
          AppSpacing.gapH12,

          const ShimmerContainer(
            width: double.infinity,
            height: 12,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          AppSpacing.gapH4,
          ShimmerContainer(
            width: 220,
            height: 12,
            borderRadius: AppRadius.brSm,
          ),
          AppSpacing.gapH12,

          Row(
            children: [
              ShimmerContainer(
                width: 70,
                height: 22,
                borderRadius: AppRadius.brFull,
              ),
              AppSpacing.gapW8,
              ShimmerContainer(
                width: 65,
                height: 22,
                borderRadius: AppRadius.brFull,
              ),
              AppSpacing.gapW8,
              ShimmerContainer(
                width: 60,
                height: 22,
                borderRadius: AppRadius.brFull,
              ),
            ],
          ),
          AppSpacing.gapH12,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerContainer(
                    width: 80,
                    height: 18,
                    borderRadius: AppRadius.brSm,
                  ),
                  AppSpacing.gapH2,
                  ShimmerContainer(
                    width: 45,
                    height: 10,
                    borderRadius: AppRadius.brSm,
                  ),
                ],
              ),
              ShimmerContainer(
                width: 105,
                height: 38,
                borderRadius: AppRadius.brLg,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
