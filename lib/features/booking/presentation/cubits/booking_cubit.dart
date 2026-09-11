import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/booking_id_generator.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/price_calculator.dart';
import '../../../hotels/domain/entities/hotel.dart';
import '../../../hotels/domain/entities/room.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/guest.dart';
import '../../domain/usecases/booking_usecases.dart';

class BookingDraft extends Equatable {
  final Hotel hotel;
  final Room room;
  final DateTime checkIn;
  final DateTime checkOut;
  final int roomsCount;
  final int adults;
  final int children;
  final Guest? guest;

  const BookingDraft({
    required this.hotel,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    this.roomsCount = 1,
    this.adults = 2,
    this.children = 0,
    this.guest,
  });

  int get nights => AppDateUtils.calculateNights(checkIn, checkOut);

  PriceBreakdown get priceBreakdown => PriceCalculator.calculate(
        baseRoomPrice: room.pricePerNight,
        nights: nights,
        rooms: roomsCount,
      );

  BookingDraft copyWith({
    Hotel? hotel,
    Room? room,
    DateTime? checkIn,
    DateTime? checkOut,
    int? roomsCount,
    int? adults,
    int? children,
    Guest? guest,
  }) {
    return BookingDraft(
      hotel: hotel ?? this.hotel,
      room: room ?? this.room,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      roomsCount: roomsCount ?? this.roomsCount,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      guest: guest ?? this.guest,
    );
  }

  @override
  List<Object?> get props => [
        hotel,
        room,
        checkIn,
        checkOut,
        roomsCount,
        adults,
        children,
        guest,
      ];
}

abstract class BookingState extends Equatable {
  final BookingDraft? draft;
  const BookingState({this.draft});

  @override
  List<Object?> get props => [draft];
}

class BookingInitial extends BookingState {
  const BookingInitial();
}

class BookingConfiguring extends BookingState {
  const BookingConfiguring({required BookingDraft draft}) : super(draft: draft);
}

class BookingSubmitting extends BookingState {
  const BookingSubmitting({required BookingDraft draft}) : super(draft: draft);
}

class BookingConfirmed extends BookingState {
  final Booking booking;
  const BookingConfirmed({required this.booking, required BookingDraft draft})
      : super(draft: draft);

  @override
  List<Object?> get props => [booking, draft];
}

class BookingFailure extends BookingState {
  final String message;
  const BookingFailure({required this.message, required BookingDraft draft})
      : super(draft: draft);

  @override
  List<Object?> get props => [message, draft];
}

class BookingCubit extends Cubit<BookingState> {
  final CreateBookingUseCase createBookingUseCase;

  BookingCubit({required this.createBookingUseCase})
      : super(const BookingInitial());

  void initBooking({
    required Hotel hotel,
    required Room room,
    DateTime? checkIn,
    DateTime? checkOut,
  }) {
    final now = DateTime.now();
    final start = checkIn ?? DateTime(now.year, now.month, now.day + 1);
    final end = checkOut ?? DateTime(now.year, now.month, now.day + 3);

    final draft = BookingDraft(
      hotel: hotel,
      room: room,
      checkIn: start,
      checkOut: end,
    );
    emit(BookingConfiguring(draft: draft));
  }

  void updateDates({required DateTime checkIn, required DateTime checkOut}) {
    if (state.draft != null) {
      final updated = state.draft!.copyWith(
        checkIn: checkIn,
        checkOut: checkOut,
      );
      emit(BookingConfiguring(draft: updated));
    }
  }

  void updateRoom(Room room) {
    if (state.draft != null) {
      final updated = state.draft!.copyWith(room: room);
      emit(BookingConfiguring(draft: updated));
    }
  }

  void updateGuests({int? adults, int? children, int? roomsCount}) {
    if (state.draft != null) {
      final updated = state.draft!.copyWith(
        adults: adults,
        children: children,
        roomsCount: roomsCount,
      );
      emit(BookingConfiguring(draft: updated));
    }
  }

  void updateGuestDetails(Guest guest) {
    if (state.draft != null) {
      final updated = state.draft!.copyWith(guest: guest);
      emit(BookingConfiguring(draft: updated));
    }
  }

  Future<void> confirmBooking({String? userId}) async {
    final draft = state.draft;
    if (draft == null || draft.guest == null) {
      if (draft != null) {
        emit(BookingFailure(message: 'Please provide guest information.', draft: draft));
      }
      return;
    }

    emit(BookingSubmitting(draft: draft));

    final breakdown = draft.priceBreakdown;
    final booking = Booking(
      id: BookingIdGenerator.generate(),
      userId: userId,
      hotelId: draft.hotel.id,
      hotelName: draft.hotel.name,
      hotelImage: draft.hotel.mainImage,
      hotelAddress: draft.hotel.address,
      room: draft.room,
      checkInDate: draft.checkIn,
      checkOutDate: draft.checkOut,
      nights: draft.nights,
      adults: draft.adults,
      children: draft.children,
      roomsCount: draft.roomsCount,
      baseRoomPrice: breakdown.baseRoomPrice,
      subtotal: breakdown.subtotal,
      taxAmount: breakdown.taxAmount,
      serviceChargeAmount: breakdown.serviceChargeAmount,
      totalAmount: breakdown.grandTotal,
      guest: draft.guest!,
      status: 'upcoming',
      createdAt: DateTime.now(),
    );

    final result = await createBookingUseCase(booking);

    if (result.failure != null) {
      emit(BookingFailure(message: result.failure!.message, draft: draft));
    } else if (result.booking != null) {
      emit(BookingConfirmed(booking: result.booking!, draft: draft));
    } else {
      emit(BookingFailure(message: 'Failed to create booking.', draft: draft));
    }
  }
}
