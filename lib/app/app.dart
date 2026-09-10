import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants/app_constants.dart';
import '../core/di/injection.dart';
import '../core/routing/app_router.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_cubit.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/booking/presentation/cubits/booking_cubit.dart';
import '../features/booking/presentation/cubits/bookings_cubit.dart';
import '../features/hotels/presentation/cubits/home_cubit.dart';
import '../features/hotels/presentation/cubits/hotel_details_cubit.dart';
import '../features/hotels/presentation/cubits/hotel_search_cubit.dart';
import '../features/wishlist/presentation/cubit/wishlist_cubit.dart';

class LuxeStayApp extends StatelessWidget {
  const LuxeStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(
          value: sl<ThemeCubit>(),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => sl<AuthCubit>()..checkAuthSession(),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => sl<HomeCubit>(),
        ),
        BlocProvider<HotelSearchCubit>(
          create: (_) => sl<HotelSearchCubit>(),
        ),
        BlocProvider<HotelDetailsCubit>(
          create: (_) => sl<HotelDetailsCubit>(),
        ),
        BlocProvider<BookingCubit>(
          create: (_) => sl<BookingCubit>(),
        ),
        BlocProvider<BookingsCubit>(
          create: (_) => sl<BookingsCubit>()..loadBookings(),
        ),
        BlocProvider<WishlistCubit>(
          create: (_) => sl<WishlistCubit>()..loadWishlist(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
