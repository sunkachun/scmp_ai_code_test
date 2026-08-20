# SCMP Staff Management App — Technical Blueprint

This document reflects the **actual final implementation** of the project as verified against the codebase.

---

## 1. Architecture Topology & Directory Structure

The project follows **Clean Architecture** with feature-first organization. Code is strictly split into **Domain**, **Data**, and **Presentation** layers with zero cross-feature dependencies.

```text
lib/
├── core/
│   ├── constants/     # AppConstants (endpoints, regex) + Validators
│   ├── network/       # ApiClient wrapper (http + timeout + x-api-key header)
│   ├── router/        # AppRoutes (path constants) + AppRouter (go_router + guard)
│   └── theme/         # AppColors + AppTheme
├── di/
│   └── injection.dart # get_it registry + useMock switch
├── features/
│   ├── auth/
│   │   ├── data/          # LoginResponseModel, data sources (Mock/Http), TokenLocalDataSource, AuthRepositoryImpl
│   │   ├── domain/        # AuthToken entity, AuthRepository interface
│   │   └── presentation/  # AuthBloc, events, states, LoginPage, CustomErrorDialog
│   └── staff/
│       ├── data/          # UserModel, data sources (Mock/Http), StaffRepositoryImpl
│       ├── domain/        # User + UserPage entities, StaffRepository interface
│       └── presentation/  # StaffBloc, events, states, pages, widgets
└── main.dart         # Entry point: dotenv load + DI + runApp
```

**Error propagation model:** repositories throw plain `Exception`s on failure (no `Either`/`Result` wrapper). BLoCs catch these via standard `try-catch` blocks and translate them into typed failure states.

---

## 2. Core Dependencies & Configuration

| Package | Purpose |
| --- | --- |
| `flutter_bloc` + `equatable` | State management and state equality |
| `get_it` | Dependency injection service locator |
| `go_router` | Declarative routing and route guards |
| `http` | REST API communication |
| `shared_preferences` | Auth token persistence |
| `cached_network_image` | Avatar loading/caching with placeholders |
| `flutter_dotenv` | Environment variable loading |
| `shimmer` | Skeleton loading for the staff list |

Dev dependencies: `bloc_test`, `mocktail`, `flutter_lints`.

### Source Switcher (`lib/di/injection.dart`)

```dart
const bool useMock = false; // true = mock data sources, false = real HTTP API

void setupDependencies() {
  if (useMock) {
    getIt.registerLazySingleton<AuthRemoteDataSource>(() => MockAuthDataSource());
    getIt.registerLazySingleton<StaffRemoteDataSource>(() => MockStaffDataSource());
  } else {
    getIt.registerLazySingleton<AuthRemoteDataSource>(() => HttpAuthDataSource(getIt()));
    getIt.registerLazySingleton<StaffRemoteDataSource>(() => HttpStaffDataSource(getIt()));
  }
  // Repositories and BLoCs are registered agnostic of the data source strategy.
}
```

---

## 3. Key Design Decisions

- **Login navigation uses `context.push('/staff')` (not `go`).** This keeps the Login page in the navigation stack so the system back button returns to Login instead of exiting the app. The AppBar back arrow on Staff is the default one (no custom `leading`, no `SystemNavigator.pop()`).

- **Route guard prevents redirect loops.** The `go_router` redirect only sends the user to `/login` when the matched location starts with `/staff` **and** no token is stored. It never redirects `/login` → `/staff` (login navigation is handled explicitly by the BLoC's `push`).

- **Auto-pagination on scroll (NO "Load More" button).** A `ScrollController` listener triggers `FetchNextPage` when the user scrolls near the bottom (`pixels >= maxScrollExtent - 50`). Additionally, a `WidgetsBinding.instance.addPostFrameCallback` fires `FetchNextPage` when the initial list fits the screen (`hasMore && maxScrollExtent <= 0`), covering the case where the first page does not overflow. The `StaffBloc` guards against duplicate/concurrent fetch events with a synchronous in-flight flag. A `CircularProgressIndicator` footer appears at the bottom while `isLoadingMore` is active.

- **Custom error dialog with exact text.** The login failure dialog is a floating `Container` (not a Material `AlertDialog`) with rounded corners and shadow, displaying the exact spec string `"Error: Invalid crdentials"` — the typo (`crdentials`) is intentionally preserved.

- **Password validation.** Password uses the exact regex `r'^[A-Za-z\d]{6,10}$'` (alphanumeric, 6–10 characters). Email uses a standard RFC 5322-style pattern.

- **Avatar placeholder logic.** Avatars use `CachedNetworkImage` layered over a placeholder circle. `index % 6 < 3` renders a **solid** black circle; `index % 6 >= 3` renders a **hollow** (border-only) black circle. A `person` icon is used as the error fallback.

- **API key via environment variables.** The `x-api-key` header is injected by `ApiClient` from the `.env` file, loaded by `flutter_dotenv` in `main.dart`. The code reads the key from `dotenv.env['API_KEY']`.

---

## 4. Implementation Phases

The project was built incrementally; each phase ended with `flutter analyze` (no issues) and `flutter test` (all passing) before the next began.

- **Phase 0 — Master Plan generation.** Requirements normalized into `PLAN.md`.
- **Phase 1 — Domain entities + Data layer.** Entities (`AuthToken`, `User`, `UserPage`), repository interfaces, mock data sources, repository implementations, and unit tests for repositories.
- **Phase 2 — BLoC state management + UI + go_router.** `AuthBloc`/`StaffBloc`, login/staff pages, custom dialog, declarative routing with `push` navigation, and BLoC tests.
- **Phase 3 — Real API integration + error handling + image caching.** Shimmer skeleton loading, `CachedNetworkImage` fallbacks, error/retry UI, auto-pagination (with the fit-on-screen fix), and the pagination loading indicator.
- **Phase 4 — CI/CD + Documentation.** GitHub Actions workflow (with dummy `.env` creation), `README.md`, and `AGENTS.md`.

---

## 5. Security & CI Notes

- The `.env` file is **git-ignored** and never committed.
- CI (`.github/workflows/ci.yml`) creates a **dummy `.env`** before `flutter analyze`/`flutter test` so the `flutter: assets` check passes without exposing secrets and without triggering an `asset_does_not_exist` error.
- For production, do **not** ship the API key in the client bundle — route requests through a **backend proxy** that injects the key server-side.
