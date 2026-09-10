import 'package:equatable/equatable.dart';
import '../../../../features/hotels/domain/entities/hotel.dart';

abstract class WishlistState extends Equatable {
  final List<Hotel> items;
  const WishlistState({this.items = const []});

  bool isWishlisted(String hotelId) => items.any((h) => h.id == hotelId);

  @override
  List<Object?> get props => [items];
}

class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

class WishlistLoading extends WishlistState {
  const WishlistLoading({super.items});
}

class WishlistLoaded extends WishlistState {
  const WishlistLoaded({required super.items});
}

class WishlistEmpty extends WishlistState {
  const WishlistEmpty() : super(items: const []);
}

class WishlistError extends WishlistState {
  final String message;
  const WishlistError({required this.message, super.items});

  @override
  List<Object?> get props => [message, items];
}
