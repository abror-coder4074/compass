import 'package:flutter/material.dart';

abstract final class CompassAssets {
  static const appIcon = 'assets/images/compass_app_icon.png';
  static const splashIcon = 'assets/images/compass_logo.png';
  static const certiportLogo = 'assets/certiport_logo_title.svg';
  static const ic3Logo = 'assets/images/ic3_logo.png';
  static const examLandingPhoto = 'assets/images/exam_landing_photo.png';
  static const pathwaysProgress = 'assets/images/pathways_progress.png';
}

abstract final class CompassColors {
  static const certiportTeal = Color(0xFF0789A2);
  static const certiportTealDark = Color(0xFF006F86);
  static const examNavy = Color(0xFF003D66);
  static const darkNavy = Color(0xFF003659);
  static const portalBackground = Color(0xFFE9E9E9);
  static const examHeader = Color(0xFFEAF1F8);
  static const border = Color(0xFFD7D7D7);
  static const fieldBorder = Color(0xFFCFCFCF);
  static const inputYellow = Color(0xFFF2A900);
  static const text = Color(0xFF263442);
  static const mutedText = Color(0xFF66727D);
  static const warning = Color(0xFFF5A623);
  static const successGreen = Color(0xFF2FAF2D);
  static const ic3Green = Color(0xFF31AA2D);
}

abstract final class CompassControlStates {
  static const orangeHoverSide = BorderSide(
    color: CompassColors.inputYellow,
    width: 2,
  );

  static WidgetStateProperty<BorderSide?> hoverSide(BorderSide baseSide) {
    return WidgetStateProperty.resolveWith<BorderSide?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return baseSide;
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return orangeHoverSide;
      }
      return baseSide;
    });
  }

  static WidgetStateProperty<BorderSide?> elevatedHoverSide() {
    return WidgetStateProperty.resolveWith<BorderSide?>((states) {
      if (states.contains(WidgetState.disabled)) {
        return null;
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return orangeHoverSide;
      }
      return null;
    });
  }
}

class CompassFocusedInputBorder extends OutlineInputBorder {
  const CompassFocusedInputBorder({
    super.borderRadius = BorderRadius.zero,
    super.gapPadding,
    super.borderSide = const BorderSide(
      color: CompassColors.certiportTeal,
      width: 1.5,
    ),
    this.outerSide = const BorderSide(
      color: CompassColors.inputYellow,
      width: 2,
    ),
  });

  final BorderSide outerSide;

  @override
  CompassFocusedInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
    BorderSide? outerSide,
  }) {
    return CompassFocusedInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gapPadding: gapPadding ?? this.gapPadding,
      outerSide: outerSide ?? this.outerSide,
    );
  }

  @override
  CompassFocusedInputBorder scale(double t) {
    return CompassFocusedInputBorder(
      borderSide: borderSide.scale(t),
      borderRadius: borderRadius * t,
      gapPadding: gapPadding * t,
      outerSide: outerSide.scale(t),
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is OutlineInputBorder) {
      return CompassFocusedInputBorder(
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        gapPadding: gapPadding,
        outerSide: BorderSide.lerp(BorderSide.none, outerSide, t),
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is OutlineInputBorder) {
      return CompassFocusedInputBorder(
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        gapPadding: gapPadding,
        outerSide: BorderSide.lerp(outerSide, BorderSide.none, t),
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final outerBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: outerSide,
      gapPadding: gapPadding,
    );
    outerBorder.paint(
      canvas,
      rect,
      gapStart: gapStart,
      gapExtent: gapExtent,
      gapPercentage: gapPercentage,
      textDirection: textDirection,
    );

    final innerInset = outerSide.width;
    final innerBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: borderSide,
      gapPadding: gapPadding,
    );
    innerBorder.paint(
      canvas,
      rect.deflate(innerInset),
      gapStart: gapStart == null ? null : gapStart - innerInset,
      gapExtent: gapExtent,
      gapPercentage: gapPercentage,
      textDirection: textDirection,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CompassFocusedInputBorder &&
        other.borderSide == borderSide &&
        other.borderRadius == borderRadius &&
        other.gapPadding == gapPadding &&
        other.outerSide == outerSide;
  }

  @override
  int get hashCode =>
      Object.hash(borderSide, borderRadius, gapPadding, outerSide);
}

ThemeData buildCompassTheme() {
  final base = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Arial',
    scaffoldBackgroundColor: CompassColors.portalBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor: CompassColors.certiportTeal,
      primary: CompassColors.certiportTeal,
      secondary: CompassColors.examNavy,
      surface: Colors.white,
    ),
    useMaterial3: false,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: CompassColors.text,
      displayColor: CompassColors.text,
      fontFamily: 'Arial',
    ),
    dividerColor: CompassColors.border,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: CompassColors.certiportTeal,
      selectionColor: CompassColors.certiportTeal.withValues(alpha: 0.24),
      selectionHandleColor: CompassColors.certiportTeal,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: CompassColors.fieldBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: CompassColors.fieldBorder),
      ),
      focusedBorder: CompassFocusedInputBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(side: CompassControlStates.elevatedHoverSide()),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: CompassControlStates.hoverSide(
          const BorderSide(color: CompassColors.certiportTeal),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      backgroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: CompassColors.text,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        color: CompassColors.text,
        fontSize: 14,
        height: 1.35,
      ),
    ),
  );
}
