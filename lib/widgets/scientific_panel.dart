import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class ScientificPanel extends StatelessWidget {
  final CalculatorController controller = Get.find<CalculatorController>();

  ScientificPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.functions, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text('Scientific Functions', style: theme.textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 8),
          Text('Tap any function to apply it to the current number', 
               style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
          const SizedBox(height: 20),
          
          // Scientific function buttons with fixed height
          Column(
            children: [
              // Row 1: sin, cos, tan
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(child: _buildButton('sin', const Color(0xFF8E44AD), theme)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildButton('cos', const Color(0xFF8E44AD), theme)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildButton('tan', const Color(0xFF8E44AD), theme)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Row 2: log, ln, √
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(child: _buildButton('log', const Color(0xFF27AE60), theme)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildButton('ln', const Color(0xFF27AE60), theme)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildButton('√', const Color(0xFF27AE60), theme)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Row 3: x², x³, x!
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(child: _buildButton('x²', const Color(0xFFE67E22), theme)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildButton('x³', const Color(0xFFE67E22), theme)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildButton('x!', const Color(0xFFE67E22), theme)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Row 4: 1/x, Close
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Expanded(child: _buildButton('1/x', const Color(0xFF34495E), theme)),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _buildButton('Close', const Color(0xFF95A5A6), theme, isClose: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color color, ThemeData theme, {bool isClose = false}) {
    String function = text;
    if (text == '√') function = 'sqrt';
    if (text == 'x²') function = 'square';
    if (text == 'x³') function = 'cube';
    if (text == 'x!') function = 'factorial';
    if (text == '1/x') function = 'reciprocal';

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            try {
              await controller.playClickSound();
              if (isClose) {
                Navigator.of(Get.context!).pop();
              } else {
                controller.performScientificFunction(function);
                Navigator.of(Get.context!).pop();
              }
            } catch (e) {
              print('Scientific function error: $e');
            }
          },
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
