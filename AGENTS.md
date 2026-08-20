# AGENTS.md

Operational guidance for AI coding agents working on this codebase.

## Project Overview

SCMP Staff Management App — a Flutter application with a Login screen and a Staff Directory, built with **Clean Architecture** and feature-first organization. Features are strictly split into `domain`, `data`, and `presentation` layers with no cross-feature dependencies. Repositories throw plain `Exception`s on failure, which are caught by BLoCs via standard `try-catch` blocks.

## Architecture & Directory Structure

```text
lib/
├── core/
│   ├── constants/     # API endpoints, string constants, regex patterns, validators
│   ├── network/       # ApiClient wrapper (http + timeout + x-api-key header)
│   ├── router/        # AppRoutes (path constants) + AppRouter (go_router + guard)
│   └── theme/         # AppColors + AppTheme
├── di/
│   └── injection.dart # get_it registry + useMock switch
├── features/
│   ├── auth/
│   │   ├── data/          # Models, data sources (Mock/Http), TokenLocalDataSource, repo impl
│   │   ├── domain/        # AuthToken entity, AuthRepository interface
│   │   └── presentation/  # AuthBloc, events, states, LoginPage, CustomErrorDialog
│   └── staff/
│       ├── data/          # UserModel, data sources (Mock/Http), StaffRepositoryImpl
│       ├── domain/        # User + UserPage entities, StaffRepository interface
│       └── presentation/  # StaffBloc, events, states, pages, widgets
└── main.dart         # Entry point: dotenv load + DI + runApp
```

## Key Dependencies

- `flutter_bloc` + `equatable` — state management and equality
- `go_router` — declarative routing and route guards
- `get_it` — dependency injection service locator
- `http` — REST API communication
- `shared_preferences` — auth token persistence
- `cached_network_image` — avatar loading/caching with placeholders
- `flutter_dotenv` — environment variable loading

Dev dependencies: `bloc_test`, `mocktail`, `flutter_lints`.

## Development Phases

This project was built incrementally; each phase ended with `flutter analyze` and `flutter test` passing before the next began:

- **Phase 0** — Requirements normalization + `PLAN.md` generation.
- **Phase 1** — Domain entities + data layer (repositories, mock data sources, repository tests).
- **Phase 2** — BLoC state management + UI screens + `go_router` navigation + BLoC tests.
- **Phase 3** — Real API integration, error handling/retry, shimmer, and image caching.
- **Phase 4** — CI/CD + documentation (README, AGENTS.md, GitHub Actions).

## How to Switch Between Mock and Real API

- Location: `lib/di/injection.dart`
- Toggle the `useMock` boolean flag:

```dart
const bool useMock = true;   // mock data sources
const bool useMock = false;  // real HTTP API
```

The flag controls which data source (`MockAuthDataSource`/`HttpAuthDataSource`, `MockStaffDataSource`/`HttpStaffDataSource`) is registered in `get_it`. Repositories and BLoCs remain agnostic of the strategy.

## Environment Variables

- Requires a `.env` file in the project root (same directory as `pubspec.yaml`):

```dotenv
REQRES_API_KEY=your_api_key_here
```

- Loaded via `flutter_dotenv` in `main.dart` (`await dotenv.load()`).
- `.env` is registered under `flutter: assets:` in `pubspec.yaml` and is git-ignored.
- The `x-api-key` header is injected by `lib/core/network/api_client.dart` from `dotenv.env['REQRES_API_KEY']`.

## Testing

Run all tests:

```bash
flutter test
```

Implemented tests:

- `test/auth_repository_test.dart` — AuthRepository success/exception paths (mocktail)
- `test/staff_repository_test.dart` — StaffRepository success/exception paths (mocktail)
- `test/auth_bloc_test.dart` — AuthBloc state transitions (loading/success/failure/logout)
- `test/staff_bloc_test.dart` — StaffBloc initial load + pagination append
- `test/validators_test.dart` — email/password validation

Run static analysis:

```bash
flutter analyze
```

## Human-in-the-Loop Checkpoints

Each phase required **manual validation** before proceeding to the next. Always run both `flutter analyze` (must report no issues) and `flutter test` (all tests must pass) at the end of every phase, and pause for human review before starting subsequent work. Do not modify code outside the current phase's agreed scope; flag any deviations explicitly.
