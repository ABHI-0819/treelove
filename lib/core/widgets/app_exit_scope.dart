import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppExitScope extends StatefulWidget {
  final Widget child;
  final bool enableDoubleBack;
  final bool enableDialog;

  const AppExitScope({
    super.key,
    required this.child,
    this.enableDoubleBack = true,
    this.enableDialog = false,
  });

  @override
  State<AppExitScope> createState() => _AppExitScopeState();
}

class _AppExitScopeState extends State<AppExitScope> {
  DateTime? _lastPressed;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // We control pop manually
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final navigator = Navigator.of(context);

        //  If inner screen can pop, just pop it
        if (navigator.canPop()) {
          navigator.pop();
          return;
        }

        //  If dialog mode enabled
        if (widget.enableDialog) {
          final shouldExit = await _showExitDialog(context);
          if (shouldExit) {
            SystemNavigator.pop(); //  Correct way to exit app
          }
          return;
        }

        //  Double back mode
        if (widget.enableDoubleBack) {
          _handleDoubleBack();
        }
      },
      child: widget.child,
    );
  }

  void _handleDoubleBack() {
    final now = DateTime.now();

    if (_lastPressed == null ||
        now.difference(_lastPressed!) > const Duration(seconds: 2)) {
      _lastPressed = now;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Press back again to exit"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      SystemNavigator.pop(); // 🔥 Proper exit
    }
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Do you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
