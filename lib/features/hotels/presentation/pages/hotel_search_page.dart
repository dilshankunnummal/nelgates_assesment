import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/app_empty_view.dart';
import '../../../../core/widgets/common/app_error_view.dart';
import '../../../../core/widgets/glass/glass_chip.dart';
import '../../../../core/widgets/glass/glass_search_bar.dart';
import '../../../../core/widgets/glass/glass_sort_sheet.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../../../../core/widgets/skeleton/search_result_skeleton.dart';
import '../cubits/hotel_search_cubit.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/hotel_card.dart';

class HotelSearchPage extends StatefulWidget {
  final String? initialDestination;

  const HotelSearchPage({super.key, this.initialDestination});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final searchCubit = context.read<HotelSearchCubit>();
    _searchController = TextEditingController(text: searchCubit.state.criteria.query);
    if (widget.initialDestination != null && widget.initialDestination!.isNotEmpty) {
      searchCubit.updateDestination(widget.initialDestination);
    } else {
      searchCubit.searchHotels();
    }
  }

  @override
  void didUpdateWidget(HotelSearchPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDestination != oldWidget.initialDestination) {
      context.read<HotelSearchCubit>().updateDestination(widget.initialDestination);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilters(BuildContext context, HotelFilterCriteria currentCriteria) {
    FilterBottomSheet.show(
      context,
      initialCriteria: currentCriteria,
      onApply: (updated) {
        context.read<HotelSearchCubit>().searchHotels(updated);
      },
      onReset: () {
        _searchController.clear();
        context.read<HotelSearchCubit>().clearFilters();
      },
    );
  }

  void _openSort(String currentSort) async {
    final selectedSort = await GlassSortSheet.show(
      context: context,
      currentSort: currentSort,
      options: const [
        GlassSortOption(key: 'popular', label: 'Most Popular', icon: Icons.trending_up_rounded),
        GlassSortOption(key: 'price_low_high', label: 'Price: Low to High', icon: Icons.arrow_upward_rounded),
        GlassSortOption(key: 'price_high_low', label: 'Price: High to Low', icon: Icons.arrow_downward_rounded),
        GlassSortOption(key: 'rating', label: 'Highest Rating (★)', icon: Icons.star_outline_rounded),
      ],
    );

    if (selectedSort != null && mounted) {
      context.read<HotelSearchCubit>().updateSort(selectedSort);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Hotels'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: LiquidGlassBackground(
        child: BlocBuilder<HotelSearchCubit, HotelSearchState>(
          builder: (context, state) {
            final criteria = state.criteria;

            return Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GlassSearchBar(
                    controller: _searchController,
                    hasFilterActive: criteria.hasActiveFilters,
                    onChanged: (val) {
                      context.read<HotelSearchCubit>().updateQuery(val);
                    },
                    onFilterTap: () => _openFilters(context, criteria),
                  ),
                ),

                if (criteria.hasActiveFilters)
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [

                        GlassChip(
                          icon: const Icon(Icons.close_rounded, size: 14),
                          label: 'Clear All',
                          onTap: () {
                            _searchController.clear();
                            context.read<HotelSearchCubit>().clearFilters();
                          },
                        ),
                        AppSpacing.gapW8,

                        if (criteria.destination != null && criteria.destination!.isNotEmpty) ...[
                          GlassChip(
                            label: '📍 ${criteria.destination}',
                            isSelected: true,
                            onTap: () => context.read<HotelSearchCubit>().updateDestination(null),
                          ),
                          AppSpacing.gapW8,
                        ],

                        if (criteria.minRating > 0) ...[
                          GlassChip(
                            label: '★ ${criteria.minRating}+',
                            isSelected: true,
                            onTap: () => context.read<HotelSearchCubit>().applyFilters(minRating: 0),
                          ),
                          AppSpacing.gapW8,
                        ],

                        if (criteria.sortBy != 'popular') ...[
                          GlassChip(
                            label: 'Sort: ${criteria.sortBy.replaceAll('_', ' ')}',
                            isSelected: true,
                            onTap: () => context.read<HotelSearchCubit>().updateSort('popular'),
                          ),
                          AppSpacing.gapW8,
                        ],

                        if (criteria.selectedAmenities.isNotEmpty)
                          ...criteria.selectedAmenities.map((amenity) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GlassChip(
                                label: amenity,
                                isSelected: true,
                                onTap: () {
                                  final updated = List<String>.from(criteria.selectedAmenities)
                                    ..remove(amenity);
                                  context.read<HotelSearchCubit>().applyFilters(selectedAmenities: updated);
                                },
                              ),
                            );
                          }),
                      ],
                    ),
                  ),

                if (state is HotelSearchSuccess)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${state.hotels.length} properties found',
                          style: AppTypography.labelMedium.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _openSort(criteria.sortBy),
                          child: Row(
                            children: [
                              Icon(
                                Icons.sort_rounded,
                                size: 16,
                                color: isDark ? AppColors.primaryLight : AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Sort',
                                style: AppTypography.labelSmall.copyWith(
                                  color: isDark ? AppColors.primaryLight : AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: _buildContent(context, state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HotelSearchState state) {
    if (state is HotelSearchLoading) {
      return const SearchResultSkeleton();
    }

    if (state is HotelSearchFailure) {
      return AppErrorView(
        message: state.message,
        onRetry: () => context.read<HotelSearchCubit>().searchHotels(),
      );
    }

    if (state is HotelSearchEmpty) {
      return AppEmptyView(
        title: 'No Hotels Found',
        message: 'Try adjusting your filters, destination, or price range to discover available stays.',
        actionText: 'Reset Filters',
        onAction: () {
          _searchController.clear();
          context.read<HotelSearchCubit>().clearFilters();
        },
      );
    }

    if (state is HotelSearchSuccess) {
      return RefreshIndicator(
        onRefresh: () async {
          await context.read<HotelSearchCubit>().searchHotels();
        },
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: state.hotels.length,
          separatorBuilder: (context, _) => AppSpacing.gapH16,
          itemBuilder: (context, index) {
            final hotel = state.hotels[index];
            return HotelCard(
              hotel: hotel,
              onTap: () {
                context.push('${RouteNames.hotelDetails}/${hotel.id}', extra: hotel);
              },
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
