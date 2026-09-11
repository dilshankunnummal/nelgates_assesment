import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

class GlassPopupMenuItem<T> {
  final T value;
  final String title;
  final Widget? leading;
  final bool isDestructive;

  const GlassPopupMenuItem({
    required this.value,
    required this.title,
    this.leading,
    this.isDestructive = false,
  });
}

class GlassPopupMenu<T> extends StatelessWidget {
  final Widget child;
  final List<GlassPopupMenuItem<T>> items;
  final ValueChanged<T> onSelected;

  const GlassPopupMenu({
    super.key,
    required this.child,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) async {
        final position = details.globalPosition;
        final selected = await showMenu<T>(
          context: context,
          position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.brMd),
          items: [
            PopupMenuItem<T>(
              enabled: false,
              padding: EdgeInsets.zero,
              child: GlassSurface(
                depthLevel: GlassDepthLevel.floating,
                borderRadius: AppRadius.brMd,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: items.map((item) {
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    final textColor = item.isDestructive
                        ? AppColors.error
                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

                    return InkWell(
                      onTap: () => Navigator.of(context).pop(item.value),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            if (item.leading != null) ...[
                              item.leading!,
                              const SizedBox(width: 10),
                            ],
                            Text(
                              item.title,
                              style: AppTypography.bodyMedium.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );

        if (selected != null) {
          onSelected(selected);
        }
      },
      child: child,
    );
  }
}
