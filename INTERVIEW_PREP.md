# Project-Based Interview Prep

This guide uses the actual code in this project so you can explain OOP, SOLID, dependency injection, and testing from your own app instead of from generic examples.

## Part 1: Project Notes

### 1. Project Overview

This project is a Flutter app built with `GetX` and a feature-first MVVM structure.

Main flow:

`Page -> Controller -> Repository -> RepositoryImpl -> ApiClient`

What each layer does:

- `Page`: renders UI and forwards user actions
- `Controller`: manages screen state and coordinates actions
- `Repository`: defines the feature contract
- `RepositoryImpl`: performs real data operations
- `ApiClient`: handles networking, parsing, auth header injection, and error mapping

Code examples:

- `LoginPage` and `UsersPage` are the UI layer.
- `LoginController` and `UsersController` manage state and actions.
- `AuthRepository` and `UserRepository` are abstraction layers.
- `AuthRepositoryImpl` and `UserRepositoryImpl` talk to `ApiClient`.
- `AuthStorage` stores JWT and refresh tokens.

Interview-ready answer:

"I used a feature-first MVVM structure with GetX. Pages handle UI, controllers handle state and actions, repositories define data contracts, repository implementations handle feature data logic, and a shared API client manages HTTP calls and JWT header injection."

### 2. How the App Works

#### Login flow

1. User enters credentials in `LoginPage`.
2. `LoginController` validates the form and calls `AuthRepository.login()`.
3. `AuthRepositoryImpl` sends the request through `ApiClient`.
4. If login succeeds, `AuthStorage` saves the access token and refresh token.
5. Controller navigates to the users page.

Interview-ready answer:

"Login starts from the UI, then the controller validates input and delegates the API call to the repository. The repository stores the JWT through `AuthStorage`, and later requests reuse that token automatically through the shared API client."

#### Authenticated API flow

1. User opens `UsersPage`.
2. `UsersController.onInit()` calls `fetchUsers()`.
3. `UserRepositoryImpl` requests data through `ApiClient`.
4. `_AuthInterceptor` inside `ApiClient` reads the token from `AuthStorage`.
5. `ApiClient` injects `Authorization: Bearer <token>` automatically.
6. Parsed users are returned to the controller and exposed to the page through reactive state.

Interview-ready answer:

"After login, token management is centralized. Feature repositories do not manually add headers because the `ApiClient` interceptor reads the token from secure storage and injects the bearer token for authenticated requests."

### 3. OOP Concepts From This Project

#### Class and object

A class is a blueprint and an object is a real instance.

Examples in this project:

- `LoginController`, `UsersController`, `ApiClient`, and `AuthStorage` are classes.
- GetX creates and provides their objects at runtime through bindings.

#### Encapsulation

Encapsulation means keeping related behavior and internal details together.

Project example:

- `ApiClient` hides Dio setup, interceptors, response parsing, and error mapping.
- `AuthStorage` hides secure storage key names and token persistence details.

Why it matters:

- controllers and repositories do not need to know low-level HTTP details
- token keys and storage logic stay in one place

Interview-ready answer:

"I used encapsulation by putting networking concerns inside `ApiClient` and token persistence inside `AuthStorage`. Other layers use those classes without knowing their internal implementation."

#### Abstraction

Abstraction means exposing only what a caller needs, while hiding implementation details.

Project example:

- `AuthRepository` exposes `login()` and `logout()`.
- `UserRepository` exposes `fetchUsers()`, `createUser()`, `updateUser()`, `deleteUser()`, and `logout()`.
- Controllers depend on those contracts, not on raw Dio calls.

Why it matters:

- controller code stays clean
- implementations can change without changing controller logic

Interview-ready answer:

"The controllers depend on repository interfaces instead of implementation details. That means the UI layer only knows what operation it needs, not how the data is fetched or stored."

#### Inheritance

This project uses inheritance lightly and mostly where the framework already expects it.

Project examples:

- `LoginController extends GetxController`
- `UsersController extends GetxController`
- `AuthBinding extends Bindings`
- `UsersBinding extends Bindings`
- `LoginPage extends GetView<LoginController>`
- `UsersPage extends GetView<UsersController>`

