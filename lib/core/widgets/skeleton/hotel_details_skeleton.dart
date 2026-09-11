import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../glass/app_glass_card.dart';
import '../glass/glass_surface.dart';
import '../../theme/glass_tokens.dart';
import 'room_card_skeleton.dart';
import 'shimmer_container.dart';

class HotelDetailsSkeleton extends StatelessWidget {
  const HotelDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Stack(
                children: [
                  const ShimmerContainer(
                    width: double.infinity,
                    height: 340,
                    borderRadius: BorderRadius.zero,
                  ),

                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          child: ShimmerContainer(
                            width: i == 0 ? 18 : 6,
                            height: 6,
                            borderRadius: AppRadius.brFull,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ShimmerContainer(
                              width: 52,
                              height: 24,
                              borderRadius: AppRadius.brFull,
                            ),
                            const SizedBox(width: 8),
                            ShimmerContainer(
                              width: 120,
                              height: 12,
                              borderRadius: AppRadius.brSm,
                            ),
                          ],
                        ),
                        ShimmerContainer(
                          width: 65,
                          height: 14,
                          borderRadius: AppRadius.brSm,
                        ),
                      ],
                    ),
                    AppSpacing.gapH8,

                    ShimmerContainer(
                      width: double.infinity,
                      height: 28,
                      borderRadius: AppRadius.brSm,
                    ),
                    AppSpacing.gapH8,

                    Row(
                      children: [
                        ShimmerContainer(
                          width: 14,
                          height: 14,
                          borderRadius: AppRadius.brSm,
                        ),
                        const SizedBox(width: 4),
                        ShimmerContainer(
                          width: 130,
                          height: 14,
                          borderRadius: AppRadius.brSm,
                        ),
                      ],
                    ),
                    AppSpacing.gapH4,

                    ShimmerContainer(
                      width: 240,
                      height: 12,
                      borderRadius: AppRadius.brSm,
                    ),
                    const Divider(height: 32),

                    ShimmerContainer(
                      width: 140,
                      height: 18,
                      borderRadius: AppRadius.brSm,
                    ),
                    AppSpacing.gapH8,
                    const ShimmerContainer(
                      width: double.infinity,
                      height: 13,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    AppSpacing.gapH6,
                    const ShimmerContainer(
                      width: double.infinity,
                      height: 13,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    AppSpacing.gapH6,
                    ShimmerContainer(
                      width: 200,
                      height: 13,
                      borderRadius: AppRadius.brSm,
                    ),
                    AppSpacing.gapH4,
                    ShimmerContainer(
                      width: 65,
                      height: 12,
                      borderRadius: AppRadius.brSm,
                    ),
                    const Divider(height: 32),

                    ShimmerContainer(
                      width: 170,
                      height: 18,
                      borderRadius: AppRadius.brSm,
                    ),
                    AppSpacing.gapH12,
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 3.2,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return GlassSurface(
                          depthLevel: GlassDepthLevel.control,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          borderRadius: AppRadius.brMd,
                          child: Row(
                            children: [
                              ShimmerContainer(
                                width: 18,
                                height: 18,
                                borderRadius: AppRadius.brSm,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ShimmerContainer(
                                  height: 12,
                                  borderRadius: AppRadius.brSm,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Divider(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerContainer(
                              width: 100,
                              height: 18,
                              borderRadius: AppRadius.brSm,
                            ),
                            AppSpacing.gapH4,
                            ShimmerContainer(
                              width: 140,
                              height: 12,
                              borderRadius: AppRadius.brSm,
                            ),
                          ],
                        ),
                      ],
                    ),
                    AppSpacing.gapH12,

                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: RoomCardSkeleton(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: RoomCardSkeleton(),
                    ),
                    const Divider(height: 24),

                    AppGlassCard(
                      padding: const EdgeInsets.all(16),
                      borderRadius: AppRadius.brLg,
                      child: Row(
                        children: [
                          const ShimmerContainer(
                            width: 24,
                            height: 24,
                            shape: BoxShape.circle,
                          ),
                          AppSpacing.gapW12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerContainer(
                                  width: 130,
                                  height: 14,
                                  borderRadius: AppRadius.brSm,
                                ),
                                AppSpacing.gapH4,
                                ShimmerContainer(
                                  width: 200,
                                  height: 12,
                                  borderRadius: AppRadius.brSm,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AppGlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShimmerContainer(
                        width: 110,
                        height: 11,
                        borderRadius: AppRadius.brSm,
                      ),
                      AppSpacing.gapH4,
                      ShimmerContainer(
                        width: 80,
                        height: 20,
                        borderRadius: AppRadius.brSm,
                      ),
                    ],
                  ),
                  ShimmerContainer(
                    width: 150,
                    height: 48,
                    borderRadius: AppRadius.brLg,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
