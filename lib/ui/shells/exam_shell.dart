import 'package:flutter/material.dart';

import '../compass_theme.dart';

class ExamWorkspaceShell extends StatelessWidget {
  const ExamWorkspaceShell({
    required this.title,
    required this.child,
    required this.footer,
    this.titleTrailing,
    this.underHeader,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget footer;
  final Widget? titleTrailing;
  final Widget? underHeader;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ExamTopBar(title: title, trailing: titleTrailing),
          ...?underHeader == null ? null : [underHeader!],
          Expanded(child: child),
          footer,
        ],
      ),
    );
  }
}

class ExamFooterBar extends StatelessWidget {
  const ExamFooterBar({
    required this.leadingChildren,
    required this.trailingChildren,
    super.key,
  });

  final List<Widget> leadingChildren;
  final List<Widget> trailingChildren;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: CompassColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 18,
              runSpacing: 10,
              children: leadingChildren,
            ),
          ),
          const SizedBox(width: 24),
          Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: trailingChildren,
          ),
        ],
      ),
    );
  }
}

class ExamToolsMenu extends StatelessWidget {
  const ExamToolsMenu({required this.onSelected, super.key});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Tools',
      offset: const Offset(0, -170),
      onSelected: onSelected,
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'calculator', child: Text('Calculator')),
        const PopupMenuItem(value: 'help', child: Text('Help')),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'close_window', child: Text('Close Window')),
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
    );
  }
}

class ExamFooterLink extends StatelessWidget {
  const ExamFooterLink({
    required this.label,
    required this.onPressed,
    this.active = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: active
            ? CompassColors.certiportTealDark
            : CompassColors.examNavy,
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 20),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: TextStyle(
          fontSize: 15,
          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
      child: Text(label),
    );
  }
}

class _ExamTopBar extends StatelessWidget {
  const _ExamTopBar({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      color: CompassColors.examHeader,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 18),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(fit: BoxFit.scaleDown, child: trailing!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
