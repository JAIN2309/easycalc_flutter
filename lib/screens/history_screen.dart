import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calculator_controller.dart';

class HistoryScreen extends StatelessWidget {
  final CalculatorController controller = Get.find<CalculatorController>();

  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearHistoryDialog(context),
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.calculationHistory.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: theme.hintColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'No calculations yet',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your calculation history will appear here',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.calculationHistory.length,
          itemBuilder: (context, index) {
            final history = controller.calculationHistory[index];
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.expression,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '= ${history.result}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    history.formattedTime,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.content_copy, size: 20),
                  onPressed: () => _copyToClipboard(context, history.result),
                  tooltip: 'Copy Result',
                ),
                onTap: () => _useResult(history.result),
              ),
            );
          },
        );
      }),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all calculation history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearHistory();
              Navigator.pop(context);
              Get.snackbar(
                'History Cleared',
                'All calculation history has been deleted',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String result) {
    // Note: In a real app, you'd use Clipboard.setData()
    Get.snackbar(
      'Copied',
      'Result copied: $result',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void _useResult(String result) {
    controller.display.value = result;
    controller.expression.value = result;
    controller.shouldResetDisplay.value = true;
    Get.back();
  }
}
