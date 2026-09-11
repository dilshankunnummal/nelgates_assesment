import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/hotels/domain/entities/hotel.dart';
import '../../domain/usecases/wishlist_usecases.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlistUseCase getWishlistUseCase;
  final ToggleWishlistUseCase toggleWishlistUseCase;

  WishlistCubit({
    required this.getWishlistUseCase,
    required this.toggleWishlistUseCase,
  }) : super(const WishlistInitial());

  Future<void> loadWishlist() async {
    emit(WishlistLoading(items: state.items));
    final result = await getWishlistUseCase();

    if (result.failure != null) {
      emit(WishlistError(message: result.failure!.message, items: state.items));
      return;
    }

    final hotels = result.hotels ?? [];
    if (hotels.isEmpty) {
      emit(const WishlistEmpty());
    } else {
      emit(WishlistLoaded(items: hotels));
    }
  }

  Future<void> toggleWishlist(Hotel hotel) async {
    final previousItems = List<Hotel>.from(state.items);
    final isAlreadyWishlisted = previousItems.any((h) => h.id == hotel.id);

    final optimisticItems = List<Hotel>.from(previousItems);
    if (isAlreadyWishlisted) {
      optimisticItems.removeWhere((h) => h.id == hotel.id);
    } else {
      optimisticItems.insert(0, hotel);
    }

    if (optimisticItems.isEmpty) {
      emit(const WishlistEmpty());
    } else {
      emit(WishlistLoaded(items: optimisticItems));
    }

    final result = await toggleWishlistUseCase(hotel);

    if (result.failure != null) {
      emit(WishlistError(
        message: 'Failed to update wishlist. Rolling back changes.',
        items: previousItems,
      ));
    }
  }
}
