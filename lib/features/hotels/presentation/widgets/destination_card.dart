import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/glass_tokens.dart';
import '../../../../core/widgets/common/app_image.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_surface.dart';
import '../../domain/entities/destination.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback? onTap;

  const DestinationCard({super.key, required this.destination, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return AppGlassCard(
      width: 190,
      height: 240,
      padding: EdgeInsets.zero,
      borderRadius: AppRadius.brXl,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          fit: StackFit.expand,
          children: [

                AppImage(imageUrl: destination.image, fit: BoxFit.cover),

                if (isDark)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,

                          end: Alignment.bottomCenter,

                          colors: [
                            Colors.black.withValues(alpha: 0.20),

                            Colors.transparent,

                            Colors.black.withValues(alpha: 0.35),
                          ],

                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  top: 12,

                  left: 12,

                  child: GlassSurface(
                    depthLevel: GlassDepthLevel.floating,

                    borderRadius: AppRadius.brFull,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,

                      vertical: 5,
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,

                          size: 11,

                          color: primary,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          'EXPLORE',

                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : AppColors.lightTextPrimary,

                            fontSize: 9.5,

                            fontWeight: FontWeight.w800,

                            letterSpacing: 0.8,
                          ),
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
                    depthLevel: GlassDepthLevel.card,

                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(26),
                    ),

                    tintColor: isDark
                        ? GlassTokens.darkSurfaceColor(GlassDepthLevel.floating, adjustedOpacity: 0.88)
                        : Colors.white.withValues(alpha: 0.92),

                    blur: GlassTokens.blurDeep,
                    padding: const EdgeInsets.fromLTRB(14, 12, 12, 14),
                    hasHighlight: true,
                    shadows: const [],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(
                                destination.name,

                                style: AppTypography.titleMedium.copyWith(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.lightTextPrimary,

                                  fontWeight: FontWeight.w800,

                                  letterSpacing: -0.2,
                                ),

                                maxLines: 1,

                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 2),

                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,

                                    size: 12,

                                    color: primary,
                                  ),

                                  const SizedBox(width: 3),

                                  Expanded(
                                    child: Text(
                                      destination.state,

                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.85,
                                              )
                                            : AppColors.lightTextSecondary,

                                        fontSize: 11,

                                        fontWeight: FontWeight.w500,
                                      ),

                                      maxLines: 1,

                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.primary.withValues(alpha: 0.35)
                                      : AppColors.primary.withValues(alpha: 0.12),
                                  borderRadius: AppRadius.brFull,
                                  border: Border.all(
                                    color: primary.withValues(alpha: isDark ? 0.45 : 0.30),
                                    width: 0.6,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.hotel_rounded,
                                      size: 11,
                                      color: primary,
                                    ),
                                    const SizedBox(width: 3),
                                    Flexible(
                                      child: Text(
                                        '${destination.hotelCount} properties',
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : AppColors.primary,
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 34,
                          height: 34,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.12)
                                : Colors.white.withValues(alpha: 0.90),

                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.35)
                                  : Colors.white,

                              width: 0.8,
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(
                                  alpha: isDark ? 0.25 : 0.18,
                                ),

                                blurRadius: 8,

                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),

                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_rounded,

                              size: 16,

                              color: isDark ? Colors.white : primary,
                            ),
                          ),
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
