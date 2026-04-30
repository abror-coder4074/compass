import 'package:flutter/material.dart';

import '../compass_theme.dart';

class PortalShell extends StatelessWidget {
  static const double _contentMaxWidth = 1388;
  static const double _contentMinWidth = 920;
  static const double _referenceContentRatio = 1388 / 2339;

  const PortalShell({
    required this.child,
    required this.onCloseWindow,
    required this.language,
    required this.onLanguageChanged,
    this.userName = 'Certiport Uzbekistan',
    this.showUserControls = true,
    this.showLanguageSelector = true,
    this.compactFooter = false,
    this.shrinkWrapContent = false,
    super.key,
  });

  final Widget child;
  final Future<void> Function() onCloseWindow;
  final String language;
  final ValueChanged<String?> onLanguageChanged;
  final String userName;
  final bool showUserControls;
  final bool showLanguageSelector;
  final bool compactFooter;
  final bool shrinkWrapContent;

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
            showUserControls: showUserControls,
            showLanguageSelector: showLanguageSelector,
          ),
          Expanded(
            child: ColoredBox(
              color: CompassColors.portalBackground,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final contentWidth = constraints.maxWidth < _contentMinWidth
                      ? constraints.maxWidth
                      : (constraints.maxWidth * _referenceContentRatio).clamp(
                          _contentMinWidth,
                          _contentMaxWidth,
                        );

                  final content = Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: contentWidth.toDouble(),
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: child,
                      ),
                    ),
                  );

                  if (shrinkWrapContent) {
                    return SingleChildScrollView(child: content);
                  }

                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: content,
                    ),
                  );
                },
              ),
            ),
          ),
          _PortalFooter(onCloseWindow: onCloseWindow, compact: compactFooter),
        ],
      ),
    );
  }
}

class _PortalHeader extends StatelessWidget {
  const _PortalHeader({
    required this.language,
    required this.onLanguageChanged,
    required this.userName,
    required this.showUserControls,
    required this.showLanguageSelector,
  });

  final String language;
  final ValueChanged<String?> onLanguageChanged;
  final String userName;
  final bool showUserControls;
  final bool showLanguageSelector;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;

        return Container(
          height: 104,
          padding: EdgeInsets.fromLTRB(
            compact ? 16 : 48,
            0,
            compact ? 12 : 24,
            0,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Color(0xFFD0D0D0), width: 4),
            ),
          ),
          child: Row(
            children: [
              Image.asset(
                CompassAssets.certiportLogo,
                width: compact ? 176 : 292,
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showUserControls || showLanguageSelector) ...[
                        IconButton(
                          tooltip: 'Announcements',
                          color: const Color(0xFF9EA3A8),
                          constraints: BoxConstraints.tightFor(
                            width: compact ? 40 : 48,
                            height: compact ? 40 : 48,
                          ),
                          icon: Icon(
                            Icons.campaign_outlined,
                            size: compact ? 26 : 30,
                          ),
                          onPressed: () {},
                        ),
                        SizedBox(width: compact ? 8 : 18),
                      ],
                      if (showUserControls) ...[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: compact ? 190 : 360,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.person,
                                color: Color(0xFF222222),
                                size: 17,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (showLanguageSelector) ...[
                        SizedBox(
                          width: showUserControls ? (compact ? 12 : 24) : 0,
                        ),
                        SizedBox(
                          width: compact ? 156 : 246,
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
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'English',
                                child: Text('English'),
                              ),
                              DropdownMenuItem(
                                value: 'Uzbek',
                                child: Text('Uzbek'),
                              ),
                              DropdownMenuItem(
                                value: 'Russian',
                                child: Text('Russian'),
                              ),
                            ],
                            onChanged: onLanguageChanged,
                          ),
                        ),
                      ],
                    ],
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

class _PortalFooter extends StatelessWidget {
  const _PortalFooter({required this.onCloseWindow, required this.compact});

  final Future<void> Function() onCloseWindow;
  final bool compact;

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
        final narrow = constraints.maxWidth < 1100;
        final iconSize = narrow ? 28.0 : 36.0;

        return Container(
          height: compact ? 104 : 88,
          color: CompassColors.certiportTeal,
          padding: EdgeInsets.symmetric(horizontal: narrow ? 16 : 0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1388),
              child: Row(
                children: [
                  if (!compact) ...[
                    Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    SizedBox(width: narrow ? 10 : 18),
                    Icon(
                      Icons.desktop_windows,
                      color: Colors.white,
                      size: iconSize,
                    ),
                    SizedBox(width: narrow ? 10 : 18),
                    Icon(Icons.wifi, color: Colors.white, size: iconSize + 4),
                    SizedBox(width: narrow ? 18 : 70),
                  ],
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
                  if (!compact) ...[
                    SizedBox(width: narrow ? 14 : 70),
                    SizedBox(
                      width: narrow ? 118 : 190,
                      child: Text(
                        '3.2603.5.4\n19.0.2.1687\n19.0.2.1687',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFF93D0DD),
                          fontSize: narrow ? 11 : 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
