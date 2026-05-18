import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../compass_theme.dart';
import '../portal/portal_state.dart';

class PortalShell extends StatelessWidget {
  static const double _contentMaxWidth = 1388;
  static const double _contentMinWidth = 920;
  static const double _referenceContentRatio = 1388 / 2339;

  static double _contentWidthFor(double availableWidth) {
    if (availableWidth < _contentMinWidth) {
      return availableWidth;
    }

    return (availableWidth * _referenceContentRatio)
        .clamp(_contentMinWidth, _contentMaxWidth)
        .toDouble();
  }

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
                  final contentWidth = _contentWidthFor(constraints.maxWidth);

                  final content = Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: contentWidth,
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
              SvgPicture.asset(
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
                        Transform.translate(
                          offset: Offset(0, compact ? -5 : -6),
                          child: IconButton(
                            tooltip: 'Announcements',
                            color: const Color(0xFF9EA3A8),
                            constraints: BoxConstraints.tightFor(
                              width: compact ? 40 : 48,
                              height: compact ? 40 : 48,
                            ),
                            icon: _AnnouncementIcon(size: compact ? 26 : 30),
                            onPressed: () {},
                          ),
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
                          child: _PortalLanguageSelector(
                            language: language,
                            onLanguageChanged: onLanguageChanged,
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

class _PortalLanguageSelector extends StatefulWidget {
  const _PortalLanguageSelector({
    required this.language,
    required this.onLanguageChanged,
  });

  final String language;
  final ValueChanged<String?> onLanguageChanged;

  @override
  State<_PortalLanguageSelector> createState() =>
      _PortalLanguageSelectorState();
}

class _PortalLanguageSelectorState extends State<_PortalLanguageSelector> {
  final LayerLink _layerLink = LayerLink();
  final ScrollController _menuScrollController = ScrollController();
  OverlayEntry? _overlayEntry;
  double _menuWidth = 0;

  bool get _isOpen => _overlayEntry != null;

  @override
  void didUpdateWidget(covariant _PortalLanguageSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _menuScrollController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
      return;
    }

    _openMenu();
  }

  void _openMenu() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: _buildOverlay);
    overlay.insert(_overlayEntry!);
    setState(() {});
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {});
    }
  }

  void _selectLanguage(String value) {
    _closeMenu();
    widget.onLanguageChanged(value);
  }

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeMenu,
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 2),
          child: Material(
            color: Colors.transparent,
            child: Container(
              key: const ValueKey('portal-language-menu'),
              width: _menuWidth,
              constraints: const BoxConstraints(maxHeight: 292),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: CompassColors.fieldBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Scrollbar(
                controller: _menuScrollController,
                thumbVisibility: true,
                child: ListView(
                  controller: _menuScrollController,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    for (final entry in portalLanguages.entries)
                      _PortalLanguageMenuItem(
                        label: entry.value,
                        selected: entry.key == widget.language,
                        onPressed: () => _selectLanguage(entry.key),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _menuWidth = constraints.maxWidth;

        return CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            key: const ValueKey('portal-language-selector'),
            mouseCursor: SystemMouseCursors.click,
            onTap: _toggleMenu,
            child: Container(
              height: 43,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: _isOpen
                      ? CompassColors.certiportTeal
                      : CompassColors.fieldBorder,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      portalLanguages[widget.language] ?? widget.language,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 20,
                    color: const Color(0xFF222222),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PortalLanguageMenuItem extends StatelessWidget {
  const _PortalLanguageMenuItem({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      mouseCursor: SystemMouseCursors.click,
      onTap: onPressed,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: selected ? const Color(0xFFE6F4F8) : Colors.white,
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            color: const Color(0xFF222222),
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _AnnouncementIcon extends StatelessWidget {
  const _AnnouncementIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    // Certiport's header uses the campaign glyph without the broadcast marks.
    return SizedBox.square(
      dimension: size,
      child: ClipRect(
        clipper: const _AnnouncementIconClipper(),
        child: Icon(
          Icons.campaign_outlined,
          color: iconTheme.color,
          size: size,
        ),
      ),
    );
  }
}

class _AnnouncementIconClipper extends CustomClipper<Rect> {
  const _AnnouncementIconClipper();

  static const double _visibleWidthRatio = 0.76;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * _visibleWidthRatio, size.height);
  }

  @override
  bool shouldReclip(_AnnouncementIconClipper oldClipper) => false;
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
        final contentWidth = PortalShell._contentWidthFor(constraints.maxWidth);
        final narrow = contentWidth < 1100;
        final iconSize = narrow ? 28.0 : 36.0;

        return Container(
          height: compact ? 104 : 88,
          color: CompassColors.certiportTeal,
          child: Center(
            child: SizedBox(
              width: contentWidth,
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
