# EasyCalc - Flutter Calculator App

A modern Flutter calculator application with BODMAS rules implementation and corporate-style design.

## Features

- **BODMAS Calculation**: Implements proper order of operations (Brackets, Orders, Division/Multiplication, Addition/Subtraction)
- **Special Case**: When input "100" is entered, it returns "10"
- **Modern UI**: Clean, corporate-style calculator interface with light/dark themes
- **Clear Functions**: 
  - Clear All (C) - Clears entire input
  - Backspace (⌫) - Removes last digit
- **Scientific Mode**: Advanced mathematical functions in landscape orientation
- **Splash Screen**: 3-second animated splash screen with EasyCalc logo
- **State Management**: Uses GetX with Obx for reactive UI updates
- **Responsive Design**: Adapts to different screen sizes and orientations
- **Web Support**: Optimized layout for web browsers
- **History**: View and recall previous calculations
- **Themes**: Toggle between light and dark modes

## Project Structure

```
lib/
├── main.dart                  # App entry point and theme configuration
├── controllers/
│   └── calculator_controller.dart  # Business logic and state management
├── screens/
│   ├── splash_screen.dart     # Animated splash screen
│   └── calculator_screen.dart # Main calculator interface
└── widgets/
    ├── calculator_button.dart # Reusable button component
    └── scientific_panel.dart # Scientific calculator functions panel
```

## Dependencies

- `get: ^4.6.6` - State management and navigation
- `math_expressions: ^2.6.0` - Mathematical expression parsing and evaluation
- `cupertino_icons: ^1.0.2` - iOS-style icons
- `shared_preferences: ^2.2.2` - Local storage for theme preferences

## Getting Started

1. Ensure Flutter is installed on your system (Flutter 3.10.0 or higher recommended)
2. Clone this repository
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   # For mobile devices
   flutter run
   
   # For web
   flutter run -d chrome
   
   # For release build
   flutter build apk --release
   ```

## Design Features

- **Dark/Light Theme**: Toggle between corporate-style dark and light color schemes
- **Gradient Buttons**: Modern button design with subtle shadows and hover effects
- **Animated Transitions**: Smooth animations for all UI interactions
- **Responsive Layout**: Adapts to different screen sizes and orientations
- **Clean Typography**: Modern font stack with proper hierarchy
- **Accessibility**: High contrast ratios and touch targets

## Special Functionality

The calculator implements:
- Standard BODMAS rules for mathematical accuracy
- Special case: Entering exactly "100" returns "10"
- Real-time calculation preview
- Support for both basic and scientific operations
- Calculation history with copy-to-clipboard functionality
- Web-optimized layout that maintains phone-like appearance

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
