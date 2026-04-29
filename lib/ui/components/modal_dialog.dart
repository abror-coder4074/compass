import 'package:flutter/material.dart';

import '../compass_theme.dart';

class CompassModalDialog extends StatelessWidget {
  const CompassModalDialog({
    required this.title,
    required this.message,
    required this.actions,
    this.icon,
    super.key,
  });

  final String title;
  final String message;
  final IconData? icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(24, 4, 24, 18),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: CompassColors.certiportTeal, size: 24),
            const SizedBox(width: 10),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: SizedBox(width: 420, child: Text(message)),
      actions: actions,
    );
  }
}