Interview-ready answer:

"I use inheritance mainly for framework integration, like extending `GetxController`, `Bindings`, and `GetView`. For business logic, I prefer composition and interfaces instead of building deep class hierarchies."

#### Polymorphism

Polymorphism means different classes can be used through the same contract.

Project examples:

- `LoginController` can work with `AuthRepositoryImpl` in production.
- `LoginController` can also work with `_FailingAuthRepository` in tests.
- `UsersController` can work with `UserRepositoryImpl` in production.
- `UsersController` can also work with `_FakeUserRepository` in tests.

Why it matters:

- the same controller logic works with real and fake implementations
- testing becomes simpler and isolated

Interview-ready answer:

"I used polymorphism through repository contracts. The same controller can work with real implementations in production and fake implementations in tests, as long as they follow the same repository interface."

### 4. Composition vs Inheritance

This project is a strong example of preferring composition over inheritance for business logic.

Composition means one class uses another class to do its work.

Project examples:

- `LoginController` has an `AuthRepository`
- `UsersController` has a `UserRepository`
- `AuthRepositoryImpl` has an `ApiClient` and `AuthStorage`
- `UserRepositoryImpl` has an `ApiClient` and `AuthStorage`

Why this is good:

- easy to replace dependencies
- easy to test with fakes
- less tight coupling
- easier to maintain than deep inheritance chains

Interview-ready answer:

"I preferred composition over inheritance. For example, `LoginController` does not inherit login behavior; it receives an `AuthRepository`. `AuthRepositoryImpl` also receives `ApiClient` and `AuthStorage`. This makes the architecture more flexible, easier to test, and less tightly coupled."

### 5. SOLID From This Project

#### Single Responsibility Principle

A class should have one reason to change.

Examples:

- `LoginPage` and `UsersPage` handle UI
- `LoginController` and `UsersController` handle screen state and actions
- `AuthRepositoryImpl` and `UserRepositoryImpl` handle feature data logic
- `ApiClient` handles networking
- `AuthStorage` handles token persistence

Interview-ready answer:

"The project follows SRP by separating UI, controller logic, data access, networking, and storage into different classes."

#### Open/Closed Principle

Software should be open for extension and closed for modification.

Project example:

- controllers depend on `AuthRepository` and `UserRepository`, not on concrete classes
- you can add another implementation later without changing controller code

Example extension:

- replace network repository with a mock, cached, or offline-first repository

Interview-ready answer:

"Because controllers depend on repository abstractions, I can extend behavior by adding new repository implementations without modifying the controller layer."

#### Liskov Substitution Principle

Subtypes should be usable wherever the base abstraction is expected.

Project examples from tests:

- `_FailingAuthRepository` can be used instead of `AuthRepositoryImpl`
- `_FakeUserRepository` can be used instead of `UserRepositoryImpl`

Why it matters:

- controller behavior remains valid when implementation changes

Interview-ready answer:

"The tests show LSP clearly. Fake repositories can replace real repository implementations without breaking controller behavior because they respect the same contract."

#### Interface Segregation Principle

Clients should not depend on methods they do not use.

Project examples:

- `AuthRepository` is focused only on auth use cases
- `UserRepository` is focused only on user use cases

Why it matters:

- no large all-purpose repository interface
- each feature depends only on its own methods

Interview-ready answer:

"I kept repository interfaces focused by feature. The auth layer and users layer have separate contracts, so classes only depend on the methods they actually need."

#### Dependency Inversion Principle

High-level modules should depend on abstractions, not concrete implementations.

Project examples:

- `LoginController` depends on `AuthRepository`
- `UsersController` depends on `UserRepository`
- GetX bindings provide `AuthRepositoryImpl` and `UserRepositoryImpl`
- `AppBinding` provides shared services like `ApiClient` and `AuthStorage`

Interview-ready answer:

"The controllers are high-level modules, and they depend on repository abstractions. The actual implementations are provided through dependency injection in GetX bindings."

### 6. Why the Shared ApiClient Is Important

