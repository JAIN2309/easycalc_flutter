import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/calculator_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/calculator_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(CalculatorController());
    
    // Allow all orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    return Obx(() {
      final controller = Get.find<CalculatorController>();
      
      return GetMaterialApp(
        title: 'EasyCalc',
        themeMode: controller.isDarkTheme.value ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90E2),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90E2),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: SplashScreen(),
        getPages: [
          GetPage(name: '/', page: () => SplashScreen()),
          GetPage(name: '/calculator', page: () => CalculatorScreen()),
        ],
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
