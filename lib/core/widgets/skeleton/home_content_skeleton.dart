import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/glass_tokens.dart';
import '../glass/app_glass_card.dart';
import '../glass/glass_surface.dart';
import 'destination_card_skeleton.dart';
import 'hotel_card_skeleton.dart';
import 'shimmer_container.dart';

/// Skeleton placeholder precisely matching the [HomePage] layout.
class HomeContentSkeleton extends StatelessWidget {
  const HomeContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Greeting & App Header Shimmer (matches HomePage line 135)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerContainer(
                      width: 165,
                      height: 24,
                      borderRadius: AppRadius.brSm,
                    ),
                    AppSpacing.gapH4,
                    ShimmerContainer(
                      width: 145,
                      height: 14,
                      borderRadius: AppRadius.brSm,
                    ),
                  ],
                ),
                const ShimmerContainer(
                  width: 44,
                  height: 44,
                  shape: BoxShape.circle,
                ),
              ],
            ),
          ),

          // Liquid Glass Search Card Shimmer (matches HomePage line 183)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: AppGlassCard(
              padding: const EdgeInsets.all(18),
              borderRadius: AppRadius.brXl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Destination Label Shimmer
                  ShimmerContainer(
                    width: 75,
                    height: 12,
                    borderRadius: AppRadius.brSm,
                  ),
                  AppSpacing.gapH6,

                  // Destination Glass Dropdown Shimmer Surface
                  GlassSurface(
                    depthLevel: GlassDepthLevel.control,
                    borderRadius: AppRadius.brMd,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        ShimmerContainer(
                          width: 16,
                          height: 16,
                          borderRadius: AppRadius.brSm,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ShimmerContainer(
                            height: 14,
                            borderRadius: AppRadius.brSm,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ShimmerContainer(
                          width: 16,
                          height: 16,
                          borderRadius: AppRadius.brSm,
                        ),
                      ],
                    ),
                  ),
                  AppSpacing.gapH12,

                  // Dates and Guests in 2 Columns Shimmer
                  Row(
                    children: [
                      // Dates Glass Surface
                      Expanded(
                        child: GlassSurface(
                          depthLevel: GlassDepthLevel.control,
                          padding: const EdgeInsets.all(12),
                          borderRadius: AppRadius.brMd,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerContainer(
                                width: 35,
                                height: 11,
                                borderRadius: AppRadius.brSm,
                              ),
                              AppSpacing.gapH4,
                              Row(
                                children: [
                                  ShimmerContainer(
                                    width: 14,
                                    height: 14,
                                    borderRadius: AppRadius.brSm,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: ShimmerContainer(
                                      height: 12,
                                      borderRadius: AppRadius.brSm,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppSpacing.gapW12,

                      // Guests & Rooms Glass Surface
                      Expanded(
                        child: GlassSurface(
                          depthLevel: GlassDepthLevel.control,
                          padding: const EdgeInsets.all(12),
                          borderRadius: AppRadius.brMd,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShimmerContainer(
                                width: 80,
                                height: 11,
                                borderRadius: AppRadius.brSm,
                              ),
                              AppSpacing.gapH4,
                              Row(
                                children: [
                                  ShimmerContainer(
                                    width: 14,
                                    height: 14,
                                    borderRadius: AppRadius.brSm,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: ShimmerContainer(
                                      height: 12,
                                      borderRadius: AppRadius.brSm,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.gapH16,

                  // Search Glass Button Shimmer
                  ShimmerContainer(
                    width: double.infinity,
                    height: 50,
                    borderRadius: AppRadius.brLg,
                  ),
                ],
              ),
            ),
          ),

          // Popular Destinations Section Header Shimmer (matches SectionHeader)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        width: 160,
                        height: 18,
                        borderRadius: AppRadius.brSm,
                      ),
                      const SizedBox(height: 2),
                      ShimmerContainer(
                        width: 220,
                        height: 12,
                        borderRadius: AppRadius.brSm,
                      ),
                    ],
                  ),
                ),
                ShimmerContainer(
                  width: 50,
                  height: 14,
                  borderRadius: AppRadius.brSm,
                ),
              ],
            ),
          ),

          // Destinations Horizontal Carousel Shimmer (height 272, matching home_page.dart)
          SizedBox(
            height: 272,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => AppSpacing.gapW16,
              itemBuilder: (context, index) => const DestinationCardSkeleton(),
            ),
          ),

          // Recommended Stays Header Shimmer (matches SectionHeader)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        width: 180,
                        height: 18,
                        borderRadius: AppRadius.brSm,
                      ),
                      const SizedBox(height: 2),
                      ShimmerContainer(
                        width: 260,
                        height: 12,
                        borderRadius: AppRadius.brSm,
                      ),
                    ],
                  ),
                ),
                ShimmerContainer(
                  width: 55,
                  height: 14,
                  borderRadius: AppRadius.brSm,
                ),
              ],
            ),
          ),

          // Recommended Stays Hotel Cards List Shimmer (matches SliverPadding 20)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: HotelCardSkeleton(),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: HotelCardSkeleton(),
                ),
              ],
            ),
          ),

          // Bottom Spacing for Floating Navigation Bar
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
