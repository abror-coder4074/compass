import 'package:flutter/material.dart';

import 'compass_components.dart';
import 'compass_theme.dart';

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
    return Stack(
      children: [
        if (examLockdownMode) examChild else portalChild,
        if (enteringSecureExam) const EnteringSecureExamOverlay(),
      ],
    );
  }
}

class PortalShell extends StatelessWidget {
  const PortalShell({
    required this.child,
    required this.onCloseWindow,
    required this.language,
    required this.onLanguageChanged,
    this.userName = 'Certiport Uzbekistan',
    super.key,
  });

  final Widget child;
  final Future<void> Function() onCloseWindow;
  final String language;
  final ValueChanged<String?> onLanguageChanged;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CompassColors.portalBackground,
      body: Column(
        children: [
          _PortalHeader(
            language: language,
            onLanguageChanged: onLanguageChanged,
            userName: userName,
          ),
          Expanded(
            child: ColoredBox(
              color: CompassColors.portalBackground,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1360),
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _PortalFooter(onCloseWindow: onCloseWindow),
        ],
      ),
    );
  }
}

class ExamEngineShell extends StatelessWidget {
  const ExamEngineShell({
    required this.title,
    required this.child,
    required this.onBlockedExit,
    this.primaryLabel = 'Next',
    this.onPrimaryPressed,
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.lockdownMode = true,
    super.key,
  });

  final String title;
  final Widget child;
  final Future<void> Function() onBlockedExit;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;
  final bool lockdownMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ExamTopBar(title: title, lockdownMode: lockdownMode),
          Container(height: 10, color: CompassColors.examNavy),
          Expanded(child: child),
          _ExamActionBar(
            onBlockedExit: onBlockedExit,
            primaryLabel: primaryLabel,
            onPrimaryPressed: onPrimaryPressed,
            secondaryLabel: secondaryLabel,
            onSecondaryPressed: onSecondaryPressed,
          ),
        ],
      ),
    );
  }
}

class EnteringSecureExamOverlay extends StatelessWidget {
  const EnteringSecureExamOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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

class _PortalHeader extends StatelessWidget {
  const _PortalHeader({
    required this.language,
    required this.onLanguageChanged,
    required this.userName,
  });

  final String language;
  final ValueChanged<String?> onLanguageChanged;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFD0D0D0), width: 4)),
      ),
      child: Row(
        children: [
          Image.asset(
            CompassAssets.certiportLogo,
            width: 232,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Announcements',
            color: const Color(0xFF9EA3A8),
            icon: const Icon(Icons.campaign_outlined, size: 30),
            onPressed: () {},
          ),
          const SizedBox(width: 18),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person, color: Color(0xFF222222), size: 17),
              const SizedBox(width: 6),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 210,
            height: 43,
            child: DropdownButtonFormField<String>(
              initialValue: language,
              isExpanded: true,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, size: 20),
              items: const [
                DropdownMenuItem(value: 'English', child: Text('English')),
                DropdownMenuItem(value: 'Uzbek', child: Text('Uzbek')),
                DropdownMenuItem(value: 'Russian', child: Text('Russian')),
              ],
              onChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _PortalFooter extends StatelessWidget {
  const _PortalFooter({required this.onCloseWindow});

  final Future<void> Function() onCloseWindow;

  @override
  Widget build(BuildContext context) {
    final linkStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 20),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textStyle: const TextStyle(
        fontSize: 12,
        decoration: TextDecoration.underline,
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 1100;
        final iconSize = compact ? 28.0 : 36.0;

        return Container(
          height: 96,
          color: CompassColors.certiportTeal,
          padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 26),
          child: Row(
            children: [
              Icon(Icons.support_agent, color: Colors.white, size: iconSize),
              SizedBox(width: compact ? 10 : 18),
              Icon(Icons.desktop_windows, color: Colors.white, size: iconSize),
              SizedBox(width: compact ? 10 : 18),
              Icon(Icons.wifi, color: Colors.white, size: iconSize + 4),
              SizedBox(width: compact ? 18 : 70),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Copyright 1996-2026 Pearson Education Inc. or its affiliate(s). All rights reserved.',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: linkStyle,
                          child: const Text('Terms'),
                        ),
                        const Text(
                          ' | ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: linkStyle,
                          child: const Text('Privacy'),
                        ),
                        const Text(
                          ' | ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: linkStyle,
                          child: const Text('Contact'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: onCloseWindow,
                      style: linkStyle,
                      child: const Text('Close Window'),
                    ),
                  ],
                ),
              ),
              SizedBox(width: compact ? 14 : 70),
              SizedBox(
                width: compact ? 118 : 190,
                child: Text(
                  '3.2603.5.4\n19.0.2.1687\n19.0.2.1687',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: const Color(0xFF93D0DD),
                    fontSize: compact ? 11 : 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExamTopBar extends StatelessWidget {
  const _ExamTopBar({required this.title, required this.lockdownMode});

  final String title;
  final bool lockdownMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      color: CompassColors.examHeader,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (lockdownMode)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: CompassColors.border),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: CompassColors.examNavy,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Secure exam',
                    style: TextStyle(
                      color: CompassColors.examNavy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ExamActionBar extends StatelessWidget {
  const _ExamActionBar({
    required this.onBlockedExit,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    required this.secondaryLabel,
    required this.onSecondaryPressed,
  });

  final Future<void> Function() onBlockedExit;
  final String primaryLabel;
  final VoidCallback? onPrimaryPressed;
  final String? secondaryLabel;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: CompassColors.border)),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            tooltip: 'Tools',
            offset: const Offset(0, -132),
            onSelected: (value) {
              if (value == 'exit') {
                onBlockedExit();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'calculator', child: Text('Calculator')),
              PopupMenuItem(value: 'help', child: Text('Help')),
              PopupMenuDivider(),
              PopupMenuItem(value: 'exit', child: Text('Exit Compass')),
            ],
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tools',
                  style: TextStyle(color: CompassColors.examNavy, fontSize: 15),
                ),
                SizedBox(width: 3),
                Icon(Icons.arrow_drop_down, color: CompassColors.examNavy),
              ],
            ),
          ),
          const Spacer(),
          if (secondaryLabel != null) ...[
            CompassSecondaryButton(
              label: secondaryLabel!,
              tone: CompassButtonTone.exam,
              onPressed: onSecondaryPressed,
            ),
            const SizedBox(width: 12),
          ],
          CompassPrimaryButton(
            label: primaryLabel,
            tone: CompassButtonTone.exam,
            onPressed: onPrimaryPressed,
          ),
        ],
      ),
    );
  }
}
