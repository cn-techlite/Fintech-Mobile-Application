# Koins Savings

Koins Savings is a responsive Flutter savings application built for the Koins MFB Flutter Developer Technical Assessment. It demonstrates mock authentication, savings-product discovery, savings-plan creation, local persistence, REST API integration, Riverpod state management, reusable UI components, responsive layouts, and automated testing.

## Quick reference

| Item | Value |
|---|---|
| Flutter | 3.47.5 stable |
| Dart | 3.13.4 |
| State management | Riverpod 3 |
| Local storage | SharedPreferences |
| API | JSONPlaceholder |
| UI | Material 3 |
| Demo email | `test@bank.com` |
| Demo password | `Password123` |

## Implemented user flows

### Authentication

- Validated email and password fields.
- Email-required and valid-email checks.
- Password-required and minimum-eight-character checks.
- Mock authentication using the supplied assessment credentials.
- Loading and failure feedback during login.
- Authentication failures are shown in a styled floating error snackbar.
- Persisted authenticated session across application restarts.
- Animated transition between the login and authenticated application shell.
- Confirmed logout flow that returns the user to Login.
- Forgot Password and Register are intentionally non-functional, as required.

### Dashboard

- Personalized `Good Morning, John Doe` greeting.
- Total savings summary of `₦850,000`.
- Create Savings and View Products quick actions.
- Three recent savings plans with amount and monthly frequency.
- Newly created plans appear before the mock plans.
- Savings Insights loaded from JSONPlaceholder.
- Pull to refresh for the remote insights.
- Separate loading, empty, retry, and error states.

### Savings products and details

- Four assessment products: Target Savings, Fixed Deposit, Education Savings, and Vacation Savings.
- Product name, interest rate, duration, and short description.
- Search by product name or description.
- Filters for all products, products with at least 10% interest, and flexible products.
- Empty search-results state.
- Details screen with interest rate, minimum deposit, duration, and Create Savings action.

### Create savings

- Savings name, product type, target amount, monthly contribution, and duration fields.
- Product and duration dropdowns.
- Required-field and positive-amount validation.
- Monthly contribution cannot exceed the target amount.
- Amounts receive thousands separators while typing, for example `1000` becomes `1,000`.
- Comma-formatted pasted values and up to two decimal places are supported.
- Successful plans are persisted locally and the user is returned to Dashboard.
- Failed persistence attempts expose an error and can be retried safely.
- Submission success and failure use styled, dismissible status snackbars.

### Profile

- Full name, email address, and phone number.
- Logout confirmation dialog.
- Logout removes the persisted user session but deliberately keeps locally created savings plans.

## Bonus features

The following optional assessment features are implemented:

- Pull to refresh.
- Search savings products.
- Filter savings products.
- Authentication transition animation.
- Unit tests.
- Provider tests.
- Widget tests.
- Golden screenshot tests.

## Architecture

The project uses the layer-based structure requested in the assessment:

```text
lib/
├── core/          # Application root, constants, and Material theme
├── models/        # Application data models and serialization
├── services/      # API, mock authentication, and local storage adapters
├── repositories/  # Data-source coordination and product catalogue
├── screens/       # Screens and authenticated navigation shell
├── widgets/       # Reusable presentation components
├── utils/         # Validation, formatting, and responsive sizing
├── providers/     # Riverpod state and dependency providers
└── main.dart      # Application bootstrap
```

The main data flow is:

```text
Screen / Widget
      ↓ watches or invokes
Riverpod Provider / Controller
      ↓ coordinates
Repository
      ↓ delegates to
Service
      ↓
SharedPreferences or REST API
```

### Layer responsibilities

| Layer | Responsibility |
|---|---|
| Screens and widgets | Render state, collect input, and dispatch user actions |
| Providers | Own UI-facing state and asynchronous transitions |
| Repositories | Coordinate services and expose application-oriented data operations |
| Services | Perform mock authentication, HTTP requests, and local persistence |
| Models | Represent users, products, plans, and API tips |
| Core and utils | Provide theme, constants, validation, formatting, and responsiveness |

Controllers currently depend directly on repository providers because each operation maps to one repository command and has little cross-feature business logic. A separate use-case layer would become useful when rules coordinate multiple repositories or need independent reuse.

## Riverpod state management

Riverpod was selected because it provides compile-safe dependency injection, testable state, automatic lifecycle management, and no dependency on `BuildContext`.

Provider types are chosen according to their responsibility:

| Provider | Type | Reason |
|---|---|---|
| Authentication | `AsyncNotifierProvider` | Login and logout have meaningful loading, data, and error states |
| Savings | `AsyncNotifierProvider` | Plan persistence is asynchronous and can fail or be retried |
| Savings insights | `FutureProvider` | The API integration is a read-only request with refresh support |
| Navigation index | `NotifierProvider` | Tab selection is synchronous and cannot fail |
| Services and repositories | `Provider` | These are injectable dependencies rather than mutable UI state |

This selective approach avoids forcing meaningless loading and error handling onto synchronous state.

## Local persistence

SharedPreferences was selected from the assessment's allowed options because the persisted data is small and key-value shaped. Adding Hive or SQLite as a second database would increase complexity without improving this use case.

| Key | Stored value |
|---|---|
| `logged_in_user` | JSON representation of the authenticated user |
| `created_savings_plans` | JSON list of user-created savings plans |

Created plans survive application restarts and logout. Uninstalling the app or clearing its application data removes them.

## REST API and error handling

The dashboard requests three posts from JSONPlaceholder and presents them as Savings Insights:

```text
https://jsonplaceholder.typicode.com/posts?_limit=3
```

The HTTP client is injected through Riverpod and closed automatically. Requests use a ten-second timeout. Non-success status codes, connectivity problems, invalid responses, and unexpected exceptions are converted into user-facing error states with retry support. Android internet permission is declared in the application manifest.

Authentication and savings persistence also expose loading and error states through `AsyncValue`. Savings persistence retains the last successful state internally so users can retry after a failed write.

## Responsive UI and shared components

`SizeConfig` is initialized at the application root and refreshed from `MediaQuery`. It provides adaptive page gutters, content-width limits, clamped logical-pixel scaling, safe-area percentages, and text sizing.

| Layout | Width |
|---|---|
| Mobile | Less than 600 logical pixels |
| Tablet | 600 to 839 logical pixels |
| Desktop/wide | 840 logical pixels and above |

Compact layouts use a bottom navigation bar. Wide layouts switch to `NavigationRail`. Forms and content remain constrained to readable widths on larger displays.

At 700 logical pixels and above, information-heavy screens use the available
tablet space more deliberately: Savings Products changes to a two-column grid,
and Dashboard balances its summary, quick actions, recent savings, and insights
across two columns. Focused flows such as Login, Profile, Savings Details, and
Create Savings stay centered at a readable form width. Both portrait and
landscape iPad layouts are covered by overflow tests.

Reusable presentation components include:

- `AppText` for application typography.
- `AppButton` and `AppIconButton` for consistent actions.
- `AppTextField` for forms.
- `AppSnackBar` for consistent success, error, and informational feedback.
- Summary, product, savings-plan, quick-action, and section-header widgets.
- Shared loading, empty, and error-state widgets.
- `CurrencyInputFormatter` for comma-formatted amount entry.

## Getting started

### Requirements

- Flutter 3.47.5 stable.
- Dart 3.13.4.
- Android Studio or Xcode for the relevant platform.
- An emulator, simulator, or physical device.

### Install and run

```bash
flutter pub get
flutter run
```

If FVM is installed, the equivalent commands are:

```bash
fvm flutter pub get
fvm flutter run
```

Log in with:

```text
Email: test@bank.com
Password: Password123
```

## Quality checks and tests

Run static analysis and the full test suite:

```bash
fvm flutter analyze
fvm flutter test
```

The test suite covers:

- Email, password, and amount validation.
- Thousands-separator amount formatting.
- Authentication `AsyncNotifier` transitions.
- Savings persistence and retry after a simulated storage failure.
- Mobile, tablet, and desktop `SizeConfig` behavior.
- Portrait and landscape iPad layouts across all application screens.
- Login-form validation.
- Styled snackbar feedback for failed authentication.
- Logout without transient null-user exceptions.
- Optional golden screenshots for Login, Dashboard, Products, and Profile.

Review all regenerated images before accepting the update.

## Build and APK delivery

Build the release APK with:

```bash
fvm flutter build apk --release
```

The generated artifact is written to:

```text
build/app/outputs/flutter-apk/app-release.apk
```

The `build/` directory is intentionally Git-ignored. Submit the APK separately or attach it to a GitHub Release; it will not be included in a normal source commit.

The assessment build uses the standard Flutter debug signing configuration for the release variant. Production distribution would require a private release keystore and secure signing configuration.

## Packages

| Package | Purpose |
|---|---|
| `flutter_riverpod` | State management and dependency injection |
| `shared_preferences` | Persisted user and savings-plan storage |
| `http` | REST API client |
| `email_validator` | Email-format validation |
| `intl` | Nigerian naira formatting |
| `flutter_lints` | Static-analysis rules |
| `flutter_test` | Unit, provider, widget, and golden tests |

## Assessment coverage

| Requirement | Implementation |
|---|---|
| Login and validation | Mock login with required-field, email, and password validation |
| Dashboard | Greeting, total savings, quick actions, and three recent plans |
| Products | Four products with interest, duration, descriptions, search, and filtering |
| Details | Rate, minimum deposit, duration, and Create Savings action |
| Create savings | Validated form, local persistence, success feedback, and dashboard return |
| Profile | User details, confirmation dialog, and logout |
| API | JSONPlaceholder Savings Insights with loading, empty, error, retry, and refresh |
| Material 3 UI | Responsive theme, consistent typography, icons, and reusable components |
| Architecture | Requested folders with provider, repository, and service separation |
| Local storage | Persisted logged-in user and created savings plans |
| Deliverables | README, screenshots, tests, and locally generated APK |

## Assumptions and limitations

- Authentication is intentionally mocked and accepts only the assessment credentials.
- No password or authentication token is stored because there is no real backend session.
- Forgot Password and Register are intentionally non-functional.
- The dashboard balance and initial savings plans are mock data.
- Created savings plans are local to the device and are not synchronized to a server.
- JSONPlaceholder posts are labelled as Savings Insights solely to demonstrate REST integration.
- SharedPreferences is appropriate for this small assessment dataset but is not encrypted financial storage.
- Production signing, analytics, push notifications, biometrics, and PIN login are outside the implemented scope.

## Improvements with more time

- Integrate a production authentication and savings API.
- Store tokens in platform-backed secure storage.
- Move growing or relational savings data to encrypted structured storage.
- Add biometric or PIN login.
- Add pagination and offline caching for remote content.
- Add CI for analysis, tests, and reproducible release builds.
- Add production signing and GitHub Release automation.
- Consider a feature-first structure when the number of independent features grows.