`ApiClient` is one of the strongest design points in this project.

It centralizes:

- base URL
- timeouts
- content type headers
- request methods
- response parsing
- error normalization
- auth token injection
- request and response logging

Benefits:

- no repeated networking code in each feature
- consistent error handling
- easier maintenance
- one place to improve HTTP behavior later

Interview-ready answer:

"Instead of repeating networking logic in every repository, I centralized that logic in `ApiClient`. This keeps repositories small and gives the whole app a consistent way to handle requests, errors, and auth headers."

### 7. Dependency Injection in This Project

GetX bindings assemble the object graph.

Examples:

- `AppBinding` registers `AuthStorage` and `ApiClient`
- `AuthBinding` registers `AuthRepository` and `LoginController`
- `UsersBinding` registers `UserRepository` and `UsersController`

Why it matters:

- dependencies are created in one place
- controller code stays clean
- easier to replace implementations

Interview-ready answer:

"I used GetX bindings for dependency injection. Shared services are registered globally, and feature bindings create repositories and controllers using those services."

### 8. Testing Strategy From This Project

The tests show why abstraction and composition help.

Examples:

- `login_controller_test.dart` injects `_FailingAuthRepository`
- `users_controller_test.dart` injects `_FakeUserRepository`
- `auth_repository_impl_test.dart` uses fake storage and fake API client
- `user_repository_impl_test.dart` uses a fake API client to verify parsing

What this proves:

- controller tests do not need real network calls
- repository tests can isolate parsing and data behavior
- architecture is test-friendly

Interview-ready answer:

"I structured the app so controllers and repositories can be tested independently. In tests, I replace real dependencies with fake implementations, which makes the tests faster and more focused."

## Part 2: Interview Q&A

### Q1. Tell me about your project.

Answer:

"This is a Flutter interview-prep app built with GetX and a feature-first MVVM structure. It has a real JWT login flow, secure token storage, and authenticated API calls through a shared `ApiClient`. The main features are login and users CRUD."

Better answer:

"I built it to show practical architecture. Each feature has its own page, controller, repository, and model, while shared concerns like networking and token storage are centralized."

### Q2. Why did you choose this architecture?

Answer:

"I wanted a structure that is simple enough for a small app but still demonstrates separation of concerns. The feature-first MVVM approach keeps UI, state, data access, and networking separate without adding too much complexity."

### Q3. Explain the main runtime flow of the app.

Answer:

"The main runtime flow is `Page -> Controller -> Repository -> RepositoryImpl -> ApiClient`. The page sends user actions to the controller, the controller coordinates the use case, repositories handle feature data operations, and the shared API client performs HTTP communication."

### Q4. How does login work in your app?

Answer:

"The user enters credentials on the login page, then `LoginController` validates the form and calls `AuthRepository.login()`. `AuthRepositoryImpl` sends the request through `ApiClient`, and if the call succeeds it stores the tokens through `AuthStorage` and navigates to the users page."

### Q5. How do authenticated API calls work?

Answer:

"After login, tokens are stored in secure storage. For later requests, `ApiClient` uses an auth interceptor that reads the token from `AuthStorage` and injects the bearer token automatically. This means feature repositories do not repeat token handling logic."

### Q6. Where do you use encapsulation?

Answer:

"I use encapsulation in `ApiClient` and `AuthStorage`. `ApiClient` encapsulates Dio setup, interceptors, parsing, and error handling. `AuthStorage` encapsulates secure storage access and token keys."

### Q7. Where do you use abstraction?

Answer:

"I use abstraction through `AuthRepository` and `UserRepository`. Controllers depend on those contracts instead of calling the API directly."

### Q8. Where do you use polymorphism?

Answer:

"I use polymorphism through repository interfaces. The same controller can use real repositories in production and fake repositories in tests."

### Q9. Did you use inheritance or composition more?

Answer:

"I used composition more. Controllers receive repositories, and repositories receive shared services like `ApiClient` and `AuthStorage`. I use inheritance mainly for framework classes like `GetxController` and `GetView`."

Better answer:

"For business logic I preferred composition because it keeps the code more flexible and easier to test than deep inheritance hierarchies."

