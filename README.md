# 🏨 LuxStay — Premium Hotel Booking Application

A production-grade, commercial-quality Flutter mobile application built with **Clean Architecture**, **BLoC/Cubit state management**, a custom **Liquid Glass / Glassmorphism design system**, defensive JSON parsing, and full **Hive local persistence**.

---

## 📖 Project Overview

**LuxStay** is a hotel booking mobile application built for Android and iOS that delivers a refined booking experience. Designed from the ground up to reflect modern mobile software engineering standards, LuxStay integrates:
- Liquid Glass visual hierarchy with backdrop blur, translucent cards, subtle gradients, and dark/light mode balance.
- Clean Architecture strictly separating Presentation, Domain, and Data layers.
- Robust state management with Flutter BLoC/Cubit.
- Resilient, defensive data models that safeguard against malformed JSON or varying backend response shapes.
- End-to-end local persistence for authentication sessions, saved bookings, and wishlists.
- Reusable, test-covered calculation logic for room pricing, nights, GST taxes (12%), and service charges (5%).

---

## 🌟 Key Features

1. **Authentication & Session Management**
   - Mock REST authentication supporting Employee and HR accounts.
   - Form validation with reactive error states and password toggles.
   - Persistent session across application restarts with full logout workflow.

2. **Home & Discovery**
   - Personalized greeting and interactive search triggers.
   - Destination discovery cards with instant query pre-filtering (Goa, Mumbai, Manali, Jaipur, Bengaluru, Kerala).
   - "Recommended Stays" carousel with real-time wishlist toggling and rating badges.

3. **Hotel Search, Filters & Sorting**
   - Free-text search by hotel name and destination city.
   - Multi-criteria filter modal:
     - Interactive price range slider (₹1,000 to ₹30,000+).
     - Star rating selection (3★, 4★, 5★).
     - Amenities filtering (Free WiFi, Swimming Pool, Spa, Ocean View, Breakfast Included, Gym, Airport Shuttle, Valet Parking, Rooftop Bar).
   - Sorting options: Price (Low to High / High to Low) and Rating (Highest first).
   - Complete support for Loading, Success, Empty, and Error states.

4. **Hotel Details & Room Selection**
   - High-definition swipeable image gallery with index counter.
   - Detailed property descriptions, full amenity tags, and policies.
   - Dynamic room cards displaying bed types, capacities, prices, and amenities.
   - Check-in / Check-out date pickers with validation (Check-out must be after Check-in).
   - Steppers for Room Count, Adult Guests, and Children.

5. **Dynamic Price Calculation**
   - Automatic night calculation based on selected dates.
   - Reusable formula:
     $$\text{Subtotal} = \text{Room Price} \times \text{Nights} \times \text{Rooms}$$
     $$\text{GST (12\%)} = \text{Subtotal} \times 0.12$$
     $$\text{Service Charge (5\%)} = \text{Subtotal} \times 0.05$$
     $$\text{Final Total} = \text{Subtotal} + \text{Taxes} + \text{Service Charge}$$
   - Formatted in Indian Rupee (INR - e.g., ₹12,000) using the `intl` package.

6. **Booking Summary & Confirmation**
   - Detailed review screen with full stay breakdown and primary guest contact form.
   - Mock reservation engine creating a unique booking reference (`HTL-2026-XXXXXX`).
   - Confirmation receipt with options to navigate directly to My Bookings or return Home.

7. **My Bookings & Cancellation**
   - Tabbed management for **Upcoming**, **Completed**, and **Cancelled** stays.
   - Detailed booking receipt view.
   - Safe cancellation dialog for upcoming reservations (persists status change in Hive without deleting historical records).

8. **Persistent Wishlist**
   - Instant add/remove toggles on cards and detail screens.
   - Optimistic UI updates with rollback handling on persistence failure.
   - Dedicated Wishlist screen with direct navigation to hotel details.

