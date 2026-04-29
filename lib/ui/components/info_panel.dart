import 'package:flutter/material.dart';

import '../compass_theme.dart';

enum CompassInfoTone { info, warning, success }

class CompassInfoCard extends StatelessWidget {
  const CompassInfoCard({
    required this.message,
    this.title,
    this.tone = CompassInfoTone.info,
    super.key,
  });

  final String? title;
  final String message;
  final CompassInfoTone tone;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      CompassInfoTone.info => CompassColors.certiportTeal,
      CompassInfoTone.warning => CompassColors.warning,
      CompassInfoTone.success => CompassColors.successGreen,
    };
    final icon = switch (tone) {
      CompassInfoTone.info => Icons.info_outline,
      CompassInfoTone.warning => Icons.notifications_active_outlined,
      CompassInfoTone.success => Icons.check_circle_outline,
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CompassColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: color),
            Padding(
              padding: const EdgeInsets.all(18),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: color.withValues(alpha: 0.14),
                foregroundColor: color,
                child: Icon(icon, size: 24),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                    ],
                    Text(message, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompassPanel extends StatelessWidget {
  const CompassPanel({
    required this.title,
    required this.child,
    this.trailing,
    super.key,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CompassColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: CompassColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: const TextStyle(fontSize: 18)),
                ),
                ?trailing,
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(18), child: child),
        ],
      ),
    );
  }
}

class CompassTable extends StatelessWidget {
  const CompassTable({required this.columns, required this.rows, super.key});

  final List<String> columns;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Table(
      border: const TableBorder(
        horizontalInside: BorderSide(color: CompassColors.border),
      ),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        for (var i = 0; i < columns.length; i++) i: const FlexColumnWidth(),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF6F7F8)),
          children: columns
              .map((column) => _TableCell(column, header: true))
              .toList(),
        ),
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex++)
          TableRow(
            decoration: BoxDecoration(
              color: rowIndex.isEven ? Colors.white : const Color(0xFFF3F4F5),
            ),
            children: rows[rowIndex].map((cell) => _TableCell(cell)).toList(),
          ),
      ],
    );
  }
}

class CompassScrollablePanel extends StatefulWidget {
  const CompassScrollablePanel({
    required this.child,
    this.height = 180,
    super.key,
  });

  final Widget child;
  final double height;

  @override
  State<CompassScrollablePanel> createState() => _CompassScrollablePanelState();
}

class _CompassScrollablePanelState extends State<CompassScrollablePanel> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: widget.child,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell(this.text, {this.header = false});

  final String text;
  final bool header;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: header ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }
}
