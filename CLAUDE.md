# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application named "personal_tool" - a basic Flutter project with the default counter app structure. The project is configured for multi-platform deployment (Android, iOS, Linux, macOS, Windows, and Web).

## Essential Commands

### Development
- `flutter run` - Start the app in development mode with hot reload
- `flutter run -d web` - Run the app in web browser
- `flutter run -d macos` - Run the app on macOS
- `flutter run -d android` - Run the app on Android device/emulator
- `flutter run -d ios` - Run the app on iOS device/simulator

### Building
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter build web` - Build web version
- `flutter build macos` - Build macOS app
- `flutter build windows` - Build Windows app
- `flutter build linux` - Build Linux app

### Testing and Analysis
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run specific test file
- `flutter analyze` - Run static analysis and linting
- `dart analyze` - Alternative static analysis command

### Package Management
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies
- `flutter pub outdated` - Check for outdated dependencies

### Cleaning
- `flutter clean` - Clean build artifacts
- `flutter pub cache clean` - Clean pub cache

## Code Architecture

### Project Structure
- `lib/main.dart` - Main application entry point with MyApp and MyHomePage widgets
- `test/widget_test.dart` - Widget tests for the counter functionality
- `pubspec.yaml` - Flutter project configuration and dependencies
- `analysis_options.yaml` - Dart analyzer configuration with flutter_lints

### Key Components
- **MyApp** - Root StatelessWidget that configures MaterialApp with theme and routing
- **MyHomePage** - StatefulWidget implementing the main counter screen with AppBar and FloatingActionButton
- **_MyHomePageState** - State management for the counter functionality

### Dependencies
- **flutter_lints** ^5.0.0 - Provides recommended linting rules
- **cupertino_icons** ^1.0.8 - iOS-style icons
- **flutter_test** - Testing framework (dev dependency)

## Platform Configuration

The project includes platform-specific configurations for:
- **Android** - `android/` directory with Gradle build files and MainActivity.kt
- **iOS** - `ios/` directory with Xcode project and AppDelegate.swift
- **Web** - `web/` directory with HTML and web manifest
- **macOS** - `macos/` directory with Xcode project and AppDelegate.swift
- **Windows** - `windows/` directory with CMake build files
- **Linux** - `linux/` directory with CMake build files

## Development Notes

### Linting and Analysis
- Uses `package:flutter_lints/flutter.yaml` for recommended Flutter linting rules
- Analysis options configured in `analysis_options.yaml`
- Run `flutter analyze` to check for issues before committing

### Testing
- Widget tests located in `test/` directory
- Current test verifies counter increment functionality
- Use `flutter test` to run all tests

### State Management
- Currently uses basic setState() for state management
- Consider adding more sophisticated state management (Provider, Riverpod, BLoC) for complex features

### Hot Reload
- Use `flutter run` and save files to trigger hot reload during development
- Use `r` in terminal or IDE hot reload button for quick updates
- Use `R` for hot restart when needed