9. **Liquid Glass Design System (Light & Dark Theme)**
   - Custom `AppGlassCard`, `GlassButton`, `GlassChip`, `GlassSearchBar`, and `GlassBottomNav`.
   - Tuned blur radii, border opacities, and contrast ratios compliant with both dark and light modes.
   - Theme persistence via Hive with live switching in the Settings screen.

---

## 🛠️ Technology Stack

| Layer / Concern | Technology |
|---|---|
| **Framework** | Flutter 3.44.8 / Dart 3.12.2 (Null Safety) |
| **State Management** | `flutter_bloc` / `bloc` |
| **Dependency Injection** | `get_it` |
| **Routing** | `go_router` (declarative routing with redirects) |
| **Networking** | `dio` with mock REST interceptor |
| **Local Persistence** | `hive` / `hive_flutter` |
| **Value Equality** | `equatable` |
| **Formatting** | `intl` (INR Currency, DateTime formatting) |
| **Testing** | `flutter_test`, `bloc_test`, `mocktail` |

---

## 🏛️ Clean Architecture

The codebase strictly adheres to Clean Architecture principles:

```
                  ┌────────────────────────┐
                  │   Presentation Layer   │
                  │ (Pages, Cubits, Glass) │
                  └───────────┬────────────┘
                              │
                              ▼
                  ┌────────────────────────┐
                  │      Domain Layer      │
                  │ (Entities, Use Cases)  │
                  └───────────┬────────────┘
                              │
                              ▼
                  ┌────────────────────────┐
                  │       Data Layer       │
                  │(Models, Repos, Sources)│
                  └────────────────────────┘
```

- **Presentation Layer**: Contains UI screens, reusable Liquid Glass widgets, and BLoC/Cubit state handlers. UI widgets never directly interact with repositories, Dio, or Hive.
- **Domain Layer**: Contains business entities, repository contracts (interfaces), and single-purpose Use Cases (`LoginUseCase`, `GetHotelsUseCase`, `CreateBookingUseCase`, `ToggleWishlistUseCase`, etc.).
- **Data Layer**: Contains API DataSources (remote/local), Hive storage implementations, and concrete repositories mapping raw JSON to defensive data models.

---

## 📂 Project Structure

```
lib/
├── app/
│   └── app.dart                         # MaterialApp, ThemeBuilder, BlocProviders
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── storage_constants.dart
│   ├── di/
│   │   └── injection.dart               # Service locator setup with get_it
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── network/
│   │   ├── api_client.dart              # Reusable Dio client
│   │   ├── mock_hotel_data.dart         # 11+ realistic hotels & 6 destinations
│   │   └── mock_interceptor.dart        # Interceptor simulating REST endpoints
│   ├── routing/
│   │   ├── app_router.dart              # go_router configuration & redirect logic
│   │   └── route_names.dart             # Type-safe route identifiers
│   ├── theme/
│   │   ├── app_colors.dart              # Curated light and dark palettes
│   │   ├── app_radius.dart
│   │   ├── app_shadows.dart
│   │   ├── app_spacing.dart
│   │   ├── app_theme.dart               # Material ThemeData definitions
│   │   ├── app_typography.dart
│   │   ├── glass_theme.dart             # Centralized Glassmorphic design tokens
│   │   └── theme_cubit.dart             # Dark/Light theme mode state
│   ├── utils/
│   │   ├── booking_id_generator.dart    # Format: HTL-2026-XXXXXX
│   │   ├── currency_utils.dart          # INR formatting
│   │   ├── date_utils.dart              # Safe date operations & night math
│   │   ├── price_calculator.dart        # Subtotal, tax, service charge, and total
│   │   ├── safe_parser.dart             # Defensive type conversions
│   │   └── validators.dart              # Email, password, phone, guest checks
│   └── widgets/
│       ├── common/                      # Reusable UI widgets (buttons, cards, loaders)
│       └── glass/                       # Liquid Glass widgets (cards, buttons, chips, search)
├── features/
│   ├── auth/                            # Login, credentials, session management
│   ├── booking/                         # Stay configuration, summary, confirmation, history
│   ├── hotels/                          # Hotel listings, discovery, search, details
│   ├── settings/                        # Theme toggling, profile info, logout
│   ├── shell/                           # Persistent bottom navigation shell
│   └── wishlist/                        # Saved hotels with optimistic updates
└── main.dart                            # App entry point, Hive & DI initialization
```

