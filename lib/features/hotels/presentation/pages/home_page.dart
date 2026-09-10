import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/glass_tokens.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/common/app_error_view.dart';
import '../../../../core/widgets/common/app_image.dart';
import '../../../../core/widgets/common/section_header.dart';
import '../../../../core/widgets/glass/app_glass_card.dart';
import '../../../../core/widgets/glass/glass_button.dart';
import '../../../../core/widgets/glass/glass_date_picker.dart';
import '../../../../core/widgets/glass/glass_dropdown.dart';
import '../../../../core/widgets/glass/glass_guest_selector.dart';
import '../../../../core/widgets/glass/glass_surface.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../../../../core/widgets/skeleton/home_content_skeleton.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubits/home_cubit.dart';
import '../cubits/hotel_search_cubit.dart';
import '../widgets/destination_card.dart';
import '../widgets/hotel_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 3));
  int _guests = 2;
  final int _rooms = 1;
  String _selectedDestination = 'All';

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  void _onSearch() {
    final searchCubit = context.read<HotelSearchCubit>();
    searchCubit.applyFilters(
      sortBy: 'popular',
    );
    searchCubit.updateDestination(_selectedDestination == 'All' ? null : _selectedDestination);
    context.push(RouteNames.hotels);
  }

  Future<void> _pickDates() async {
    final picked = await GlassDatePicker.show(
      context,
      initialCheckIn: _checkInDate,
      initialCheckOut: _checkOutDate,
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked.start;
        _checkOutDate = picked.end;
      });
    }
  }

  Future<void> _showGuestSelector() async {
    final guestCount = await GlassGuestSelector.show(
      context,
      initialAdults: _guests,
      initialChildren: 0,
    );
    if (guestCount != null) {
      setState(() {
        _guests = guestCount.adults + guestCount.children;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primary;

    return Scaffold(
      body: LiquidGlassBackground(
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const SafeArea(bottom: false, child: HomeContentSkeleton());
            }

            if (state is HomeError) {
              return AppErrorView(
                message: state.message,
                onRetry: () => context.read<HomeCubit>().loadHomeData(),
              );
            }

            final homeData = state as HomeLoaded;

            final dropdownItems = [
              const GlassDropdownItem(
                value: 'All',
                label: 'All Destinations in South India',
                icon: Icon(Icons.travel_explore_rounded, size: 18),
              ),
              ...homeData.destinations.map(
                (d) => GlassDropdownItem(
                  value: d.name,
                  label: '${d.name} (${d.hotelCount} properties)',
                  icon: const Icon(Icons.location_on_outlined, size: 18),
                ),
              ),
            ];

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<HomeCubit>().loadHomeData();
              },
              color: primary,
              child: CustomScrollView(
                slivers: [
                  // Top Greeting & App Header
                  SliverToBoxAdapter(
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, authState) {
                            String userName = 'Guest';
                            String? avatar;
                            if (authState is Authenticated) {
                              userName = authState.session.user.name;
                              avatar = authState.session.user.avatar;
                            }

                            return Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hello, $userName 👋',
                                        style: AppTypography.titleLarge.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      AppSpacing.gapH4,
                                      Text(
                                        'Find your tranquil escape',
                                        style: AppTypography.bodySmall.copyWith(
                                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                AppImage(
                                  imageUrl: avatar,
                                  width: 44,
                                  height: 44,
                                  borderRadius: AppRadius.brFull,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // True Liquid Glass Search Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: AppGlassCard(
                        padding: const EdgeInsets.all(18),
                        borderRadius: AppRadius.brXl,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Destination Glass Dropdown
                            Text(
                              'Destination',
                              style: AppTypography.labelSmall.copyWith(
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                            AppSpacing.gapH6,
                            GlassDropdown<String>(
                              value: _selectedDestination,
                              items: dropdownItems,
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedDestination = val);
                                }
                              },
                            ),
                            AppSpacing.gapH12,

                            // Dates and Guests in 2 Columns (GlassSurface items)
                            Row(
                              children: [
                                // Dates
                                Expanded(
                                  child: GlassSurface(
                                    depthLevel: GlassDepthLevel.control,
                                    padding: const EdgeInsets.all(12),
                                    borderRadius: AppRadius.brMd,
                                    onTap: _pickDates,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Dates',
                                          style: AppTypography.labelSmall.copyWith(
                                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                          ),
                                        ),
                                        AppSpacing.gapH4,
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today_rounded, size: 15),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                AppDateUtils.formatRange(_checkInDate, _checkOutDate),
                                                style: AppTypography.bodySmall.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                AppSpacing.gapW12,

                                // Guests & Rooms
                                Expanded(
                                  child: GlassSurface(
                                    depthLevel: GlassDepthLevel.control,
                                    padding: const EdgeInsets.all(12),
                                    borderRadius: AppRadius.brMd,
                                    onTap: _showGuestSelector,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Guests & Rooms',
                                          style: AppTypography.labelSmall.copyWith(
                                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                                          ),
                                        ),
                                        AppSpacing.gapH4,
                                        Row(
                                          children: [
                                            const Icon(Icons.group_outlined, size: 16),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                '$_guests Guests, $_rooms Room',
                                                style: AppTypography.bodySmall.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.gapH16,

                            // Search Glass Button
                            GlassButton(
                              onPressed: _onSearch,
                              label: 'Search Hotels',
                              icon: const Icon(Icons.search_rounded, size: 20, color: Colors.white),
                              isPrimary: true,
                              width: double.infinity,
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Popular Destinations Section
                  if (homeData.destinations.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                        child: SectionHeader(
                          title: 'Popular Destinations',
                          subtitle: 'Explore India’s most cherished retreats',
                          actionText: 'See All',
                          onAction: () {
                            context.read<HotelSearchCubit>().clearFilters();
                            context.push(RouteNames.hotels);
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        // 240 card + 4 top padding + 12 bottom padding + 16 shadow clearance
                        height: 272,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                          physics: const BouncingScrollPhysics(),
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          itemCount: homeData.destinations.length,
                          separatorBuilder: (context, _) => AppSpacing.gapW16,
                          itemBuilder: (context, index) {
                            final dest = homeData.destinations[index];
                            return DestinationCard(
                              destination: dest,
                              onTap: () {
                                context.read<HotelSearchCubit>().updateDestination(dest.name);
                                context.push(RouteNames.hotels);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],

                  // Recommended Stays Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: SectionHeader(
                        title: 'Recommended For You',
                        subtitle: 'Curated 5-star properties with exceptional ratings',
                        actionText: 'View All',
                        onAction: () {
                          context.read<HotelSearchCubit>().clearFilters();
                          context.push(RouteNames.hotels);
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final hotel = homeData.recommendedHotels[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: HotelCard(
                              hotel: hotel,
                              onTap: () {
                                context.push('${RouteNames.hotelDetails}/${hotel.id}', extra: hotel);
                              },
                            ),
                          );
                        },
                        childCount: homeData.recommendedHotels.length,
                      ),
                    ),
                  ),

                  // Bottom Padding for Floating Navigation Bar
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
