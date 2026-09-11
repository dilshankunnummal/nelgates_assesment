import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

Future<T?> showGlassBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isScrollControlled = true,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    elevation: 0,
    builder: (context) {
      return Stack(
        children: [

          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          GlassBottomSheet(child: child),
        ],
      );
    },
  );
}

class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final bool showDragHandle;
  final EdgeInsetsGeometry padding;

  const GlassBottomSheet({
    super.key,
    required this.child,
    this.showDragHandle = true,
    this.padding = const EdgeInsets.fromLTRB(20, 12, 20, 24),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final handleColor = isDark
        ? const Color(0xFF283652).withValues(alpha: 0.80)
        : Colors.black.withValues(alpha: 0.20);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: GlassSurface(
          depthLevel: GlassDepthLevel.floating,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.xxl)),
          padding: padding,
          hasHighlight: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showDragHandle) ...[
                Center(
                  child: Container(
                    width: 38,
                    height: 4.5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: handleColor,
                      borderRadius: BorderRadius.circular(GlassTokens.radiusPill),
                    ),
                  ),
                ),
              ],
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
