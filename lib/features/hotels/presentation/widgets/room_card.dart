import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/app_image.dart';
import '../../../../core/widgets/common/price_widget.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_button.dart';
import '../../../../core/widgets/glass/glass_chip.dart';
import '../../domain/entities/room.dart';

/// True Liquid Glass Room Card with zero gradients.
class RoomCard extends StatelessWidget {
  final Room room;
  final bool isSelected;
  final VoidCallback? onSelect;

  const RoomCard({
    super.key,
    required this.room,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return AppGlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: AppRadius.brXl,
      borderColor: isSelected ? primary : null,
      borderWidth: isSelected ? 1.8 : 1.0,
      onTap: onSelect,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room Thumbnail
              AppImage(
                imageUrl: room.mainImage,
                width: 90,
                height: 90,
                borderRadius: AppRadius.brMd,
              ),
              AppSpacing.gapW16,

              // Room Title & Quick Specs
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                    ),
                    AppSpacing.gapH4,
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _buildSpecItem(Icons.bed_outlined, room.bedType, isDark),
                        _buildSpecItem(Icons.people_outline_rounded, '${room.capacity} Guests', isDark),
                        _buildSpecItem(Icons.square_foot_rounded, '${room.sizeSqFt} sq ft', isDark),
                      ],
                    ),
                  ],
                ),
              ),

              // Selection Radio Indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: 2,
                  ),
                  color: isSelected ? primary : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: isDark ? AppColors.darkBackground : Colors.white,
                      )
                    : null,
              ),
            ],
          ),
          AppSpacing.gapH12,

          // Description
          Text(
            room.description,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
          AppSpacing.gapH12,

          // Amenities Tags using GlassChip
          if (room.amenities.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: room.amenities.take(4).map((amenity) {
                return GlassChip(
                  label: amenity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                );
              }).toList(),
            ),
            AppSpacing.gapH12,
          ],

          // Pricing & Select Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PriceWidget(price: room.pricePerNight),
              GlassButton(
                onPressed: onSelect,
                label: isSelected ? 'Selected' : 'Select Room',
                isPrimary: isSelected,
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 11,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }
}
