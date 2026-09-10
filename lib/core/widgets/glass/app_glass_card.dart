import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

/// True Liquid Glass Card.
///
/// Replaces old gradient-filled cards with pure translucent optical glass:
/// - Real [BackdropFilter] blur
/// - Zero [LinearGradient] or [RadialGradient]
/// - Hairline translucent border
/// - Specular top highlight
/// - Soft ambient drop shadow
class AppGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double? blur;
  final double? opacity;
  final Color? customColor;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;
  final bool hasSheen;
  final bool isSelected;

  const AppGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.blur,
    this.opacity,
    this.customColor,
    this.borderColor,
    this.borderWidth,
    this.onTap,
    this.shadows,
    this.hasSheen = true,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      depthLevel: GlassDepthLevel.card,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius ?? AppRadius.brLg,
      blur: blur,
      opacity: opacity,
      tintColor: customColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      onTap: onTap,
      shadows: shadows,
      hasHighlight: hasSheen,
      isSelected: isSelected,
      child: child,
    );
  }
}
