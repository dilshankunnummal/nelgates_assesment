import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/glass_tokens.dart';
import 'glass_surface.dart';

class GlassDropdownItem<T> {
  final T value;
  final String label;
  final Widget? icon;

  const GlassDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class GlassDropdown<T> extends StatefulWidget {
  final T? value;
  final List<GlassDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String hintText;
  final Widget? prefixIcon;

  const GlassDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText = 'Select option',
    this.prefixIcon,
  });

  @override
  State<GlassDropdown<T>> createState() => _GlassDropdownState<T>();
}

class _GlassDropdownState<T> extends State<GlassDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isOpen = false);
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final primary = isDark ? AppColors.primaryLight : AppColors.primary;

        return Stack(
          children: [

            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeDropdown,
                child: const SizedBox.expand(),
              ),
            ),

            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 6.0),
                child: Material(
                  color: Colors.transparent,
                  child: GlassSurface(
                    depthLevel: GlassDepthLevel.floating,
                    borderRadius: AppRadius.brMd,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 240),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final isSelected = item.value == widget.value;

                          return InkWell(
                            onTap: () {
                              widget.onChanged(item.value);
                              _closeDropdown();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? primary.withValues(alpha: isDark ? 0.25 : 0.15)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  if (item.icon != null) ...[
                                    item.icon!,
                                    const SizedBox(width: 8),
                                  ],
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: isSelected
                                            ? primary
                                            : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Icon(Icons.check_rounded, size: 18, color: primary),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedItem = widget.items.where((i) => i.value == widget.value).firstOrNull;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GlassSurface(
        depthLevel: GlassDepthLevel.control,
        borderRadius: AppRadius.brMd,
        isFocused: _isOpen,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        onTap: _toggleDropdown,
        child: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                selectedItem?.label ?? widget.hintText,
                style: AppTypography.bodyMedium.copyWith(
                  color: selectedItem != null
                      ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                      : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
            ),
            Icon(
              _isOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
