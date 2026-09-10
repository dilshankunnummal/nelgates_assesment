import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

/// Level 2 depth glass container for page sections, hero panels, and background groupings.
class AppGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double? opacity;
  final Color? borderColor;

  const AppGlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.opacity,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      depthLevel: GlassDepthLevel.largeContainer,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius ?? AppRadius.brXl,
      opacity: opacity,
      borderColor: borderColor,
      hasHighlight: true,
      child: child,
    );
  }
}
