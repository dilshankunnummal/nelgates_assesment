import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final VoidCallback? onTap;
  final bool showBorder;

  const UserAvatar({
    super.key,
    required this.imageUrl,
    this.name,
    this.size = 44,
    this.onTap,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    String initial = '';
    if (name != null && name!.trim().isNotEmpty) {
      final parts = name!.trim().split(' ');
      if (parts.length >= 2) {
        initial = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initial = parts[0][0].toUpperCase();
      }
    }

    Widget buildFallback() {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primary.withValues(alpha: isDark ? 0.35 : 0.20),
              primary.withValues(alpha: isDark ? 0.15 : 0.08),
            ],
          ),
          border: showBorder
              ? Border.all(
                  color: primary.withValues(alpha: isDark ? 0.40 : 0.25),
                  width: 1.5,
                )
              : null,
        ),
        child: Center(
          child: initial.isNotEmpty
              ? Text(
                  initial,
                  style: TextStyle(
                    color: primary,
                    fontSize: size * 0.38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                )
              : Icon(
                  Icons.person_rounded,
                  size: size * 0.55,
                  color: primary,
                ),
        ),
      );
    }

    final hasValidUrl = imageUrl != null &&
        imageUrl!.trim().isNotEmpty &&
        imageUrl!.startsWith('http');

    Widget avatarContent;

    if (!hasValidUrl) {
      avatarContent = buildFallback();
    } else {
      avatarContent = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: showBorder
              ? Border.all(
                  color: primary.withValues(alpha: isDark ? 0.40 : 0.25),
                  width: 1.5,
                )
              : null,
        ),
        child: ClipOval(
          child: Image.network(
            imageUrl!.trim(),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => buildFallback(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: size,
                height: size,
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                child: Center(
                  child: SizedBox(
                    width: size * 0.4,
                    height: size * 0.4,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarContent,
      );
    }

    return avatarContent;
  }
}
