import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/glass_tokens.dart';
import '../glass/glass_surface.dart';
import 'shimmer_container.dart';

class DestinationCardSkeleton extends StatelessWidget {
  const DestinationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),

        boxShadow: GlassTokens.elevation(GlassDepthLevel.card),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [

            const ShimmerContainer(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.zero,
            ),

            Positioned(
              top: 12,
              left: 12,
              child: GlassSurface(
                depthLevel: GlassDepthLevel.floating,
                borderRadius: AppRadius.brFull,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShimmerContainer(
                      width: 10,
                      height: 10,
                      borderRadius: AppRadius.brFull,
                    ),
                    const SizedBox(width: 5),
                    ShimmerContainer(
                      width: 52,
                      height: 10,
                      borderRadius: AppRadius.brSm,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GlassSurface(
                depthLevel: GlassDepthLevel.floating,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
                blur: GlassTokens.blurDeep,
                padding: const EdgeInsets.fromLTRB(14, 12, 12, 14),
                hasHighlight: true,
                shadows: const [],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShimmerContainer(
                            width: 100,
                            height: 16,
                            borderRadius: AppRadius.brSm,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              ShimmerContainer(
                                width: 10,
                                height: 10,
                                borderRadius: AppRadius.brSm,
                              ),
                              const SizedBox(width: 4),
                              ShimmerContainer(
                                width: 60,
                                height: 11,
                                borderRadius: AppRadius.brSm,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          ShimmerContainer(
                            width: 86,
                            height: 20,
                            borderRadius: AppRadius.brFull,
                          ),
                        ],
                      ),
                    ),

                    const ShimmerContainer(
                      width: 36,
                      height: 36,
                      shape: BoxShape.circle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
