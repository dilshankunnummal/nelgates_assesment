import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/glass_tokens.dart';
import '../../../../core/widgets/common/app_image.dart';
import '../../../../core/widgets/glass/glass_icon_button.dart';
import '../../../../core/widgets/glass/glass_surface.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../../domain/entities/hotel.dart';

/// True Liquid Glass Hotel Image Gallery with zero gradients.
class HotelImageGallery extends StatefulWidget {
  final Hotel hotel;
  final double height;

  const HotelImageGallery({
    super.key,
    required this.hotel,
    this.height = 320,
  });

  @override
  State<HotelImageGallery> createState() => _HotelImageGalleryState();
}

class _HotelImageGalleryState extends State<HotelImageGallery> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.hotel.images.isNotEmpty ? widget.hotel.images : [widget.hotel.mainImage];

    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Swipable Images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return AppImage(
                imageUrl: images[index],
                height: widget.height,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),

          // Back button and Wishlist button (Floating Liquid Glass Controls)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GlassIconButton(
                    size: 42,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    onPressed: () => context.pop(),
                  ),

                  // Wishlist button
                  BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (context, state) {
                      final isWishlisted = state.isWishlisted(widget.hotel.id);
                      return GlassIconButton(
                        size: 42,
                        icon: Icon(
                          isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isWishlisted ? AppColors.error : Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          context.read<WishlistCubit>().toggleWishlist(widget.hotel);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Floating Glass Photo Counter badge
          if (images.length > 1)
            Positioned(
              bottom: 16,
              right: 16,
              child: GlassSurface(
                depthLevel: GlassDepthLevel.floating,
                borderRadius: AppRadius.brFull,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.photo_library_outlined, size: 13, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(
                      '${_currentPage + 1}/${images.length}',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Page indicator dots
          if (images.length > 1)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  final isSelected = index == _currentPage;
                  return AnimatedContainer(
                    duration: GlassTokens.durationFast,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isSelected ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                      borderRadius: AppRadius.brFull,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
