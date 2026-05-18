import 'package:flutter/material.dart';

import '../compass_theme.dart';

typedef LockdownNoticeCallback =
    Future<void> Function({String? title, String? message});

class LockdownShell extends StatelessWidget {
  const LockdownShell({
    required this.examLockdownMode,
    required this.portalChild,
    required this.examChild,
    this.enteringSecureExam = false,
    super.key,
  });

  final bool examLockdownMode;
  final bool enteringSecureExam;
  final Widget portalChild;
  final Widget examChild;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: examLockdownMode ? examChild : portalChild),
          if (enteringSecureExam)
            const Positioned.fill(child: EnteringSecureExamOverlay()),
        ],
      ),
    );
  }
}

class EnteringSecureExamOverlay extends StatelessWidget {
  const EnteringSecureExamOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AbsorbPointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: CompassColors.darkNavy.withValues(alpha: 0.82),
          ),
          child: Center(
            child: Container(
              width: 430,
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: CompassColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 42,
                    height: 42,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CompassColors.certiportTeal,
                      ),
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    'Entering secure exam',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Compass is switching to the locked exam workspace.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CompassColors.mutedText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
