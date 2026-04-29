import 'package:flutter/material.dart';

import 'compass_theme.dart';

enum CompassButtonTone { portal, exam }

enum CompassInfoTone { info, warning, success }

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
    );

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
    final style = OutlinedButton.styleFrom(
      minimumSize: const Size(92, 38),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      foregroundColor: color,
      disabledForegroundColor: const Color(0xFF9CA5AD),
      side: BorderSide(color: onPressed == null ? CompassColors.border : color),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    );

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

class CompassTextInput extends StatelessWidget {
  const CompassTextInput({
    required this.label,
    this.initialValue,
    this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
    super.key,
  });

  final String label;
  final String? initialValue;
  final String? hintText;
  final bool obscureText;
  final bool enabled;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return _FieldColumn(
      label: label,
      child: TextFormField(
        initialValue: initialValue,
        obscureText: obscureText,
        enabled: enabled,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 18),
        ),
      ),
    );
  }
}

class CompassSelect<T> extends StatelessWidget {
  const CompassSelect({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String label;
  final T value;
  final Map<T, String> items;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldColumn(
      label: label,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
        decoration: const InputDecoration(),
        items: items.entries
            .map(
              (entry) => DropdownMenuItem<T>(
                value: entry.key,
                child: Text(entry.value),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class CompassToggle extends StatelessWidget {
  const CompassToggle({
    required this.value,
    required this.onChanged,
    this.activeLabel = 'Yes',
    this.inactiveLabel = 'No',
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String activeLabel;
  final String inactiveLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    final background = !enabled
        ? const Color(0xFF9EA5AA)
        : value
        ? CompassColors.certiportTeal
        : const Color(0xFF5B5B5B);

    return Semantics(
      button: true,
      toggled: value,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: enabled ? () => onChanged!(!value) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          width: 78,
          height: 36,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: value ? Alignment.centerLeft : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    value ? activeLabel : inactiveLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 140),
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompassRadioOption<T> extends StatelessWidget {
  const CompassRadioOption({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
    super.key,
  });

  final T value;
  final T groupValue;
  final String label;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChanged == null ? null : () => onChanged!(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              visualDensity: VisualDensity.compact,
              onChanged: onChanged,
            ),
            Flexible(child: Text(label, style: const TextStyle(fontSize: 14))),
          ],
        ),
      ),
    );
  }
}

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

class CompassScrollablePanel extends StatelessWidget {
  const CompassScrollablePanel({
    required this.child,
    this.height = 180,
    super.key,
  });

  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: child,
        ),
      ),
    );
  }
}

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

class _FieldColumn extends StatelessWidget {
  const _FieldColumn({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 5),
        child,
      ],
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
