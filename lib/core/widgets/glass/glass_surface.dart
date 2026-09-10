import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/glass_tokens.dart';

class GlassSurface extends StatefulWidget {
  final Widget child;
  final GlassDepthLevel depthLevel;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final double? blur;
  final double? opacity;
  final Color? tintColor;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;
  final bool hasHighlight;
  final bool isSelected;
  final bool isFocused;
  final bool isDisabled;

  const GlassSurface({
    super.key,
    required this.child,
    this.depthLevel = GlassDepthLevel.card,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.blur,
    this.opacity,
    this.tintColor,
    this.borderColor,
    this.borderWidth,
    this.onTap,
    this.shadows,
    this.hasHighlight = true,
    this.isSelected = false,
    this.isFocused = false,
    this.isDisabled = false,
  });

  @override
  State<GlassSurface> createState() => _GlassSurfaceState();
}

class _GlassSurfaceState extends State<GlassSurface> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveRadius = widget.borderRadius ?? BorderRadius.circular(GlassTokens.radiusBubble);
    final effectiveBlur = widget.blur ?? GlassTokens.blurForLevel(widget.depthLevel);
    final baseOpacity = widget.opacity ?? GlassTokens.surfaceOpacity(context, level: widget.depthLevel);

    // Dynamic state modifiers
    final adjustedOpacity = widget.isDisabled
        ? baseOpacity * 0.5
        : _isPressed
            ? (baseOpacity + 0.08).clamp(0.0, 1.0)
            : widget.isSelected
                ? (baseOpacity + 0.12).clamp(0.0, 1.0)
                : baseOpacity;

    final defaultTint = isDark
        ? GlassTokens.darkSurfaceColor(widget.depthLevel, adjustedOpacity: adjustedOpacity)
        : Colors.white.withValues(alpha: adjustedOpacity);
    final surfaceColor = widget.tintColor ?? defaultTint;

    // Hairline border
    final defaultBorderColor = widget.isFocused
        ? (isDark ? AppColors.primaryLight.withValues(alpha: 0.6) : const Color(0xFF0F172A).withValues(alpha: 0.5))
        : widget.borderColor ?? GlassTokens.borderColor(context);
    final effectiveBorderWidth = widget.borderWidth ??
        (widget.isFocused ? GlassTokens.borderWidthFocused : GlassTokens.borderWidthHairline);

    // Natural elevation shadow
    final effectiveShadows = widget.shadows ?? GlassTokens.elevation(widget.depthLevel, isDark: isDark);

    // Micro-scale on press
    final scale = _isPressed && widget.onTap != null ? 0.985 : 1.0;

    Widget surface = AnimatedScale(
      scale: scale,
      duration: GlassTokens.durationFast,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: widget.isDisabled ? 0.6 : 1.0,
        duration: GlassTokens.durationFast,
        child: ClipRRect(
          borderRadius: effectiveRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
            child: Stack(
              children: [
                // Layer 2: Translucent neutral background tint
                Container(
                  width: widget.width,
                  height: widget.height,
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: surfaceColor,
                    borderRadius: effectiveRadius,
                    border: Border.all(
                      color: defaultBorderColor,
                      width: effectiveBorderWidth,
                    ),
                  ),
                  child: widget.child,
                ),

                // Layer 4: Soft inner top specular highlight & bottom bounce reflection (3D bubble edge)
                if (widget.hasHighlight) ...[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 1.6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: GlassTokens.highlightColor(context),
                        borderRadius: BorderRadius.vertical(
                          top: effectiveRadius.topLeft,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.transparent : Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.vertical(
                          bottom: effectiveRadius.bottomLeft,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.onTap != null && !widget.isDisabled) {
      surface = GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: surface,
      );
    }

    if (widget.margin != null || effectiveShadows.isNotEmpty) {
      return Container(
        margin: widget.margin,
        decoration: BoxDecoration(
          borderRadius: effectiveRadius,
          boxShadow: effectiveShadows,
        ),
        child: surface,
      );
    }

    return surface;
  }
}
