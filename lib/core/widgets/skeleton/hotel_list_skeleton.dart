import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import 'hotel_card_skeleton.dart';

class HotelListSkeleton extends StatelessWidget {
  final int itemCount;
  final EdgeInsets padding;

  const HotelListSkeleton({
    super.key,
    this.itemCount = 4,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 90),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (context, index) => AppSpacing.gapH16,
      itemBuilder: (context, index) => const HotelCardSkeleton(),
    );
  }
}
