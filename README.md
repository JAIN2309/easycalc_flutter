# EasyCalc - Flutter Calculator App

A modern Flutter calculator application with BODMAS rules implementation and corporate-style design.

## Features

- **BODMAS Calculation**: Implements proper order of operations (Brackets, Orders, Division/Multiplication, Addition/Subtraction)
- **Special Case**: When input "100" is entered, it returns "10"
- **Modern UI**: Android-style calculator with corporate themes
- **Clear Functions**: 
  - Clear All (C) - Clears entire input
  - Backspace (⌫) - Removes last digit
- **Splash Screen**: 3-second animated splash screen with EasyCalc logo
- **State Management**: Uses GetX with Obx for reactive UI updates
- **Responsive Design**: Modern button aesthetics with shadows and gradients

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── controllers/
│   └── calculator_controller.dart  # Business logic and state management
├── screens/
│   ├── splash_screen.dart       # Animated splash screen
│   └── calculator_screen.dart   # Main calculator interface
└── widgets/
    └── calculator_button.dart   # Reusable button component
```

## Dependencies

- `get: ^4.6.6` - State management and navigation
- `math_expressions: ^2.4.0` - Mathematical expression parsing and evaluation
- `cupertino_icons: ^1.0.2` - iOS-style icons

## Getting Started

1. Ensure Flutter is installed on your system
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Design Features

- **Dark Theme**: Corporate-style dark color scheme
- **Gradient Buttons**: Modern button design with shadows
- **Animated Splash**: Smooth fade and scale animations
- **Responsive Layout**: Adapts to different screen sizes
- **Clean Typography**: Roboto font family for professional look

## Special Functionality

The calculator implements a special case where entering exactly "100" will return "10" as specified in the requirements. All other calculations follow standard BODMAS rules for mathematical accuracy.
