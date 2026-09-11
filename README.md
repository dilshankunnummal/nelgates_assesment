# 🏨 Booking.com by Dilshan

A production-grade, enterprise-ready Flutter mobile application built with **Clean Architecture**, **BLoC/Cubit state management**, live **Firebase Authentication & Cloud Firestore** backend integration, **Cloudinary Media Storage**, and robust **Hive local persistence**.

---

## 📖 Project Overview

**Booking.com by Dilshan** is a comprehensive hotel discovery and booking application designed for high performance, smooth interactions, and seamless offline-first usability.

### Core Architectural Pillars
- **Clean Architecture**: Strict separation of concerns across **Presentation**, **Domain**, and **Data** layers.
- **BLoC / Cubit State Management**: Predictable, immutable, unidirectional data flow with dedicated cubits for Auth, Hotels, Search, Bookings, Wishlist, and Theme.
- **Direct Firebase Backend**: Standalone client SDK integration for live user authentication, real-time Firestore database queries, and reservation management.
- **Offline-First Resilience**: Automatic local Hive caching for hotel catalogs, active bookings, wishlist items, and user sessions, paired with proactive offline error views and retry triggers.
- **Cloudinary Media Pipeline**: Direct unsigned client-side image compression and upload for profile avatars.
- **Interactive Micro-Animations**: Native haptic feedback, origin-based radial bloom tap effects, and smooth hold-to-compress scaling.
- **Defensive Data Handling**: Safe parser utilities protecting against null values, type mismatches, and malformed network payloads.

---

## 🌟 Key Features

### 1. Authentication & Session Management
- **Firebase Auth Integration**: Real-time sign-in, registration, and session restore.
- **Demo Quick-Fill Access**: One-tap demo accounts for quick testing (**Employee** & **HR Admin**).
- **Form Validation**: Strict email format, secure password rules, and interactive visibility toggles.
- **Session Persistence**: Encrypted local session storage via Hive, automatically restored on app launch.

### 2. Hotel Discovery & Destinations
- **Curated Travel Destinations**: Destination cards with dynamic hotel count counters and pre-filtered discovery routes (e.g., Goa, Mumbai, Manali, Jaipur, Bengaluru, Mysuru, Coorg).
- **Featured Stays**: High-definition image galleries, star rating badges, pricing tags, and real-time wishlist toggling.

### 3. Advanced Search, Filter & Sort
- **Free-Text Search**: Instant search across hotel names, cities, states, and descriptions.
- **Interactive Filter Bottom Sheet**:
  - **Sort Options**: Popularity, Price (Low to High), Price (High to Low), and Highest Rating.
  - **Price Per Night Slider**: Real-time dual-thumb range slider from ₹0 to ₹80,000.
  - **Minimum Rating Selector**: Single-layer animated pills (`All`, `3.5+ ★`, `4.0+ ★`, `4.5+ ★`).
- **Empty & Loading States**: Clean animated skeletons during fetch and clear empty search indicators with reset actions.

### 4. Hotel Details & Dynamic Room Selection
- **Interactive Image Carousel**: Full-bleed gallery with page indicators.
- **Property Highlights**: Full address, comprehensive amenity tags, property descriptions, and cancellation policies.
- **Room Selection & Guest Steppers**:
  - Detailed room tiers (King beds, Heritage Suites, Executive rooms).
  - Check-in and Check-out calendar date pickers with range validation.
  - Interactive stepper controls for Room Count, Adults, and Children.

### 5. Transparent Price Calculator
- **Mathematical Formula**:
  $$\text{Subtotal} = \text{Room Price Per Night} \times \text{Nights} \times \text{Rooms}$$
  $$\text{GST (12\%)} = \text{Subtotal} \times 0.12$$
  $$\text{Service Charge (5\%)} = \text{Subtotal} \times 0.05$$
  $$\text{Final Total} = \text{Subtotal} + \text{Taxes} + \text{Service Charge}$$
- Formatted in Indian Rupee (`₹`) using `intl` currency formatting.

### 6. Booking Engine & Management
- **Reservation Confirmation**: Generates a standardized reservation code (e.g., `HTL-2026-XXXXXX`) synced live to Cloud Firestore.
- **Status Tabs**: Categorized tabs for **Upcoming**, **Completed**, and **Cancelled** bookings.
- **In-App Cancellation**: Real-time cancellation modal with loading dialog and status update in Firestore.

