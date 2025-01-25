import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SudoPasswordDialog extends StatefulWidget {
  const SudoPasswordDialog({super.key});

  @override
  State<SudoPasswordDialog> createState() => _SudoPasswordDialogState();
}

class _SudoPasswordDialogState extends State<SudoPasswordDialog> {
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void _submitPassword() {
    if (_passwordController.text.isNotEmpty) {
      Navigator.pop(context, _passwordController.text);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sudo Password Required'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Please enter your sudo password to mount the bin file:'),
          const SizedBox(height: 16),
          RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) {
              if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                _submitPassword();
              }
            },
            child: TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              autofocus: true,
              onSubmitted: (_) => _submitPassword(),
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitPassword,
          child: const Text('OK'),
        ),
      ],
    );
  }
} 