import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/app_image.dart';
import '../../../../core/widgets/glass/glass_surface.dart';
import '../../../../core/theme/glass_tokens.dart';
import '../../domain/entities/destination.dart';

/// Premium iOS Liquid Glass Destination Card.
///
/// Features an integrated liquid frosted glass deck flush with the bottom edge,
/// emerald location badge, luxury property count chip, interactive circular action disc,
/// and smooth organic press scaling.
class DestinationCard extends StatefulWidget {
  final Destination destination;
  final VoidCallback? onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    this.onTap,
  });

  @override
  State<DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<DestinationCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: Container(
          width: 190,
          height: 240,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: GlassTokens.elevation(GlassDepthLevel.card),
            border: Border.all(
              color: GlassTokens.borderColor(context),
              width: 0.8,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Destination Hero Photography
                AppImage(
                  imageUrl: widget.destination.image,
                  fit: BoxFit.cover,
                ),

                // Subtle ambient gradient scrim to ensure flawless text legibility
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.45),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),

                // Top Floating Glass Pill Badge
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
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 11,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'EXPLORE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Integrated Liquid Frosted Glass Lower Deck (Flush with bottom curve, no nested box)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(14, 12, 12, 14),
                        decoration: BoxDecoration(
                          color: (isDark ? const Color(0xFF0F172A) : const Color(0xFF1E293B))
                              .withValues(alpha: isDark ? 0.65 : 0.45),
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withValues(alpha: isDark ? 0.14 : 0.28),
                              width: 0.8,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Destination Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.destination.name,
                                    style: AppTypography.titleMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.2,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_rounded,
                                        size: 12,
                                        color: AppColors.primaryLight,
                                      ),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          widget.destination.state,
                                          style: TextStyle(
                                            color: Colors.white.withValues(alpha: 0.85),
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

                                  // Property Count Glass Chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.45),
                                      borderRadius: AppRadius.brFull,
                                      border: Border.all(
                                        color: AppColors.primaryLight.withValues(alpha: 0.45),
                                        width: 0.6,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.hotel_rounded,
                                          size: 11,
                                          color: AppColors.primaryLight,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${widget.destination.hotelCount} Properties',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Circular Liquid Glass Arrow Disc
                            Container(
                              width: 36,
                              height: 36,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.12)
                                    : Colors.white.withValues(alpha: 0.22),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 0.8,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