### 7. Persistent Wishlist
- One-tap hotel bookmarking from home cards, search results, and detail views.
- Optimistic UI updates backed by persistent Hive storage.

### 8. User Profile & Settings
- **Cloudinary Avatar Upload**: Take a photo or select from gallery with automatic client-side compression (1024x1024 max dimensions, 82% JPEG quality) and direct upload.
- **Theme Switching**: Instant toggle between Light Mode and Dark Mode with system default option.
- **Secure Sign Out**: Confirmation modal with clean session teardown.

---

## 🛠️ Technology Stack

| Layer / Concern | Technology | Purpose |
|---|---|---|
| **Framework** | Flutter (Dart 3.x, Null Safety) | Cross-platform mobile development |
| **State Management** | `flutter_bloc` & `bloc` | Reactive, decoupled state handling |
| **Backend & Auth** | `firebase_core`, `firebase_auth`, `cloud_firestore` | Live cloud database and user management |
| **Media Hosting** | `cloudinary` via `dio` multipart | Cloud profile image upload and CDN delivery |
| **Dependency Injection** | `get_it` | Service locator and modular decoupling |
| **Routing** | `go_router` | Declarative, deep-link ready navigation |
| **Local Persistence** | `hive` & `hive_flutter` | Fast, lightweight key-value offline storage |
| **Network Client** | `dio` | HTTP networking client |
| **Image Caching** | `cached_network_image` | Smooth image loading with memory/disk caching |
| **Formatting** | `intl` | Currency and date formatting |
| **Testing** | `flutter_test`, `bloc_test`, `mocktail` | Unit, cubit, and widget testing |

---

## 🏛️ Clean Architecture Structure

```
                  ┌─────────────────────────────────────────┐
                  │           Presentation Layer            │
                  │   (Pages, Widgets, Cubits & States)     │
                  └───────────────────┬─────────────────────┘
                                      │
                                      ▼
                  ┌─────────────────────────────────────────┐
                  │              Domain Layer               │
                  │   (Entities, Use Cases, Repositories)   │
                  └───────────────────┬─────────────────────┘
                                      │
                                      ▼
                  ┌─────────────────────────────────────────┐
                  │               Data Layer                │
                  │ (Models, Data Sources, Firestore, Hive) │
                  └─────────────────────────────────────────┘
```

- **Domain Layer**: Completely framework-agnostic. Defines business entities, repository contracts, and single-responsibility Use Cases.
- **Data Layer**: Implements repository contracts, maps raw network data into defensive models, and manages Firestore and Hive data sources.
- **Presentation Layer**: Subscribes to Cubit states and renders UI components. Contains no direct database or network dependencies.

---

## 📂 Project Organization

```
lib/
├── app/
│   └── app.dart                         # MaterialApp.router, Global BlocProviders, Theme setup
├── core/
│   ├── config/
│   │   └── app_environment.dart         # Cloudinary, Firebase, and environment configurations
│   ├── constants/
│   │   ├── app_constants.dart           # App name, tax rates, demo accounts
│   │   └── storage_constants.dart       # Hive box identifiers
│   ├── di/
│   │   └── injection.dart               # Service locator initialization (get_it)
│   ├── error/
│   │   ├── exceptions.dart              # Data layer exceptions
│   │   └── failures.dart                # Domain layer failure objects
│   ├── network/
│   │   ├── api_client.dart              # Dio HTTP client wrapper
│   │   └── mock_hotel_data.dart         # Seed dataset with 11+ hotels and destinations
│   ├── routing/
│   │   ├── app_router.dart              # go_router declarative routes and subroutes
│   │   └── route_names.dart             # Route constants
│   ├── services/
│   │   ├── cloudinary_service.dart      # Image compression and upload service
│   │   └── firestore_seeder.dart        # Firestore collection initialization & self-healing
│   ├── theme/
│   │   ├── app_colors.dart              # Cohesive light and dark palettes
│   │   ├── app_radius.dart              # Border radius tokens
│   │   ├── app_spacing.dart             # Spacing constants
│   │   ├── app_theme.dart               # Material ThemeData definitions
│   │   ├── app_typography.dart          # Font scale and typography rules
│   │   └── theme_cubit.dart             # ThemeMode state management
│   ├── utils/
│   │   ├── app_logger.dart              # Structured console logging
│   │   ├── booking_id_generator.dart    # Format: HTL-2026-XXXXXX
│   │   ├── currency_utils.dart          # Currency formatter
│   │   ├── date_utils.dart              # Night math and date formatting
│   │   ├── price_calculator.dart        # Subtotal, GST (12%), Service Charge (5%) calculator
│   │   ├── safe_parser.dart             # Defensive type conversions
│   │   └── validators.dart              # Form validation utilities
│   └── widgets/
│       ├── common/                      # Buttons, image handlers, error views, rating widgets
│       └── skeleton/                    # Shimmer skeleton loaders for all screens
├── features/
│   ├── auth/                            # Login, registration, splash, auth cubit, user models
│   ├── booking/                         # Booking configuration, review, confirmation, my bookings
│   ├── hotels/                          # Hotel listings, destination cards, search, filters, details
│   ├── profile/                         # User profile view, avatar picker
│   ├── settings/                        # Settings screen, dark mode toggle, logout
│   ├── shell/                           # Bottom navigation shell scaffold
│   └── wishlist/                        # Wishlist management and optimistic toggling
└── main.dart                            # Application entry point, Hive & Firebase init
```

