import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/common/app_empty_view.dart';
import '../../../../core/widgets/common/app_error_view.dart';
import '../../../../core/widgets/glass/liquid_glass_background.dart';
import '../../../../core/widgets/skeleton/hotel_list_skeleton.dart';
import '../../../hotels/presentation/widgets/hotel_card.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Hotels'),
        automaticallyImplyLeading: false,
      ),
      body: LiquidGlassBackground(
        child: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading && state.items.isEmpty) {
            return const HotelListSkeleton();
          }

          if (state is WishlistError && state.items.isEmpty) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<WishlistCubit>().loadWishlist(),
            );
          }

          if (state.items.isEmpty) {
            return AppEmptyView(
              icon: Icons.favorite_border_rounded,
              title: 'Your Wishlist is Empty',
              message: 'Save your favorite resorts, villas, and boutique hotels by tapping the heart icon.',
              actionText: 'Explore Hotels',
              onAction: () => context.go(RouteNames.hotels),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<WishlistCubit>().loadWishlist();
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              itemCount: state.items.length,
              separatorBuilder: (context, _) => AppSpacing.gapH16,
              itemBuilder: (context, index) {
                final hotel = state.items[index];
                return HotelCard(
                  hotel: hotel,
                  onTap: () {
                    context.push('${RouteNames.hotelDetails}/${hotel.id}', extra: hotel);
                  },
                );
              },
            ),
          );
        },
      ),
      ),
    );
  }
}
