import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/hotel.dart';
import '../../domain/usecases/hotel_usecases.dart';

class HotelFilterCriteria extends Equatable {
  final String query;
  final String? destination;
  final double minPrice;
  final double maxPrice;
  final double minRating;
  final List<String> selectedAmenities;
  final String sortBy; // 'popular', 'price_low_high', 'price_high_low', 'rating'

  const HotelFilterCriteria({
    this.query = '',
    this.destination,
    this.minPrice = 0,
    this.maxPrice = 80000,
    this.minRating = 0,
    this.selectedAmenities = const [],
    this.sortBy = 'popular',
  });

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      (destination != null && destination != 'all') ||
      minPrice > 0 ||
      maxPrice < 80000 ||
      minRating > 0 ||
      selectedAmenities.isNotEmpty ||
      sortBy != 'popular';

  HotelFilterCriteria copyWith({
    String? query,
    String? destination,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? selectedAmenities,
    String? sortBy,
    bool clearDestination = false,
  }) {
    return HotelFilterCriteria(
      query: query ?? this.query,
      destination: clearDestination ? null : (destination ?? this.destination),
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      selectedAmenities: selectedAmenities ?? this.selectedAmenities,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [
        query,
        destination,
        minPrice,
        maxPrice,
        minRating,
        selectedAmenities,
        sortBy,
      ];
}

abstract class HotelSearchState extends Equatable {
  final HotelFilterCriteria criteria;
  const HotelSearchState({required this.criteria});

  @override
  List<Object?> get props => [criteria];
}

class HotelSearchInitial extends HotelSearchState {
  const HotelSearchInitial({super.criteria = const HotelFilterCriteria()});
}

class HotelSearchLoading extends HotelSearchState {
  const HotelSearchLoading({required super.criteria});
}

class HotelSearchSuccess extends HotelSearchState {
  final List<Hotel> hotels;
  const HotelSearchSuccess({required this.hotels, required super.criteria});

  @override
  List<Object?> get props => [hotels, criteria];
}

class HotelSearchEmpty extends HotelSearchState {
  const HotelSearchEmpty({required super.criteria});
}

class HotelSearchFailure extends HotelSearchState {
  final String message;
  const HotelSearchFailure({required this.message, required super.criteria});

  @override
  List<Object?> get props => [message, criteria];
}

class HotelSearchCubit extends Cubit<HotelSearchState> {
  final GetHotelsUseCase getHotelsUseCase;

  HotelSearchCubit({required this.getHotelsUseCase})
      : super(const HotelSearchInitial());

  Future<void> searchHotels([HotelFilterCriteria? newCriteria]) async {
    final criteria = newCriteria ?? state.criteria;
    emit(HotelSearchLoading(criteria: criteria));

    final result = await getHotelsUseCase(
      search: criteria.query,
      destination: criteria.destination,
      minPrice: criteria.minPrice > 0 ? criteria.minPrice : null,
      maxPrice: criteria.maxPrice < 80000 ? criteria.maxPrice : null,
      rating: criteria.minRating > 0 ? criteria.minRating : null,
      sort: criteria.sortBy,
    );

    if (result.failure != null) {
      emit(HotelSearchFailure(message: result.failure!.message, criteria: criteria));
      return;
    }

    var hotels = result.hotels ?? [];

    // Filter by selected amenities if any
    if (criteria.selectedAmenities.isNotEmpty) {
      hotels = hotels.where((h) {
        final hotelAmenityNames = h.amenities.map((a) => a.name.toLowerCase()).toList();
        return criteria.selectedAmenities.every((sel) =>
            hotelAmenityNames.any((name) => name.contains(sel.toLowerCase())));
      }).toList();
    }

    if (hotels.isEmpty) {
      emit(HotelSearchEmpty(criteria: criteria));
    } else {
      emit(HotelSearchSuccess(hotels: hotels, criteria: criteria));
    }
  }

  void updateQuery(String query) {
    final updated = state.criteria.copyWith(query: query);
    searchHotels(updated);
  }

  void updateDestination(String? destination) {
    final updated = state.criteria.copyWith(
      destination: destination,
      clearDestination: destination == null || destination == 'all',
    );
    searchHotels(updated);
  }

  void updateSort(String sort) {
    final updated = state.criteria.copyWith(sortBy: sort);
    searchHotels(updated);
  }

  void applyFilters({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? selectedAmenities,
    String? sortBy,
  }) {
    final updated = state.criteria.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
      minRating: minRating,
      selectedAmenities: selectedAmenities,
      sortBy: sortBy,
    );
    searchHotels(updated);
  }

  void clearFilters() {
    const reset = HotelFilterCriteria();
    searchHotels(reset);
  }
}
