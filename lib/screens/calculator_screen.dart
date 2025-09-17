import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';
import '../widgets/calculator_button.dart';
import '../widgets/scientific_panel.dart';
import 'history_screen.dart';

class CalculatorScreen extends StatelessWidget {
  final CalculatorController controller = Get.find<CalculatorController>();

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calculate_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'EasyCalc',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.to(() => HistoryScreen()),
            tooltip: 'History',
          ),
          Obx(() => IconButton(
            icon: Icon(controller.isScientificMode.value ? Icons.calculate : Icons.functions),
            onPressed: () => controller.toggleScientificMode(),
            tooltip: controller.isScientificMode.value ? 'Basic Calculator' : 'Scientific Calculator',
          )),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsSheet(context),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: kIsWeb
          // On web, always render portrait-like phone layout and do NOT auto-switch to landscape/scientific
          ? _wrapAsPhoneOnWeb(_buildPortraitLayout(context))
          : OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.landscape) {
                  // Force scientific mode in landscape (mobile only)
                  if (!controller.isScientificMode.value) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.isScientificMode.value = true;
                    });
                  }
                  return _buildLandscapeLayout(context);
                } else {
                  return _buildPortraitLayout(context);
                }
              },
            ),
      
    );
  }

  // Web helper: center content and constrain width to simulate a phone portrait layout
  Widget _wrapAsPhoneOnWeb(Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth > 520 ? 520 : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SafeArea(
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Column(
      children: [
        // Display area
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Main display - typing values in bigger font
                Container(
                  width: double.infinity,
                  child: Obx(() => Text(
                    controller.display.value,
                    style: TextStyle(
                      fontSize: 52,
                      color: controller.isResultShown.value
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).textTheme.headlineMedium?.color ?? Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                ),
                const SizedBox(height: 15),
                // Live result preview - smaller font below
                Container(
                  width: double.infinity,
                  child: Obx(() => Text(
                    controller.liveResult.value,
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                ),
              ],
            ),
          ),
        ),
        // Button area
        Expanded(
          flex: 3,
          child: Obx(() => controller.isScientificMode.value 
            ? _buildScientificLayout(context)
            : _buildBasicLayout()),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          // Display area - left side in landscape
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Main display
                  Container(
                    width: double.infinity,
                    child: Obx(() => Text(
                      controller.display.value,
                      style: TextStyle(
                        fontSize: 28,
                        color: controller.isResultShown.value
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).textTheme.headlineMedium?.color ?? Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                  const SizedBox(height: 8),
                  // Live result preview
                  Container(
                    width: double.infinity,
                    child: Obx(() => Text(
                      controller.liveResult.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ),
                ],
              ),
            ),
          ),
          // Button area - right side in landscape, always scientific layout
          Expanded(
            flex: 2,
            child: _buildScientificLayout(context, isLandscape: true),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicLayout() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Row 1: C, ⌫, %, ÷
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: 'C',
                    onPressed: () => controller.onButtonPressed('C'),
                    backgroundColor: const Color(0xFFE74C3C),
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '⌫',
                    onPressed: () => controller.onButtonPressed('⌫'),
                    backgroundColor: const Color(0xFFE67E22),
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '%',
                    onPressed: () => controller.onButtonPressed('%'),
                    backgroundColor: const Color(0xFF9B59B6),
                    textColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '÷',
                    onPressed: () => controller.onButtonPressed('÷'),
                    backgroundColor: const Color(0xFF1F6FEB),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Row 2: 7, 8, 9, ×
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: '7',
                    onPressed: () => controller.onButtonPressed('7'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '8',
                    onPressed: () => controller.onButtonPressed('8'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '9',
                    onPressed: () => controller.onButtonPressed('9'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '×',
                    onPressed: () => controller.onButtonPressed('×'),
                    backgroundColor: const Color(0xFF1F6FEB),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Row 3: 4, 5, 6, -
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: '4',
                    onPressed: () => controller.onButtonPressed('4'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '5',
                    onPressed: () => controller.onButtonPressed('5'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '6',
                    onPressed: () => controller.onButtonPressed('6'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '-',
                    onPressed: () => controller.onButtonPressed('-'),
                    backgroundColor: const Color(0xFF1F6FEB),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Row 4: 1, 2, 3, +
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: '1',
                    onPressed: () => controller.onButtonPressed('1'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '2',
                    onPressed: () => controller.onButtonPressed('2'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '3',
                    onPressed: () => controller.onButtonPressed('3'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '+',
                    onPressed: () => controller.onButtonPressed('+'),
                    backgroundColor: const Color(0xFF1F6FEB),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Row 5: 0, ., =
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CalculatorButton(
                    text: '0',
                    onPressed: () => controller.onButtonPressed('0'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '.',
                    onPressed: () => controller.onButtonPressed('.'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CalculatorButton(
                    text: '=',
                    onPressed: () => controller.onButtonPressed('='),
                    backgroundColor: const Color(0xFF238636),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScientificLayout(BuildContext context, {bool isLandscape = false}) {
    return Container(
      padding: EdgeInsets.all(isLandscape ? 12 : 20),
      child: Column(
        children: [
          // Row 1: sin, cos, tan, C, ⌫
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: 'sin',
                    onPressed: () => controller.performScientificFunction('sin'),
                    backgroundColor: const Color(0xFF8E44AD),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: 'cos',
                    onPressed: () => controller.performScientificFunction('cos'),
                    backgroundColor: const Color(0xFF8E44AD),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: 'tan',
                    onPressed: () => controller.performScientificFunction('tan'),
                    backgroundColor: const Color(0xFF8E44AD),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: 'C',
                    onPressed: () => controller.onButtonPressed('C'),
                    backgroundColor: const Color(0xFFE74C3C),
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '⌫',
                    onPressed: () => controller.onButtonPressed('⌫'),
                    backgroundColor: const Color(0xFFE67E22),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isLandscape ? 6 : 8),
          // Row 2: log, ln, √, %, ÷
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: 'log',
                    onPressed: () => controller.performScientificFunction('log'),
                    backgroundColor: const Color(0xFF27AE60),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: 'ln',
                    onPressed: () => controller.performScientificFunction('ln'),
                    backgroundColor: const Color(0xFF27AE60),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '√',
                    onPressed: () => controller.performScientificFunction('sqrt'),
                    backgroundColor: const Color(0xFF27AE60),
                    textColor: Colors.white,
                    fontSize: 18,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '%',
                    onPressed: () => controller.onButtonPressed('%'),
                    backgroundColor: const Color(0xFF9B59B6),
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '÷',
                    onPressed: () => controller.onButtonPressed('÷'),
                    backgroundColor: const Color(0xFF1F6FEB),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isLandscape ? 6 : 8),
          // Row 3: x², x³, x!, 7, 8, 9, ×
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: 'x²',
                    onPressed: () => controller.performScientificFunction('square'),
                    backgroundColor: const Color(0xFFE67E22),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: 'x³',
                    onPressed: () => controller.performScientificFunction('cube'),
                    backgroundColor: const Color(0xFFE67E22),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: 'x!',
                    onPressed: () => controller.performScientificFunction('factorial'),
                    backgroundColor: const Color(0xFFE67E22),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '7',
                    onPressed: () => controller.onButtonPressed('7'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '8',
                    onPressed: () => controller.onButtonPressed('8'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '9',
                    onPressed: () => controller.onButtonPressed('9'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '×',
                    onPressed: () => controller.onButtonPressed('×'),
                    backgroundColor: const Color(0xFF1F6FEB),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isLandscape ? 6 : 8),
          // Row 4: 1/x, 4, 5, 6, -
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: '1/x',
                    onPressed: () => controller.performScientificFunction('reciprocal'),
                    backgroundColor: const Color(0xFF34495E),
                    textColor: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '4',
                    onPressed: () => controller.onButtonPressed('4'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '5',
                    onPressed: () => controller.onButtonPressed('5'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '6',
                    onPressed: () => controller.onButtonPressed('6'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '-',
                    onPressed: () => controller.onButtonPressed('-'),
                    backgroundColor: const Color(0xFF1F6FEB),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isLandscape ? 6 : 8),
          // Row 5: 1, 2, 3, +
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: CalculatorButton(
                    text: '1',
                    onPressed: () => controller.onButtonPressed('1'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '2',
                    onPressed: () => controller.onButtonPressed('2'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '3',
                    onPressed: () => controller.onButtonPressed('3'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '+',
                    onPressed: () => controller.onButtonPressed('+'),
                    backgroundColor: const Color(0xFF1F6FEB),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isLandscape ? 6 : 8),
          // Row 6: 0, ., =
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CalculatorButton(
                    text: '0',
                    onPressed: () => controller.onButtonPressed('0'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '.',
                    onPressed: () => controller.onButtonPressed('.'),
                  ),
                ),
                SizedBox(width: isLandscape ? 6 : 8),
                Expanded(
                  child: CalculatorButton(
                    text: '=',
                    onPressed: () => controller.onButtonPressed('='),
                    backgroundColor: const Color(0xFF238636),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
                      child: const Icon(Icons.settings, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text('Settings', style: theme.textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Personalize your experience', style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                const SizedBox(height: 16),
                Card(
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Obx(() => SwitchListTile.adaptive(
                            secondary: Icon(Icons.brightness_6, color: theme.colorScheme.secondary),
                            title: const Text('Dark Theme'),
                            subtitle: Text('Switch between light and dark modes', style: theme.textTheme.bodySmall),
                            value: controller.isDarkTheme.value,
                            onChanged: (v) => controller.toggleTheme(),
                            activeColor: theme.colorScheme.primary,
                          )),
                      const Divider(height: 1),
                      Obx(() => SwitchListTile.adaptive(
                            secondary: Icon(Icons.volume_up, color: theme.colorScheme.secondary),
                            title: const Text('Button Sound'),
                            subtitle: Text('Play click sound on key press', style: theme.textTheme.bodySmall),
                            value: controller.isSoundEnabled.value,
                            onChanged: (v) => controller.toggleSound(),
                            activeColor: theme.colorScheme.primary,
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.check, color: theme.colorScheme.secondary),
                    label: Text('Done', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.secondary)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