### Q10. Why is composition better here?

Answer:

"Composition lets me replace dependencies easily, reduce coupling, and test classes in isolation. For example, `UsersController` can use a fake repository in tests without changing its own logic."

### Q11. Where do you apply Single Responsibility Principle?

Answer:

"Pages handle UI, controllers handle screen state, repositories handle feature data operations, `ApiClient` handles networking, and `AuthStorage` handles token persistence. Each class has a focused responsibility."

### Q12. Where do you apply Open/Closed Principle?

Answer:

"Controllers depend on repository interfaces, so I can add or swap repository implementations later without changing controller code."

### Q13. Where do you apply Liskov Substitution Principle?

Answer:

"The tests demonstrate it. Fake repositories can replace real repository implementations because they follow the same contract and the controller still works correctly."

### Q14. Where do you apply Interface Segregation Principle?

Answer:

"I separated auth and users into different repository contracts. This avoids one large interface that forces unrelated classes to depend on extra methods."

### Q15. Where do you apply Dependency Inversion Principle?

Answer:

"Controllers depend on abstractions like `AuthRepository` and `UserRepository`, while GetX bindings provide the concrete implementations."

### Q16. Why did you use the repository pattern?

Answer:

"I used the repository pattern to separate business and data access logic from the UI layer. It also makes the app easier to test and extend."

### Q17. Why not call the API directly from the controller?

Answer:

"If the controller called the API directly, UI state management and networking would be tightly coupled. That would make the code harder to maintain, reuse, and test."

### Q18. How does dependency injection help in your project?

Answer:

"Dependency injection keeps object creation out of the business logic. Bindings create and provide the required services, repositories, and controllers, so each class only focuses on its job."

### Q19. How is your project testable?

Answer:

"It is testable because controllers depend on abstractions and repositories use injectable services. That lets me provide fake implementations in tests without using the real network or secure storage."

### Q20. What would you improve if the app grows bigger?

Answer:

"If the app grows, I would likely add more domain-focused use cases, introduce local caching, and possibly separate DTOs from domain models more strictly. But the current structure is already a strong base because responsibilities are separated."

## Part 3: Mock Interview

Use this section to practice aloud. Answer each question in your own words before reading the expected points.

### Round 1: Basic Project Explanation

#### Question 1

"Tell me about your project and its architecture."

Expected answer points:

- Flutter app with GetX
- feature-first MVVM structure
- login plus users CRUD
- runtime flow: `Page -> Controller -> Repository -> RepositoryImpl -> ApiClient`
- shared `ApiClient` and `AuthStorage`

Correction if your answer is weak:

Focus on the architecture first, then mention features. Interviewers usually care more about your structure and reasoning than the UI.

#### Question 2

"Why did you choose this architecture instead of putting everything inside the page?"

Expected answer points:

- separation of concerns
- easier maintenance
- easier testing
- reusable shared networking logic

Correction if your answer is weak:

Do not say only "for clean code." Explain exactly what became separate: UI, state, data, and networking.

#### Question 3

"Explain the login flow from the UI to secure storage."

Expected answer points:

- form input in `LoginPage`
- validation in `LoginController`
- repository call
- `ApiClient` request
- token save in `AuthStorage`
- navigation to users page

### Round 2: OOP and SOLID

#### Question 4

"Where do you use encapsulation in this project?"

Expected answer points:

- `ApiClient`
- `AuthStorage`
- internal details hidden from controller and page layers

#### Question 5

"Where do you use abstraction?"

Expected answer points:

- `AuthRepository`
- `UserRepository`
- controller depends on contract instead of implementation

#### Question 6

"Give me an example of composition from your project."

Expected answer points:

- `LoginController` has an `AuthRepository`
- `AuthRepositoryImpl` has `ApiClient` and `AuthStorage`
- composition is preferred over deep inheritance for business logic

#### Question 7

"How does your project follow Single Responsibility Principle?"

Expected answer points:

- page for UI
- controller for state/actions
- repository for feature data
- `ApiClient` for network
- `AuthStorage` for token storage

#### Question 8

