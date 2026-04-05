# Architecture Learning

This project is a small Flutter interview-prep app built with `GetX`, a feature-first MVVM structure, real JWT login, and authenticated API calls through one shared client.

Flow:
- Login with a real auth endpoint
- Save JWT securely
- Fetch users through a shared API client
- Create user
- Edit user
- Delete user
- Logout and clear token

Demo credentials:
- `emilys`
- `emilyspass`

API used:
- `https://dummyjson.com`

## Project Structure

```text
lib/
  main.dart
  app/
    app.dart
    bindings/
    routes/
  core/
    constants/
    network/
    utils/
  features/
    auth/
      bindings/
      controllers/
      pages/
      repositories/
      widgets/
    users/
      bindings/
      controllers/
      models/
      pages/
      repositories/
      widgets/
```

What each part does:
- `app`: app startup, global binding, routes
- `core/constants`: base URL and endpoints
- `core/network`: shared HTTP client and token storage
- `core/utils`: validators
- `features/auth`: login feature
- `features/users`: users list and CRUD feature

## Architecture Idea

This app uses a simple feature-first MVVM structure:

- View = page/widgets
- ViewModel = GetX controller
- Model/Data = feature repository + models

Main runtime flow:

`Page -> Controller -> Repository -> RepositoryImpl -> ApiClient`

That is the main thing to explain in an interview.

## How Login Works

1. User enters username and password on the login page.
2. `LoginController` validates the form and calls `AuthRepository`.
3. `AuthRepositoryImpl` calls the login API through `ApiClient`.
4. Login response returns JWT tokens.
5. `AuthStorage` saves the token securely.
6. Controller navigates to the users screen.

## How Authenticated API Calls Work

This is the most important shared design in the project:

- token is saved once after login
- all later API calls go through `ApiClient`
- `ApiClient` reads token from `AuthStorage`
- `ApiClient` automatically adds:

```http
Authorization: Bearer <token>
```

So feature repositories do not repeat token logic.

That means:
- `UserRepositoryImpl` only asks for data
- `ApiClient` handles headers, base URL, JSON, and error parsing

## Why This Is Easy To Explain

This structure is smaller than full clean architecture, but still shows good separation:

- page only handles UI
- controller only handles screen state and actions
- repository only handles feature data logic
- shared API client only handles networking and auth header injection

This is a good interview answer because it is practical, workable, and easy to scale later.

## SOLID In This Project

Single Responsibility Principle:
- page renders UI
- controller manages state
- repository handles feature data operations
- API client handles networking
- auth storage handles token persistence

Open/Closed Principle:
- repository implementations can be replaced later without changing page/controller code

Liskov Substitution Principle:
- feature code depends on repository contracts, not only one concrete implementation

Interface Segregation Principle:
- auth and users are split into separate repositories

Dependency Inversion Principle:
- controllers depend on repository abstractions
- repositories depend on shared API/storage services

## Build Runner

`UserModel` uses `json_serializable` and generates:

- `lib/features/users/models/user_model.g.dart`

Regenerate with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Interview Explanation

A short explanation you can use:

"I used feature-first MVVM with GetX. Each feature has its own page, controller, binding, repository, and model. Login saves the JWT in secure storage. All later API calls go through one shared API client, which automatically injects the bearer token. This keeps controllers thin, avoids repeating networking logic, and is easier to scale later."

## Interview Prep Pack

For a full project-based interview study guide with OOP, SOLID, Q&A, and mock interview practice, see:

- `INTERVIEW_PREP.md`

## Running The Project

```bash
flutter pub get
flutter run
```

## Verification

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```
