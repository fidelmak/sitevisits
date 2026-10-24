# Site Visits App

A robust Flutter application for managing and tracking site visits, featuring offline local caching with `SharedPreferences`, optimistic UI updates, error state handling with custom SnackBars, dynamic unsynced task tracking, and search functionality integrated with `FlakyTaskApi`.

---

## Flutter & Environment Details

- **Flutter Version**: `3.41.2` (Channel `stable`)
- **Dart Version**: `3.11.0`
- **DevTools Version**: `2.54.1`

---

## Dependencies & Packages Used

### Production Dependencies
- **[`flutter_bloc`](https://pub.dev/packages/flutter_bloc)** (`^9.1.1`): Reactive state management (`TaskBloc`, `TaskEvent`, `TaskState`).
- **[`shared_preferences`](https://pub.dev/packages/shared_preferences)** (`^2.5.2`): Local key-value storage for offline task caching and pending edit tracking.
- **[`flutter_screenutil_plus`](https://pub.dev/packages/flutter_screenutil_plus)** (`^1.5.0`): Responsive screen adaptation across multiple screen sizes.
- **[`google_fonts`](https://pub.dev/packages/google_fonts)** (`^8.2.1`): Typography management using the Lato font family.
- **[`http`](https://pub.dev/packages/http)** (`^1.6.0`): HTTP networking client.
- **[`intl`](https://pub.dev/packages/intl)** (`^0.20.3`): Date formatting and internationalization helpers (`DateFormatter`).
- **[`cupertino_icons`](https://pub.dev/packages/cupertino_icons)** (`^1.0.8`): Cupertino iOS-style icons.

### Development Dependencies
- **[`bloc_test`](https://pub.dev/packages/bloc_test)** (`^10.0.0`): Testing library for BLoC event-to-state streams.
- **[`mocktail`](https://pub.dev/packages/mocktail)** (`^1.0.4`): Null-safe mocking library for unit testing.
- **[`flutter_test`](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html)** (Flutter SDK): Widget testing framework.
- **[`flutter_lints`](https://pub.dev/packages/flutter_lints)** (`^6.0.0`): Recommended static analysis rules for Flutter apps.

---

## How to Run the App

### Prerequisites
1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install) (`v3.41.0` or higher).
2. Ensure an Android Emulator, iOS Simulator, or physical device is connected.

### Step-by-Step Instructions

1. **Clone the Repository**:
   ```bash
   git clone <[repository-url](https://github.com/fidelmak/sitevisits.git)>
   cd sitevisits
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   ```bash
   flutter run
   ```

---

## How to Run Tests

- **Run All Tests**:
  ```bash
  flutter test
  ```

- **Run BLoC Unit Tests**:
  ```bash
  flutter test test/task_bloc_test.dart
  ```

- **Run Repository & Local Storage Unit Tests**:
  ```bash
  flutter test test/task_repository_test.dart
  ```

- **Run Widget Smoke Tests**:
  ```bash
  flutter test test/widget_test.dart
  ```

---

## Key Architecture & Features

- **Offline Caching**: Automatically saves fetched visits to `SharedPreferences`. If offline or server calls fail, data is read from local storage seamlessly.
- **Optimistic UI Updates**: Toggling visit checkboxes reflects immediately (`pending` status), with background sync to `FlakyTaskApi`.
- **Error Handling**: Failed sync attempts mark tasks as `'not saved retry'` and present a floating red `AppSnackBar` displaying `"Couldn't update site visit #id"` with a direct **Retry** button.
- **Dynamic Unsynced Counter**: App bar displays real-time unsynced task counts (e.g., `"1 unsynced"`).
- **Search & Empty State**: Search maintains text during focus shifts and displays `'No visit match "$query"'` when no matching visits are found.