---

## 🔒 Assessment Credentials

The mock authentication datasource verifies against the following credentials:

| Role | Email | Password |
|---|---|---|
| **Employee (Default)** | `employee@hotel.com` | `Employee@123` |
| **HR Admin** | `hr@hotel.com` | `HR@123` |

---

## 🌐 Mock REST Endpoints

Simulated via Dio interceptor with simulated network latency:

- `POST /api/auth/login` — Verifies email/password and returns user profile & auth token.
- `GET /api/hotels` — Returns all hotels or filters by query, destination, price, rating, or amenities.
- `GET /api/hotels/{id}` — Returns single hotel details.
- `GET /api/destinations` — Returns curated travel destinations with image assets.
- `GET /api/bookings` — Returns user bookings.
- `POST /api/bookings` — Creates a new hotel reservation.
- `PATCH /api/bookings/{id}/cancel` — Cancels an existing reservation.

---

## 💾 Local Storage (Hive)

Persistent data boxes managed independently from the UI:
- `authBox`: Current authentication token and active user profile.
- `themeBox`: Active brightness preference (light vs dark).
- `wishlistBox`: Array of saved hotel IDs.
- `bookingsBox`: Array of completed and cancelled reservations.
- `hotelCacheBox`: Offline cached hotel catalog.

---

## 🧪 Testing Suite

Automated tests cover all critical layers:
1. **Unit Tests**:
   - `price_calculator_test.dart`: Price formulas, multi-night/multi-room math, zero values, edge cases.
   - `safe_parser_test.dart`: Resilient parsing of ints, doubles, strings, and multi-format image JSON.
   - `validators_test.dart`: Email, password, date checks, room and guest bounds.
   - `date_utils_test.dart`: Night calculations, string representations.
2. **Cubit Tests**:
   - `auth_cubit_test.dart`: Initial → Loading → Success / Failure transitions.
   - `hotel_search_cubit_test.dart`: Querying, filtering, sorting, empty states.
   - `booking_cubit_test.dart`: Room selection, guest counters, calculations, confirmation.
   - `bookings_cubit_test.dart`: Loading reservations, cancellation, state persistence.
   - `wishlist_cubit_test.dart`: Add/remove items with optimistic state updates.
3. **Widget Tests**:
   - `login_page_test.dart`: Form validation triggers, button states.
   - `hotel_card_test.dart`: Content rendering, price and rating formatting, wishlist taps.

To run the complete test suite:
```bash
flutter test
```

---

## 🚀 Setup & Execution Instructions

### Prerequisites
- Flutter SDK (v3.20.0 or higher recommended, tested on Flutter 3.44.8)
- Dart SDK (v3.3.0 or higher)
- Android Studio / Xcode / VS Code with Flutter extension

### Installation
1. Clone or open the repository root:
   ```bash
   cd nelegate_assessment
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run static analyzer:
   ```bash
   flutter analyze
   ```
4. Run all unit and widget tests:
   ```bash
   flutter test
   ```
5. Run the application:
   ```bash
   flutter run
   ```

---

## 📦 Release APK Build Instructions

To generate a standalone release Android APK:
```bash
flutter build apk --release
```
The output file will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## ⚠️ Known Limitations

- **Payment Gateway**: As per the assessment specification, a mock confirmation mechanism is used rather than integrating real Stripe/Razorpay SDKs.
- **External Maps**: Location coordinates and amenities are rendered natively with a stylized Glassmorphic map placeholder rather than requiring live Google Maps API keys.
- **Backend API**: The REST API layer uses local in-memory/interceptor mock responses designed to be swapped with a live REST base URL seamlessly by replacing `mock_interceptor.dart`.
#   n e l g a t e s _ a s s e s m e n t  
 