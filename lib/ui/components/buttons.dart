import 'package:flutter/material.dart';

import '../compass_theme.dart';

enum CompassButtonTone { portal, exam }

class CompassPrimaryButton extends StatelessWidget {
  const CompassPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = CompassButtonTone.portal,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final CompassButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final color = tone == CompassButtonTone.exam
        ? CompassColors.examNavy
        : CompassColors.certiportTeal;

    final style = ElevatedButton.styleFrom(
      minimumSize: const Size(92, 38),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      backgroundColor: color,
      foregroundColor: Colors.white,
      disabledBackgroundColor: const Color(0xFFB9C0C6),
      disabledForegroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ).copyWith(side: CompassControlStates.elevatedHoverSide());

    if (icon == null) {
      return ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon, size: 17),
      label: Text(label),
    );
  }
}

class CompassSecondaryButton extends StatelessWidget {
  const CompassSecondaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = CompassButtonTone.portal,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final CompassButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final color = tone == CompassButtonTone.exam
        ? CompassColors.examNavy
        : CompassColors.certiportTeal;
    final baseSide = BorderSide(
      color: onPressed == null ? CompassColors.border : color,
    );
    final style = OutlinedButton.styleFrom(
      minimumSize: const Size(92, 38),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      foregroundColor: color,
      disabledForegroundColor: const Color(0xFF9CA5AD),
      side: baseSide,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ).copyWith(side: CompassControlStates.hoverSide(baseSide));

    if (icon == null) {
      return OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: Text(label),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon, size: 17),
      label: Text(label),
    );
  }
}
