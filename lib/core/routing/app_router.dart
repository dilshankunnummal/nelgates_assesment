import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/booking/domain/entities/booking.dart';
import '../../features/booking/presentation/pages/booking_confirmation_page.dart';
import '../../features/booking/presentation/pages/booking_details_page.dart';
import '../../features/booking/presentation/pages/booking_page.dart';
import '../../features/booking/presentation/pages/booking_summary_page.dart';
import '../../features/hotels/domain/entities/hotel.dart';
import '../../features/hotels/presentation/pages/hotel_details_page.dart';
import '../../features/hotels/presentation/pages/hotel_search_page.dart';
import '../../features/shell/presentation/pages/main_scaffold_page.dart';
import 'route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const MainScaffoldPage(initialIndex: 0),
      ),
      GoRoute(
        path: RouteNames.bookings,
        name: 'bookings',
        builder: (context, state) => const MainScaffoldPage(initialIndex: 1),
      ),
      GoRoute(
        path: RouteNames.wishlist,
        name: 'wishlist',
        builder: (context, state) => const MainScaffoldPage(initialIndex: 2),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const MainScaffoldPage(initialIndex: 3),
      ),
      GoRoute(
        path: RouteNames.hotels,
        name: 'hotels',
        builder: (context, state) {
          final destination = state.uri.queryParameters['destination'];
          return HotelSearchPage(initialDestination: destination);
        },
      ),
      GoRoute(
        path: '${RouteNames.hotelDetails}/:id',
        name: 'hotelDetails',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'HTL-001';
          final hotel = state.extra is Hotel ? state.extra as Hotel : null;
          return HotelDetailsPage(hotelId: id, initialHotel: hotel);
        },
      ),
      GoRoute(
        path: RouteNames.booking,
        name: 'booking',
        builder: (context, state) => const BookingPage(),
      ),
      GoRoute(
        path: RouteNames.bookingSummary,
        name: 'bookingSummary',
        builder: (context, state) => const BookingSummaryPage(),
      ),
      GoRoute(
        path: RouteNames.bookingConfirmation,
        name: 'bookingConfirmation',
        builder: (context, state) {
          final booking = state.extra is Booking ? state.extra as Booking : null;
          return BookingConfirmationPage(booking: booking);
        },
      ),
      GoRoute(
        path: '${RouteNames.bookingDetails}/:id',
        name: 'bookingDetails',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          final booking = state.extra is Booking ? state.extra as Booking : null;
          return BookingDetailsPage(bookingId: id, initialBooking: booking);
        },
      ),
    ],
  );
}
