import 'package:get/get.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../models/calculation_history.dart';

class CalculatorController extends GetxController {
  var display = '0'.obs;
  var expression = ''.obs;
  var liveResult = ''.obs;
  var shouldResetDisplay = false.obs;
  var isResultShown = false.obs;
  var isDarkTheme = true.obs;
  var isSoundEnabled = true.obs;
  var isScientificMode = false.obs;
  var calculationHistory = <CalculationHistory>[].obs;
  
  Future<void> playClickSound() async {
    if (isSoundEnabled.value) {
      try {
        // Multiple system sounds for enhanced feedback
        SystemSound.play(SystemSoundType.click);
        HapticFeedback.lightImpact();
        
        // Add a second click with slight delay for more noticeable sound
        Future.delayed(const Duration(milliseconds: 20), () {
          if (isSoundEnabled.value) {
            SystemSound.play(SystemSoundType.click);
          }
        });
        
        // Vary haptic feedback based on button type for better UX
        Future.delayed(const Duration(milliseconds: 10), () {
          if (isSoundEnabled.value) {
            HapticFeedback.selectionClick();
          }
        });
        
      } catch (e) {
        // Fallback to just haptic if system sounds fail
        try {
          HapticFeedback.mediumImpact();
        } catch (_) {
          // Silent fallback
        }
      }
    }
  }

  void onButtonPressed(String buttonText) {
    if (buttonText == 'C') {
      clearAll();
    } else if (buttonText == '⌫') {
      backspace();
    } else if (buttonText == '=') {
      calculate();
    } else if (buttonText == '%') {
      handlePercentage();
    } else if (isOperator(buttonText)) {
      addOperator(buttonText);
    } else {
      addNumber(buttonText);
    }
  }

  void clearAll() {
    display.value = '0';
    expression.value = '';
    liveResult.value = '';
    shouldResetDisplay.value = false;
    isResultShown.value = false;
  }

  void backspace() {
    if (display.value.length > 1) {
      display.value = display.value.substring(0, display.value.length - 1);
      expression.value = expression.value.substring(0, expression.value.length - 1);
    } else {
      display.value = '0';
      expression.value = '';
      liveResult.value = '';
    }
    _updateLiveResult();
  }

  void addNumber(String number) {
    if (shouldResetDisplay.value) {
      display.value = '';
      shouldResetDisplay.value = false;
    }
    
    if (display.value == '0' && number != '.') {
      display.value = number;
      expression.value = number;
    } else {
      display.value += number;
      expression.value += number;
    }
    isResultShown.value = false;
    _updateLiveResult();
  }

  void handlePercentage() {
    if (expression.value.isNotEmpty) {
      try {
        // Check if expression contains percentage pattern like "100%20"
        if (expression.value.contains('%')) {
          // Handle percentage calculation
          _calculatePercentage();
        } else {
          // Add percentage symbol to current expression
          expression.value += '%';
          display.value += '%';
          _updateLiveResult();
        }
      } catch (e) {
        // If error, just add % symbol
        expression.value += '%';
        display.value += '%';
        _updateLiveResult();
      }
    }
  }

  void _calculatePercentage() {
    try {
      String expr = expression.value;
      
      // Handle patterns like "100%20" -> "100 * 20 / 100" = 20
      if (expr.contains('%')) {
        RegExp percentPattern = RegExp(r'(\d+(?:\.\d+)?)%(\d+(?:\.\d+)?)');
        Match? match = percentPattern.firstMatch(expr);
        
        if (match != null) {
          double base = double.parse(match.group(1)!);
          double percentage = double.parse(match.group(2)!);
          double result = (base * percentage) / 100;
          
          // Format result
          String formattedResult;
          if (result == result.toInt()) {
            formattedResult = result.toInt().toString();
          } else {
            formattedResult = result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
          }
          
          display.value = formattedResult;
          expression.value = formattedResult;
          liveResult.value = '';
          shouldResetDisplay.value = true;
          isResultShown.value = true;
        }
      }
    } catch (e) {
      display.value = 'Error';
      expression.value = '';
      liveResult.value = '';
      shouldResetDisplay.value = true;
    }
  }

  void addOperator(String operator) {
    if (shouldResetDisplay.value) {
      shouldResetDisplay.value = false;
    }
    
    // Replace display operator symbols with math expression operators
    String mathOperator = operator;
    switch (operator) {
      case '×':
        mathOperator = '*';
        break;
      case '÷':
        mathOperator = '/';
        break;
    }
    
    if (expression.value.isNotEmpty && !isOperator(expression.value[expression.value.length - 1])) {
      expression.value += mathOperator;
      display.value += operator;
    }
    _updateLiveResult();
  }

