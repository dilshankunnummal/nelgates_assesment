import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/glass_tokens.dart';
import '../../../../core/widgets/common/app_error_view.dart';
import '../../../../core/widgets/common/price_widget.dart';
import '../../../../core/widgets/common/rating_widget.dart';
import '../../../../core/widgets/common/section_header.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_button.dart';
import '../../../../core/widgets/glass/glass_surface.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../../../../core/widgets/skeleton/hotel_details_skeleton.dart';
import '../../../booking/presentation/cubits/booking_cubit.dart';
import '../../domain/entities/amenity.dart';
import '../../domain/entities/hotel.dart';
import '../cubits/hotel_details_cubit.dart';
import '../widgets/hotel_image_gallery.dart';
import '../widgets/room_card.dart';

class HotelDetailsPage extends StatefulWidget {
  final String hotelId;
  final Hotel? initialHotel;

  const HotelDetailsPage({
    super.key,
    required this.hotelId,
    this.initialHotel,
  });

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    context.read<HotelDetailsCubit>().loadHotel(widget.hotelId, widget.initialHotel);
  }

  void _onBookNow(Hotel hotel, dynamic selectedRoom) {
    context.read<BookingCubit>().initBooking(
          hotel: hotel,
          room: selectedRoom,
        );
    context.push(RouteNames.booking);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: LiquidGlassBackground(
        child: BlocBuilder<HotelDetailsCubit, HotelDetailsState>(
          builder: (context, state) {
            if (state is HotelDetailsLoading || state is HotelDetailsInitial) {
              return Scaffold(
                appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
                body: const HotelDetailsSkeleton(),
              );
            }

            if (state is HotelDetailsError) {
              return Scaffold(
                appBar: AppBar(),
                body: AppErrorView(
                  message: state.message,
                  onRetry: () => context.read<HotelDetailsCubit>().loadHotel(widget.hotelId),
                ),
              );
            }

            final hotel = (state as HotelDetailsLoaded).hotel;
            final selectedRoom = state.selectedRoom;

            return Stack(
              children: [
                // Scrollable content
                CustomScrollView(
                  slivers: [
                    // Hero Image Gallery
                    SliverToBoxAdapter(
                      child: HotelImageGallery(hotel: hotel, height: 340),
                    ),

                    // Hotel Info Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // State & Rating & Star rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    RatingWidget(rating: hotel.rating),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(${hotel.reviewCount} verified reviews)',
                                      style: AppTypography.bodySmall.copyWith(
                                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '★' * hotel.starRating,
                                  style: const TextStyle(
                                    color: Color(0xFFF59E0B),
                                    fontSize: 14,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.gapH8,

                            // Hotel Name
                            Text(
                              hotel.name,
                              style: AppTypography.displayMedium.copyWith(
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                              ),
                            ),
                            AppSpacing.gapH8,

                            // City & State
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                  color: AppColors.primaryLight,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${hotel.city}, ${hotel.state}',
                                  style: AppTypography.titleSmall.copyWith(
                                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.gapH4,

                            // Full Address
                            Text(
                              hotel.address,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                            const Divider(height: 32),

                            // Description
                            const SectionHeader(title: 'About the Property'),
                            AppSpacing.gapH8,
                            Text(
                              hotel.description,
                              style: AppTypography.bodyMedium.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                height: 1.5,
                              ),
                              maxLines: _isDescriptionExpanded ? null : 3,
                              overflow: _isDescriptionExpanded ? null : TextOverflow.ellipsis,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() => _isDescriptionExpanded = !_isDescriptionExpanded);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  _isDescriptionExpanded ? 'Read Less' : 'Read More',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(height: 32),

                            // Amenities Section
                            const SectionHeader(title: 'Amenities & Facilities'),
                            AppSpacing.gapH12,
                            _buildAmenitiesGrid(hotel.amenities, isDark),
                            const Divider(height: 32),

                            // Rooms Section
                            if (hotel.rooms.isNotEmpty) ...[
                              SectionHeader(
                                title: 'Select Room',
                                subtitle: '${hotel.rooms.length} room types available',
                              ),
                              AppSpacing.gapH12,
                              ...hotel.rooms.map((room) {
                                final isSelected = room.id == selectedRoom.id;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: RoomCard(
                                    room: room,
                                    isSelected: isSelected,
                                    onSelect: () {
                                      context.read<HotelDetailsCubit>().selectRoom(room);
                                    },
                                  ),
                                );
                              }),
                              const Divider(height: 24),
                            ],

                            // Cancellation Policy Card
                            AppGlassCard(
                              padding: const EdgeInsets.all(16),
                              borderRadius: AppRadius.brLg,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.verified_user_outlined,
                                    color: AppColors.success,
                                    size: 24,
                                  ),
                                  AppSpacing.gapW12,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Cancellation Policy',
                                          style: AppTypography.labelMedium.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                          ),
                                        ),
                                        Text(
                                          hotel.cancellationPolicy,
                                          style: AppTypography.bodySmall.copyWith(
                                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Sticky Bottom True Liquid Glass Bar
                Positioned(
                  bottom: 0,
                    left: 0,
                    right: 0,
                    child: AppGlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                      child: SafeArea(
                        top: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Selected: ${selectedRoom.name}',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  PriceWidget(price: selectedRoom.pricePerNight),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 150,
                              child: GlassButton(
                                onPressed: () => _onBookNow(hotel, selectedRoom),
                                label: 'Book Now',
                                isPrimary: true,
                                height: 48,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAmenitiesGrid(List<Amenity> amenities, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3.2,
      ),
      itemCount: amenities.length,
      itemBuilder: (context, index) {
        final item = amenities[index];
        return GlassSurface(
          depthLevel: GlassDepthLevel.control,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          borderRadius: AppRadius.brMd,
          child: Row(
            children: [
              Icon(_getAmenityIcon(item.icon), size: 18, color: AppColors.primaryLight),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.name,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getAmenityIcon(String icon) {
    switch (icon) {
      case 'wifi':
        return Icons.wifi_rounded;
      case 'pool':
        return Icons.pool_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'bar':
        return Icons.local_bar_rounded;
      case 'fitness':
        return Icons.fitness_center_rounded;
      case 'parking':
        return Icons.local_parking_rounded;
      default:
        return Icons.check_circle_outline_rounded;
    }
  }
}
