import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/hotel.dart';
import '../../domain/entities/room.dart';
import '../../domain/usecases/hotel_usecases.dart';

abstract class HotelDetailsState extends Equatable {
  const HotelDetailsState();

  @override
  List<Object?> get props => [];
}

class HotelDetailsInitial extends HotelDetailsState {
  const HotelDetailsInitial();
}

class HotelDetailsLoading extends HotelDetailsState {
  const HotelDetailsLoading();
}

class HotelDetailsLoaded extends HotelDetailsState {
  final Hotel hotel;
  final Room selectedRoom;

  const HotelDetailsLoaded({
    required this.hotel,
    required this.selectedRoom,
  });

  HotelDetailsLoaded copyWith({
    Hotel? hotel,
    Room? selectedRoom,
  }) {
    return HotelDetailsLoaded(
      hotel: hotel ?? this.hotel,
      selectedRoom: selectedRoom ?? this.selectedRoom,
    );
  }

  @override
  List<Object?> get props => [hotel, selectedRoom];
}

class HotelDetailsError extends HotelDetailsState {
  final String message;
  const HotelDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class HotelDetailsCubit extends Cubit<HotelDetailsState> {
  final GetHotelByIdUseCase getHotelByIdUseCase;

  HotelDetailsCubit({required this.getHotelByIdUseCase})
      : super(const HotelDetailsInitial());

  Future<void> loadHotel(String hotelId, [Hotel? initialHotel]) async {
    if (initialHotel != null && initialHotel.rooms.isNotEmpty) {
      emit(HotelDetailsLoaded(
        hotel: initialHotel,
        selectedRoom: initialHotel.rooms.first,
      ));
    } else {
      emit(const HotelDetailsLoading());
    }

    final result = await getHotelByIdUseCase(hotelId);
    if (result.failure != null) {
      if (state is! HotelDetailsLoaded) {
        emit(HotelDetailsError(result.failure!.message));
      }
      return;
    }

    if (result.hotel != null) {
      final hotel = result.hotel!;
      final currentSelected = state is HotelDetailsLoaded
          ? (state as HotelDetailsLoaded).selectedRoom
          : (hotel.rooms.isNotEmpty ? hotel.rooms.first : null);

      if (hotel.rooms.isNotEmpty) {
        emit(HotelDetailsLoaded(
          hotel: hotel,
          selectedRoom: currentSelected ?? hotel.rooms.first,
        ));
      } else {
        emit(HotelDetailsError('No rooms available for this hotel.'));
      }
    }
  }

  void selectRoom(Room room) {
    if (state is HotelDetailsLoaded) {
      emit((state as HotelDetailsLoaded).copyWith(selectedRoom: room));
    }
  }
}
