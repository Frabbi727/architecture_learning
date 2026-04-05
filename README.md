# Architecture Learning

This project is a small Flutter interview-prep app built with `GetX` and a simple MVVM structure.

Flow:
- Login with mock API
- Show user list
- Create user
- Edit user
- Delete user
- Logout

Demo credentials:
- `interview@demo.com`
- `password123`

## Project Structure

```text
lib/
  main.dart
  app/
  core/
  data/
  domain/
  presentation/
```

What each layer does:
- `app`: app setup, routes, bindings
- `core`: shared result type, errors, validators, constants
- `domain`: entities, repository contracts, use cases
- `data`: mock data sources, models, repository implementations
- `presentation`: pages, widgets, GetX controllers

## Why This Is MVVM

In this project:
- View = Flutter page and widgets
- ViewModel = GetX controller
- Model = domain entities plus use cases and repositories

Examples:
- View: login page, users page
- ViewModel: `LoginController`, `UsersController`
- Model side: `User`, `AuthSession`, `LoginUseCase`, `UserRepository`

Important rule:
- The view should only render UI and forward events.
- The controller should manage screen state and call use cases.
- The controller should not talk directly to API classes.

## How Data Flows

Login flow:
1. User taps login in the view.
2. `LoginController` validates form input.
3. Controller calls `LoginUseCase`.
4. Use case calls `AuthRepository`.
5. Repository calls mock auth data source.
6. Result comes back as success or failure.
7. Controller updates loading/error state and navigates on success.

User list flow:
1. `UsersController` loads users.
2. Controller calls `GetUsersUseCase`.
3. Use case calls `UserRepository`.
4. Repository gets data from mock user data source.
5. Controller exposes `users`, `isLoading`, and `errorMessage` to the UI.

## SOLID In This Project

Single Responsibility Principle:
- Controller manages presentation state.
- Use case handles one business action.
- Repository abstracts data access.
- Data source simulates API behavior.

Open/Closed Principle:
- You can replace the mock repository or data source with a real API implementation without changing the UI flow.

Liskov Substitution Principle:
- `AuthRepository` and `UserRepository` are contracts.
- Any correct implementation can replace the current one.

Interface Segregation Principle:
- Auth and user operations are split into separate repository interfaces.
- Consumers only depend on what they need.

Dependency Inversion Principle:
- Controllers depend on use cases.
- Use cases depend on repository contracts.
- High-level code does not depend on concrete data-source classes.

## OOP Concepts Used

Encapsulation:
- Logic is grouped inside repository, use case, and controller classes.

Abstraction:
- Repositories expose contracts, not implementation details.

Inheritance:
- Controllers extend `GetxController`.

Polymorphism:
- Repository implementations can be swapped behind the same interface.

## Best Practice vs Bad Practice

Bad practice:
- Put validation, API calls, navigation, mapping, and business rules all inside one large GetX controller.

Better practice:
- Keep controller focused on UI state.
- Move business actions into use cases.
- Put data access behind repository interfaces.
- Keep mock or remote logic in data sources.

Bad practice:
- Let widgets call repositories directly.

Better practice:
- Widgets trigger controller methods only.

Bad practice:
- Return raw exceptions everywhere.

Better practice:
- Return a simple `Result<T>` with success/failure so UI state is easier to manage.

## Interview Questions You Can Expect

What is MVVM?
- MVVM separates UI, UI state/interaction logic, and business/data logic so code is easier to test and maintain.

Why use a repository?
- It hides where data comes from and lets us swap mock, local, or remote implementations without changing higher layers.

Why use use cases?
- They keep business actions explicit and stop controllers from becoming too large.

Why not call the API directly from the controller?
- That couples presentation to data access and makes testing and future change harder.

What does GetX do here?
- Routing, dependency registration, and reactive UI state.
- It is not used as the whole architecture.

How would you scale this?
- Add more features under the same layers.
- Keep one controller per screen or feature.
- Add local cache or real API implementations behind repository interfaces.

## How To Explain This In Interview

A simple way to explain:

"I kept the app small but layered. The UI is in presentation, business actions are in use cases, contracts are in domain, and implementations are in data. GetX handles state, routing, and DI, but the controller stays thin. That gives me better separation of concerns, testability, and easier replacement of mock data with real APIs."

## Running The Project

```bash
flutter pub get
flutter run
```

## Running Verification

```bash
flutter analyze
flutter test
```
