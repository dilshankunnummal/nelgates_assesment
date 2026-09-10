import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

/// True Liquid Glass Button.
///
/// Features:
/// - Strictly ZERO [LinearGradient] or [RadialGradient]
/// - Primary: Translucent solid primary tint with specular highlight and crisp border
/// - Secondary / Default: Translucent neutral glass surface
/// - Animated micro-scale & press feedback
class GlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final String label;
  final bool isLoading;
  final bool isPrimary;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color? customColor;
  final Color? textColor;
  final Color? borderColor;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isPrimary = false,
    this.width,
    this.height = 50,
    this.padding,
    this.customColor,
    this.textColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBase = isDark ? AppColors.primaryLight : AppColors.primary;

    // Zero gradients: Solid translucent tints
    final surfaceTint = customColor ??
        (isPrimary
            ? primaryBase.withValues(alpha: isDark ? 0.90 : 0.92)
            : (isDark
                ? const Color(0xFF151C2B).withValues(alpha: 0.70)
                : Colors.white.withValues(alpha: 0.40)));

    final effectiveTextColor = textColor ??
        (isPrimary
            ? (isDark ? AppColors.darkBackground : Colors.white)
            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary));

    final effectiveBorderColor = borderColor ??
        (isPrimary
            ? (isDark
                ? AppColors.primaryLight.withValues(alpha: 0.50)
                : Colors.white.withValues(alpha: 0.35))
            : GlassTokens.borderColor(context));

    return GlassSurface(
      depthLevel: isPrimary ? GlassDepthLevel.floating : GlassDepthLevel.control,
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      borderRadius: AppRadius.brFull,
      tintColor: surfaceTint,
      borderColor: effectiveBorderColor,
      borderWidth: 1.0,
      isDisabled: isLoading || onPressed == null,
      onTap: isLoading ? null : onPressed,
      child: Center(
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: AppTypography.labelLarge.copyWith(
                          color: effectiveTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
