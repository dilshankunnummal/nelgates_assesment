import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/glass_tokens.dart';
import '../glass/app_glass_card.dart';
import '../glass/glass_surface.dart';
import 'shimmer_container.dart';

class HotelCardSkeleton extends StatelessWidget {
  final double? width;
  final double imageHeight;

  const HotelCardSkeleton({
    super.key,
    this.width,
    this.imageHeight = 180,
  });

  @override
  Widget build(BuildContext context) {
    return AppGlassCard(
      width: width,
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.brXl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [

          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                child: ShimmerContainer(
                  width: double.infinity,
                  height: imageHeight,
                ),
              ),

              const Positioned(
                top: 12,
                right: 12,
                child: ShimmerContainer(
                  width: 38,
                  height: 38,
                  shape: BoxShape.circle,
                ),
              ),

              Positioned(
                bottom: 12,
                left: 12,
                child: GlassSurface(
                  depthLevel: GlassDepthLevel.floating,
                  borderRadius: AppRadius.brFull,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShimmerContainer(
                        width: 12,
                        height: 12,
                        borderRadius: AppRadius.brFull,
                      ),
                      const SizedBox(width: 5),
                      ShimmerContainer(
                        width: 22,
                        height: 12,
                        borderRadius: AppRadius.brSm,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ShimmerContainer(
                          width: 12,
                          height: 12,
                          borderRadius: AppRadius.brSm,
                        ),
                        const SizedBox(width: 4),
                        ShimmerContainer(
                          width: 110,
                          height: 12,
                          borderRadius: AppRadius.brSm,
                        ),
                      ],
                    ),
                    ShimmerContainer(
                      width: 55,
                      height: 12,
                      borderRadius: AppRadius.brSm,
                    ),
                  ],
                ),
                AppSpacing.gapH4,

                ShimmerContainer(
                  width: 200,
                  height: 18,
                  borderRadius: AppRadius.brSm,
                ),
                AppSpacing.gapH8,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerContainer(
                          width: 85,
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
                      width: 65,
                      height: 12,
                      borderRadius: AppRadius.brSm,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
