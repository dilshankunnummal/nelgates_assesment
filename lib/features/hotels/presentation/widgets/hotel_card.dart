import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/app_image.dart';
import '../../../../core/widgets/common/price_widget.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_icon_button.dart';
import '../../../../core/widgets/glass/glass_surface.dart';
import '../../../../core/theme/glass_tokens.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../../domain/entities/hotel.dart';

/// True Liquid Glass Hotel Card with zero gradients.
class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final VoidCallback? onTap;
  final double? width;

  const HotelCard({
    super.key,
    required this.hotel,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppGlassCard(
      width: width,
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.brXl,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image with Wishlist Button & Rating Tag
          Stack(
            children: [
              AppImage(
                imageUrl: hotel.mainImage,
                height: 180,
                width: double.infinity,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
              ),
              // Wishlist Heart Glass Button
              Positioned(
                top: 12,
                right: 12,
                child: BlocBuilder<WishlistCubit, WishlistState>(
                  builder: (context, state) {
                    final isWishlisted = state.isWishlisted(hotel.id);
                    return GlassIconButton(
                      size: 38,
                      icon: Icon(
                        isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isWishlisted ? AppColors.error : Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        context.read<WishlistCubit>().toggleWishlist(hotel);
                      },
                    );
                  },
                ),
              ),
              // Floating Liquid Glass Rating badge on image
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
                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        hotel.rating.toStringAsFixed(1),
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location row & Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${hotel.city}, ${hotel.state}',
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '★' * hotel.starRating,
                      style: const TextStyle(
                        color: Color(0xFFF59E0B),
                        fontSize: 12,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapH4,

                // Hotel Name
                Text(
                  hotel.name,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.gapH8,

                // Pricing and Reviews
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: PriceWidget(
                        price: hotel.pricePerNight,
                        originalPrice: hotel.originalPrice,
                      ),
                    ),
                    Text(
                      '${hotel.reviewCount} reviews',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        fontSize: 11,
                      ),
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