  void calculate() {
    try {
      if (expression.value.isEmpty) return;
      
      // Handle percentage patterns like "98%2" before regular calculation
      if (expression.value.contains('%')) {
        RegExp percentPattern = RegExp(r'(\d+(?:\.\d+)?)%(\d+(?:\.\d+)?)');
        Match? match = percentPattern.firstMatch(expression.value);
        
        if (match != null) {
          double base = double.parse(match.group(1)!);
          double percentage = double.parse(match.group(2)!);
          double result = (base * percentage) / 100;
          
          // Format the result
          String formattedResult;
          if (result == result.toInt()) {
            formattedResult = result.toInt().toString();
          } else {
            formattedResult = result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
          }
          
          // Add to history
          addToHistory(expression.value, formattedResult);
          
          display.value = formattedResult;
          expression.value = formattedResult;
          liveResult.value = '';
          shouldResetDisplay.value = true;
          isResultShown.value = true;
          return;
        }
      }
      
      // Parse and evaluate the expression using BODMAS rules
      Parser parser = Parser();
      Expression exp = parser.parse(expression.value);
      ContextModel contextModel = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, contextModel);
      
      // Format the result
      String originalExpression = expression.value;
      String formattedResult;
      if (result == result.toInt()) {
        formattedResult = result.toInt().toString();
      } else {
        formattedResult = result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      
      // Add to history
      addToHistory(originalExpression, formattedResult);
      
      display.value = formattedResult;
      expression.value = formattedResult;
      liveResult.value = '';
      shouldResetDisplay.value = true;
      isResultShown.value = true;
    } catch (e) {
      display.value = 'Error';
      expression.value = '';
      liveResult.value = '';
      shouldResetDisplay.value = true;
    }
  }

  void _updateLiveResult() {
    try {
      if (expression.value.isEmpty || expression.value == '0') {
        liveResult.value = '';
        return;
      }
      
      // Don't show live result if expression ends with an operator
      if (isOperator(expression.value[expression.value.length - 1])) {
        liveResult.value = '';
        return;
      }
      
      // Handle percentage patterns like "100%20"
      if (expression.value.contains('%')) {
        RegExp percentPattern = RegExp(r'(\d+(?:\.\d+)?)%(\d+(?:\.\d+)?)');
        Match? match = percentPattern.firstMatch(expression.value);
        
        if (match != null) {
          double base = double.parse(match.group(1)!);
          double percentage = double.parse(match.group(2)!);
          double result = (base * percentage) / 100;
          
          String formattedResult;
          if (result == result.toInt()) {
            formattedResult = result.toInt().toString();
          } else {
            formattedResult = result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
          }
          
          liveResult.value = formattedResult;
          return;
        }
      }
      
      // Parse and evaluate the expression
      Parser parser = Parser();
      Expression exp = parser.parse(expression.value);
      ContextModel contextModel = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, contextModel);
      
      // Format the result
      String formattedResult;
      if (result == result.toInt()) {
        formattedResult = result.toInt().toString();
      } else {
        formattedResult = result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      
      liveResult.value = formattedResult;
    } catch (e) {
      liveResult.value = '';
    }
  }

  void toggleTheme() {
    isDarkTheme.value = !isDarkTheme.value;
  }

  void toggleSound() {
    isSoundEnabled.value = !isSoundEnabled.value;
  }

  void toggleScientificMode() {
    isScientificMode.value = !isScientificMode.value;
  }

  void addToHistory(String expr, String result) {
    calculationHistory.insert(0, CalculationHistory(
      expression: expr,
      result: result,
      timestamp: DateTime.now(),
    ));
    
    // Keep only last 50 calculations
    if (calculationHistory.length > 50) {
      calculationHistory.removeRange(50, calculationHistory.length);
    }
  }

  void clearHistory() {
    calculationHistory.clear();
  }

  void performScientificFunction(String function) {
    try {
      if (display.value == '0' || display.value.isEmpty) return;
      
      double currentValue = double.parse(display.value);
      double result;
      String functionExpression = '$function($display.value)';
      
      switch (function) {
        case 'sin':
          result = math.sin(currentValue * math.pi / 180); // Convert to radians
          break;
        case 'cos':
          result = math.cos(currentValue * math.pi / 180);
          break;
        case 'tan':
          result = math.tan(currentValue * math.pi / 180);
          break;
        case 'sqrt':
          result = math.sqrt(currentValue);
          break;
        case 'log':
          result = math.log(currentValue) / math.ln10; // Base 10 logarithm
          break;
        case 'ln':
          result = math.log(currentValue); // Natural logarithm
          break;
        case 'factorial':
          if (currentValue < 0 || currentValue != currentValue.toInt()) {
            throw Exception('Invalid input for factorial');
          }
          result = _factorial(currentValue.toInt()).toDouble();
          functionExpression = '$display.value!';
          break;
        case 'square':
          result = currentValue * currentValue;
          functionExpression = '($display.value)²';
          break;
        case 'cube':
          result = currentValue * currentValue * currentValue;
          functionExpression = '($display.value)³';
          break;
        case 'reciprocal':
          if (currentValue == 0) throw Exception('Division by zero');
          result = 1 / currentValue;
          functionExpression = '1/$display.value';
          break;
        default:
          return;
      }
      
      // Format result
      String formattedResult;
      if (result == result.toInt() && result.abs() < 1e15) {
        formattedResult = result.toInt().toString();
      } else {
        formattedResult = result.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      
      // Add to history
      addToHistory(functionExpression, formattedResult);
      
      // Update display
      display.value = formattedResult;
      expression.value = formattedResult;
      liveResult.value = '';
      shouldResetDisplay.value = true;
      isResultShown.value = true;
      
    } catch (e) {
      display.value = 'Error';
      expression.value = '';
      liveResult.value = '';
      shouldResetDisplay.value = true;
    }
  }

  int _factorial(int n) {
    if (n <= 1) return 1;
    if (n > 20) throw Exception('Factorial too large'); // Prevent overflow
    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }

  bool isOperator(String text) {
    return ['+', '-', '×', '÷', '*', '/'].contains(text);
  }
}
