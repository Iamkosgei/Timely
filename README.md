# Timely ⏰

A Flutter application that combines a beautiful digital clock interface with an intelligent prime number detection system. Timely fetches random numbers from an external API, checks if they're prime, and notifies users when prime numbers are discovered.

## 🚀 Features

- **Digital Clock**: Real-time display showing current time and date
- **Prime Number Detection**: Automated system that fetches random numbers and identifies prime numbers
- **Smart Notifications**: Bottom sheet notifications when prime numbers are found
- **Clean Architecture**: Implements Domain-Driven Design (DDD) principles
- **Offline Support**: Local caching with network connectivity detection
- **State Management**: Robust state handling using BLoC pattern

## 📱 Screenshots

| Loading State | Number Loaded (Not Prime) | Prime Number Found |
|:-------------:|:-------------------------:|:------------------:|
| ![Fetching](https://github.com/user-attachments/assets/9476cc7c-b9db-446c-bf0d-e317217f2b18) | ![Not Prime](https://github.com/user-attachments/assets/769b885e-6a08-47d7-8d6d-5f553e52b8fd) | ![Prime Found](https://github.com/user-attachments/assets/5d9c5902-342b-4ba0-9391-3d7532810322) |
| App fetching random numbers from API | Non-prime number detected | Prime number discovered with notification |

## 📦 Key Packages

### State Management
- **flutter_bloc** (^8.1.6): State management using BLoC pattern for predictable state handling
- **equatable** (^2.0.5): Value equality for objects, essential for state comparison in BLoC

### Functional Programming
- **dartz** (^0.10.1): Functional programming constructs, providing Either type for error handling

### Dependency Injection
- **get_it** (^7.7.0): Service locator for dependency injection
- **injectable** (^2.4.4): Code generation for dependency injection setup

### Network & Connectivity
- **dio** (^5.7.0): HTTP client for API requests with interceptors and error handling
- **internet_connection_checker** (^1.0.0+1): Network connectivity detection

### Local Storage
- **shared_preferences** (^2.3.2): Key-value storage for caching data locally

### Utilities
- **uuid** (^4.5.0): Generate unique identifiers
- **logger** (^2.4.0): Structured logging system for debugging and monitoring

### Development
- **injectable_generator** (^2.6.2): Code generation for dependency injection
- **build_runner** (^2.4.13): Build system for code generation
- **flutter_lints** (^3.0.0): Linting rules for code quality

## 🏗️ Architecture: Domain-Driven Design (DDD)

This project follows **Clean Architecture** principles with **Domain-Driven Design**, organizing code into distinct layers:

### Core Layer (`lib/core/`)
Contains shared business logic and infrastructure:
- **errors/**: Custom exception definitions
- **failures/**: Failure models for error handling
- **network/**: Network connectivity abstractions
- **theme/**: Application theming
- **usecases/**: Base use case interfaces
- **utils/**: Shared utilities and constants

### Features Layer (`lib/features/`)
Implements specific business features using a three-layer architecture:

#### Clock Feature (`lib/features/clock/`)
- **presentation/widgets/**: UI components for time display

#### Prime Number Feature (`lib/features/prime_number/`)
- **domain/**: Business logic layer
  - **entities/**: Core business objects (NumberData)
  - **repositories/**: Abstract repository contracts
  - **usecases/**: Business use cases (CheckPrime, GetRandomNumber)

- **data/**: Data access layer
  - **datasources/**: Data source implementations (local & remote)
  - **models/**: Data models with serialization
  - **repositories/**: Repository implementations

- **presentation/**: UI layer
  - **cubits/**: State management (NumberCubit, NumberState)
  - **widgets/**: UI components and screens

### Shared Layer (`lib/shared/`)
Common UI components and pages used across features:
- **pages/**: Application screens (HomePage)
- **widgets/**: Reusable UI components

### Dependency Injection (`lib/injection_container.dart`)
Centralized dependency registration using GetIt service locator pattern.

## 📁 Codebase Structure

```
lib/
├── core/                          # Shared infrastructure
│   ├── errors/                   # Exception definitions
│   ├── failures/                 # Failure models
│   ├── network/                  # Network abstractions
│   ├── theme/                    # App theming
│   ├── usecases/                 # Base use case contracts
│   └── utils/                    # Utilities and constants
├── features/                      # Business features
│   ├── clock/                    # Digital clock feature
│   │   └── presentation/
│   │       └── widgets/          # Clock UI components
│   └── prime_number/             # Prime number detection
│       ├── domain/               # Business logic
│       │   ├── entities/         # Core business objects
│       │   ├── repositories/     # Repository contracts
│       │   └── usecases/         # Business use cases
│       ├── data/                 # Data access
│       │   ├── datasources/      # Data sources (local/remote)
│       │   ├── models/           # Data models
│       │   └── repositories/     # Repository implementations
│       └── presentation/         # UI layer
│           ├── cubits/           # State management
│           └── widgets/          # UI components
├── shared/                       # Shared UI components
│   ├── pages/                    # Application screens
│   └── widgets/                  # Reusable widgets
├── injection_container.dart      # Dependency injection setup
└── main.dart                     # Application entry point
```

## 🎯 Application Flow

1. **Initialization**: App starts with dependency injection setup and logger initialization
2. **Home Screen**: Displays digital clock as the main interface
3. **Background Process**: Continuously fetches random numbers from external API
4. **Prime Detection**: Each number is checked for primality using optimized algorithm
5. **User Notification**: When prime numbers are found, users are notified via bottom sheet
6. **State Management**: All operations are managed through BLoC pattern with proper error handling
7. **Offline Support**: Failed network requests are cached locally for retry

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >=3.4.4
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:Iamkosgei/Timely.git
   cd timely
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate dependency injection code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Development Commands

- **Code generation**: `flutter packages pub run build_runner build`
- **Watch mode**: `flutter packages pub run build_runner watch`
- **Clean build**: `flutter packages pub run build_runner build --delete-conflicting-outputs`

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