---

## 🔒 Demo Credentials

For quick evaluation, pre-configured accounts are available with one-tap quick-fill buttons on the login screen:

| Role | Email | Password |
|---|---|---|
| **Employee** | `employee@hotel.com` | `Employee@123` |
| **HR Manager** | `hr@hotel.com` | `HR@123` |

*New accounts can also be created directly via the in-app registration flow.*

---

## 💾 Local Persistence (Hive Boxes)

| Box Name | Stored Data |
|---|---|
| `auth_box` | Active user profile, login status, and session token |
| `theme_box` | Selected theme mode (`light`, `dark`, or `system`) |
| `wishlist_box` | Set of bookmarked hotel IDs for instant offline access |
| `bookings_box` | Cached user reservations and historical bookings |
| `hotels_cache_box` | Cached hotel catalog and destinations for offline browsing |

---

## 🧪 Automated Testing Suite

The project includes an extensive test suite covering core business logic, utility math, defensive parsers, and UI components:

### Test Breakdown
- **Unit Tests**:
  - `price_calculator_test.dart`: Validates room pricing, multi-night/multi-room math, zero values, negative protection, and tax calculations.
  - `safe_parser_test.dart`: Tests type conversion resilience for ints, doubles, strings, booleans, and image URLs.
  - `validators_test.dart`: Validates email formats, password strength, phone numbers, guest counts, and dates.
  - `date_utils_test.dart`: Tests date range validations and night difference math.
  - `currency_utils_test.dart`: Tests INR formatting and night suffixes.
  - `hotel_model_test.dart` & `user_model_test.dart`: Validates JSON serialization and deserialization.
  - `hotel_repository_impl_test.dart`: Verifies remote-to-cache fallback mechanisms.
  - `hotel_usecases_test.dart`: Tests domain use case execution.
- **Widget Tests**:
  - `login_page_test.dart`: Form rendering, input validation, and demo button interactions.
  - `hotel_card_test.dart`: Card rendering, pricing, rating display, and wishlist triggers.
  - `rating_widget_test.dart`: Rating stars and review count display.
  - `skeleton_test.dart`: Shimmer loader rendering across cards, lists, and detail views.
  - `widget_test.dart`: Smoke tests and constants validation.

### Run All Tests
```bash
flutter test
```

### Static Analysis
```bash
flutter analyze
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: 3.20.0 or higher
- **Dart SDK**: 3.3.0 or higher
- **Android Studio** / **VS Code** / **Xcode**
- Active Android device or emulator (API 24+)

### Installation & Run
1. **Clone the repository**:
   ```bash
   git clone <repository_url>
   cd nelegate_assessment
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify code quality**:
   ```bash
   flutter analyze
   flutter test
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

---

## 📦 Building Standalone APK

To generate a standalone universal release Android APK:
```bash
flutter build apk --release
```
The output file will be generated at:
`build/app/outputs/flutter-apk/app-release.apk`

---

## ⚠️ Notes & Assumptions

- **Payment Processing**: A mock confirmation engine generates unique transaction and booking references for assessment verification.
- **Interactive Stays**: Hotel listings, images, rooms, and descriptions are dynamically pulled from live Cloud Firestore with automatic local Hive fallback.
- **Profile Media**: Powered directly by Cloudinary CDN unsigned presets with native client-side compression.