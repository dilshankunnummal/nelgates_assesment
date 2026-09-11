import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../config/app_environment.dart';
import '../constants/storage_constants.dart';
import '../network/api_client.dart';
import '../services/cloudinary_service.dart';
import '../services/firestore_seeder.dart';
import '../theme/theme_cubit.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/firebase_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/firebase_auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/booking/data/datasources/booking_local_data_source.dart';
import '../../features/booking/data/datasources/booking_remote_data_source.dart';
import '../../features/booking/data/datasources/firebase_booking_data_source.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/booking_usecases.dart';
import '../../features/booking/presentation/cubits/booking_cubit.dart';
import '../../features/booking/presentation/cubits/bookings_cubit.dart';
import '../../features/hotels/data/datasources/firebase_hotel_data_source.dart';
import '../../features/hotels/data/datasources/hotel_local_data_source.dart';
import '../../features/hotels/data/datasources/hotel_remote_data_source.dart';
import '../../features/hotels/data/repositories/hotel_repository_impl.dart';
import '../../features/hotels/domain/repositories/hotel_repository.dart';
import '../../features/hotels/domain/usecases/hotel_usecases.dart';
import '../../features/hotels/presentation/cubits/home_cubit.dart';
import '../../features/hotels/presentation/cubits/hotel_details_cubit.dart';
import '../../features/hotels/presentation/cubits/hotel_search_cubit.dart';
import '../../features/wishlist/data/datasources/wishlist_local_data_source.dart';
import '../../features/wishlist/data/repositories/wishlist_repository_impl.dart';
import '../../features/wishlist/domain/repositories/wishlist_repository.dart';
import '../../features/wishlist/domain/usecases/wishlist_usecases.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {

  await Hive.initFlutter();
  final authBox = await Hive.openBox(StorageConstants.authBox);
  final themeBox = await Hive.openBox(StorageConstants.themeBox);
  final wishlistBox = await Hive.openBox(StorageConstants.wishlistBox);
  final bookingsBox = await Hive.openBox(StorageConstants.bookingsBox);
  final hotelsCacheBox = await Hive.openBox(StorageConstants.hotelsCacheBox);

  sl.registerLazySingleton<Box>(() => authBox, instanceName: StorageConstants.authBox);
  sl.registerLazySingleton<Box>(() => themeBox, instanceName: StorageConstants.themeBox);
  sl.registerLazySingleton<Box>(() => wishlistBox, instanceName: StorageConstants.wishlistBox);
  sl.registerLazySingleton<Box>(() => bookingsBox, instanceName: StorageConstants.bookingsBox);
  sl.registerLazySingleton<Box>(() => hotelsCacheBox, instanceName: StorageConstants.hotelsCacheBox);

  sl.registerLazySingleton<CloudinaryService>(() => CloudinaryService());
  sl.registerLazySingleton<FirestoreSeeder>(() => FirestoreSeeder());

  sl.registerLazySingleton<ApiClient>(() => DioApiClient());

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(box: sl<Box>(instanceName: StorageConstants.authBox)),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSourceImpl(),
  );

  sl.registerLazySingleton<HotelLocalDataSource>(
    () => HotelLocalDataSourceImpl(box: sl<Box>(instanceName: StorageConstants.hotelsCacheBox)),
  );
  sl.registerLazySingleton<HotelRemoteDataSource>(
    () => AppEnvironment.isFirebase
        ? FirebaseHotelDataSourceImpl()
        : HotelRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  sl.registerLazySingleton<WishlistLocalDataSource>(
    () => WishlistLocalDataSourceImpl(box: sl<Box>(instanceName: StorageConstants.wishlistBox)),
  );

  sl.registerLazySingleton<BookingLocalDataSource>(
    () => BookingLocalDataSourceImpl(box: sl<Box>(instanceName: StorageConstants.bookingsBox)),
  );
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => AppEnvironment.isFirebase
        ? FirebaseBookingDataSourceImpl()
        : BookingRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AppEnvironment.isFirebase
        ? FirebaseAuthRepositoryImpl(
            firebaseAuthDataSource: sl<FirebaseAuthDataSource>(),
            localDataSource: sl<AuthLocalDataSource>(),
          )
        : AuthRepositoryImpl(
            remoteDataSource: sl<AuthRemoteDataSource>(),
            localDataSource: sl<AuthLocalDataSource>(),
          ),
  );

  sl.registerLazySingleton<HotelRepository>(
    () => HotelRepositoryImpl(
      remoteDataSource: sl<HotelRemoteDataSource>(),
      localDataSource: sl<HotelLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(
      localDataSource: sl<WishlistLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      remoteDataSource: sl<BookingRemoteDataSource>(),
      localDataSource: sl<BookingLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetSessionUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(() => GetHotelsUseCase(sl<HotelRepository>()));
  sl.registerLazySingleton(() => GetHotelByIdUseCase(sl<HotelRepository>()));
  sl.registerLazySingleton(() => GetDestinationsUseCase(sl<HotelRepository>()));

  sl.registerLazySingleton(() => GetWishlistUseCase(sl<WishlistRepository>()));
  sl.registerLazySingleton(() => ToggleWishlistUseCase(sl<WishlistRepository>()));
  sl.registerLazySingleton(() => IsHotelWishlistedUseCase(sl<WishlistRepository>()));

  sl.registerLazySingleton(() => CreateBookingUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(() => GetBookingsUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl<BookingRepository>()));
  sl.registerLazySingleton(() => GetBookingByIdUseCase(sl<BookingRepository>()));

  sl.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(themeBox: sl<Box>(instanceName: StorageConstants.themeBox)),
  );

  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
      getSessionUseCase: sl<GetSessionUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );

  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      getDestinationsUseCase: sl<GetDestinationsUseCase>(),
      getHotelsUseCase: sl<GetHotelsUseCase>(),
    ),
  );

  sl.registerFactory<HotelSearchCubit>(
    () => HotelSearchCubit(
      getHotelsUseCase: sl<GetHotelsUseCase>(),
    ),
  );

  sl.registerFactory<HotelDetailsCubit>(
    () => HotelDetailsCubit(
      getHotelByIdUseCase: sl<GetHotelByIdUseCase>(),
    ),
  );

  sl.registerFactory<WishlistCubit>(
    () => WishlistCubit(
      getWishlistUseCase: sl<GetWishlistUseCase>(),
      toggleWishlistUseCase: sl<ToggleWishlistUseCase>(),
    ),
  );

  sl.registerFactory<BookingCubit>(
    () => BookingCubit(
      createBookingUseCase: sl<CreateBookingUseCase>(),
    ),
  );

  sl.registerFactory<BookingsCubit>(
    () => BookingsCubit(
      getBookingsUseCase: sl<GetBookingsUseCase>(),
      cancelBookingUseCase: sl<CancelBookingUseCase>(),
    ),
  );

  if (AppEnvironment.isFirebase) {
    sl<FirestoreSeeder>().seedInitialData();
  }
}
