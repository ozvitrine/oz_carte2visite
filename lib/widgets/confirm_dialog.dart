import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String body;
  final String cancelLabel;
  final String confirmLabel;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    required this.body,
    required this.cancelLabel,
    required this.confirmLabel,
    this.isDestructive = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required IconData icon,
    Color? iconColor,
    required String title,
    required String body,
    required String cancelLabel,
    required String confirmLabel,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        icon: icon,
        iconColor: iconColor,
        title: title,
        body: body,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      icon: Icon(icon, color: iconColor),
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: colors.errorContainer,
                  foregroundColor: colors.onErrorContainer,
                )
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
