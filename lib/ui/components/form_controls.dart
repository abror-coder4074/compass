import 'package:flutter/material.dart';

import '../compass_theme.dart';

class CompassTextInput extends StatelessWidget {
  const CompassTextInput({
    required this.label,
    this.initialValue,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.prefixIcon,
    this.onChanged,
    super.key,
  });

  final String label;
  final String? initialValue;
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final bool enabled;
  final IconData? prefixIcon;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldColumn(
      label: label,
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        obscureText: obscureText,
        enabled: enabled,
        onChanged: onChanged,
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
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: (selectedValue) => onChanged?.call(selectedValue),
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<T>(
                value: value,
                enabled: onChanged != null,
                visualDensity: VisualDensity.compact,
              ),
              Flexible(
                child: Text(label, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
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
