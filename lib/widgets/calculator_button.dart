import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedBackground = backgroundColor ?? theme.colorScheme.surface;
    final resolvedTextColor = textColor ??
        (theme.brightness == Brightness.dark ? Colors.white : Colors.black87);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            // Play click sound through controller
            try {
              final controller = Get.find<CalculatorController>();
              await controller.playClickSound();
            } catch (_) {}
            onPressed();
          },
          splashColor: (theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black)
              .withOpacity(0.15),
          highlightColor: (theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black)
              .withOpacity(0.08),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  resolvedBackground.withOpacity(0.9),
                  resolvedBackground,
                ],
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500,
                  color: resolvedTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
