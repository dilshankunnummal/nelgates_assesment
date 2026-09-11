import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/destination_utils.dart';
import '../../domain/entities/destination.dart';
import '../../domain/entities/hotel.dart';
import '../../domain/usecases/hotel_usecases.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Destination> destinations;
  final List<Hotel> recommendedHotels;
  final List<Hotel> popularHotels;

  const HomeLoaded({
    required this.destinations,
    required this.recommendedHotels,
    required this.popularHotels,
  });

  @override
  List<Object?> get props => [destinations, recommendedHotels, popularHotels];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeCubit extends Cubit<HomeState> {
  final GetDestinationsUseCase getDestinationsUseCase;
  final GetHotelsUseCase getHotelsUseCase;

  HomeCubit({
    required this.getDestinationsUseCase,
    required this.getHotelsUseCase,
  }) : super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(const HomeLoading());

    final destResult = await getDestinationsUseCase();
    final hotelsResult = await getHotelsUseCase();

    if (destResult.failure != null && (destResult.destinations == null || destResult.destinations!.isEmpty)) {
      emit(HomeError(destResult.failure!.message));
      return;
    }

    if (hotelsResult.failure != null && (hotelsResult.hotels == null || hotelsResult.hotels!.isEmpty)) {
      emit(HomeError(hotelsResult.failure!.message));
      return;
    }

    final hotels = hotelsResult.hotels ?? [];
    final popular = hotels.where((h) => h.isPopular).toList();
    final recommended = hotels.where((h) => h.isFeatured).toList();

    final rawDestinations = destResult.destinations ?? [];
    final syncedDestinations = rawDestinations.map((dest) {
      if (hotels.isNotEmpty) {
        final count = hotels.where((h) => DestinationUtils.matchesDestination(
          hotelDestination: h.destination,
          hotelCity: h.city,
          hotelState: h.state,
          targetDestination: dest.name,
        )).length;
        if (count > 0) {
          return dest.copyWith(hotelCount: count);
        }
      }
      return dest;
    }).toList();

    emit(HomeLoaded(
      destinations: syncedDestinations,
      recommendedHotels: recommended.isNotEmpty ? recommended : hotels.take(5).toList(),
      popularHotels: popular.isNotEmpty ? popular : hotels.reversed.take(5).toList(),
    ));
  }
}