"Where do you apply Dependency Inversion Principle?"

Expected answer points:

- controller depends on repository abstraction
- binding injects concrete implementation

### Round 3: Deeper Follow-Up Questions

#### Question 9

"How do your tests support your architecture decisions?"

Expected answer points:

- fake repositories in controller tests
- fake API/storage in repository tests
- no need for real network
- isolated, faster tests

#### Question 10

"Why is your shared `ApiClient` a better design than making every repository handle Dio directly?"

Expected answer points:

- avoids duplication
- centralizes auth header injection
- centralizes error handling
- centralizes parsing and logging
- easier maintenance

#### Question 11

"What tradeoff did you make by choosing this architecture instead of full clean architecture?"

Expected answer points:

- simpler and easier to explain
- enough separation for a small-to-medium app
- less boilerplate
- can still scale later

#### Question 12

"If you added caching or offline support, where would that logic go?"

Expected answer points:

- repository layer
- possibly additional local data source service
- controller should stay focused on state and actions

## Final Revision Checklist

Before an interview, make sure you can say these clearly:

- project architecture in 30 seconds
- login flow in 30 seconds
- authenticated request flow in 30 seconds
- one example each for encapsulation, abstraction, polymorphism, and composition
- one example each for all five SOLID principles
- why testing is easier in this architecture
- why you chose composition over inheritance for business logic

## Part 4: Intermediate and Deep Question Pack

Use this section when you want questions that are harder than basic definitions. The goal is to train your reasoning from the real codebase, not to memorize textbook lines.

### Section 1: Intermediate Questions

#### 1. Why is the runtime flow `Page -> Controller -> Repository -> RepositoryImpl -> ApiClient` a good fit for this app?

Key points:

- each layer has a clear job
- UI stays separate from data access
- repositories keep feature logic out of pages
- `ApiClient` centralizes shared HTTP behavior
- the structure is easy to explain in interviews

#### 2. Why did you use a repository contract and a repository implementation instead of only one class?

Key points:

- contract gives abstraction to the controller
- implementation keeps HTTP details out of high-level code
- makes testing easier with fake repositories
- allows future replacement with cached or offline implementations

#### 3. Why is `ApiClient` a shared service instead of creating Dio logic inside each repository?

Key points:

- avoids repeating headers, timeouts, and parsing logic
- centralizes error handling and auth token injection
- keeps repositories focused on feature operations
- changes to networking behavior happen in one place

#### 4. Why is `AuthStorage` separated from `AuthRepositoryImpl`?

Key points:

- token persistence is a different responsibility from login orchestration
- storage can change without rewriting auth flow
- repository stays focused on auth use cases
- easier to fake storage in tests

#### 5. Explain how dependency injection works in this project.

Key points:

- `AppBinding` registers shared services like `AuthStorage` and `ApiClient`
- feature bindings register repository abstractions and controllers
- controllers receive dependencies instead of creating them
- object wiring is centralized, business logic is cleaner

#### 6. Why is composition a better choice than inheritance for your business logic here?

Key points:

- controllers use repositories instead of inheriting behavior
- repositories use services instead of extending large base classes
- easier to swap dependencies
- lower coupling and easier testing
- framework inheritance is used only where Flutter/GetX expects it

#### 7. How does this project show the Dependency Inversion Principle?

Key points:

- `LoginController` depends on `AuthRepository`, not `AuthRepositoryImpl`
- `UsersController` depends on `UserRepository`, not `UserRepositoryImpl`
- bindings provide concrete implementations
- high-level modules depend on abstractions

#### 8. How do the tests validate that your architecture is working as intended?

Key points:

- controller tests use fake repositories
- repository tests use fake API client and fake storage
- logic can be tested without real network calls
- architecture supports isolated tests

#### 9. Why is this architecture easier to maintain than putting everything inside the page?

Key points:

- page stays focused on rendering and user events
- state and data logic are separated
- fewer reasons for one file to change
- easier to locate bugs by layer

#### 10. Where would you add caching if the app needed it later?

Key points:

- repository layer is the best place to coordinate cache and API
- likely introduce a local data source service
- controller should remain unchanged or mostly unchanged
- `ApiClient` should stay focused on remote HTTP behavior

#### 11. Why is this architecture enough for this project without full clean architecture?

Key points:

- app size is still small and feature set is focused
- already has strong separation of concerns
- avoids unnecessary boilerplate
- still leaves room to scale later

#### 12. If the login API response changes, which layers should change and which should not?

Key points:

- parsing/model or repository implementation may need updates
- controller should ideally stay unchanged if contract remains the same
- page should not change if screen behavior is unchanged
- abstraction helps contain the change

### Section 2: Deep Questions

#### 1. What are the tradeoffs of returning `Resource<T>` from repositories instead of throwing exceptions upward?

Key points:

- gives controllers a consistent success/error shape
- simplifies UI state handling
- may hide error detail if over-normalized
- shifts error policy into a wrapper type
- useful here, but larger systems may need richer failure modeling

#### 2. What are the limits of this architecture if the app grows to many features and teams?

Key points:

- repository/controller pattern still helps, but boundaries may become too coarse
- may need use-case classes or domain services
- more explicit module boundaries may be needed
- DTO/domain separation may become more important
- dependency graph management may become harder over time

#### 3. Why is it valuable that `_AuthInterceptor` reads the token from `AuthStorage` instead of repositories adding headers manually?

Key points:

- removes duplication across every authenticated repository method
- ensures consistent header injection
- keeps auth concerns out of feature code
- easier to update auth behavior in one place
- risk: shared client becomes more important, so it must stay well-designed

#### 4. What coupling still exists in this app even though you used abstractions?

Key points:

- controllers are still tied to GetX lifecycle/state APIs
- repositories are still tied to `ApiClient` conventions and `Resource<T>`
- models are still shaped by API responses
- feature logic still depends on current route/navigation setup
- abstraction reduces coupling, but does not remove all coupling

#### 5. If an interviewer says "this is not true clean architecture," how would you respond?

Key points:

- agree that it is not full clean architecture
- explain that it is a pragmatic feature-first MVVM structure
- emphasize separation of concerns, DI, and testability already present
- explain that architecture should fit project size and complexity
- mention clear upgrade path if complexity grows

#### 6. What risks come from using one shared `ApiClient` for every feature?

Key points:

- a bug in shared client can affect many features
- overly broad client responsibilities can grow over time
- feature-specific behavior may tempt people to add special cases in the client
- requires discipline to keep the client generic and reusable
- benefits still outweigh the risks in this app

#### 7. Where would you draw the line between repository responsibilities and controller responsibilities?

Key points:

- controller should manage screen state, UI actions, and user flow
- repository should handle data operations and integration with services
- controller should not know HTTP details
- repository should not handle widget state or UI concerns

#### 8. How do fake repositories in controller tests support LSP and DIP at the same time?

Key points:

- fake repositories replace real ones through the same abstraction
- controller behavior does not change when implementation changes
- shows substitution through interface contract
- shows controller depends on abstraction, not concrete class

#### 9. If you needed offline-first behavior, what architectural change would be the most important?

Key points:

- introduce a local data source or cache abstraction
- repository becomes coordinator between remote and local sources
- keep controller API stable if possible
- avoid pushing storage decisions into pages or controllers

#### 10. What would make you split current repository responsibilities further?

Key points:

- growing business rules in repository methods
- need for more reuse across features
- increased complexity in validation, mapping, caching, or synchronization
- desire to isolate use cases more explicitly

### Section 3: Challenge Follow-Ups

Use these after answering a question. These are the kinds of short follow-ups interviewers ask when your first answer is too generic.

- "Why is that better, not just different?"
- "What problem would happen if the controller called Dio directly?"
- "Which exact class in your repo proves that point?"
- "What tradeoff did you accept with this design?"
- "What would break first if the project became much bigger?"
- "How do your tests prove this is more than theory?"
- "Where is the boundary between abstraction and unnecessary complexity in your app?"
- "What is one place where your current design is still coupled?"
- "What would you refactor first if caching became a requirement?"
- "Why did you choose this instead of full clean architecture?"
