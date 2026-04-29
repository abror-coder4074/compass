import 'package:flutter/material.dart';

import '../compass_theme.dart';

class PortalPage extends StatelessWidget {
  const PortalPage({
    required this.title,
    required this.child,
    required this.actions,
    this.subtitle,
    this.centeredTitle = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;
  final bool centeredTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(42, 30, 42, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: centeredTitle ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              fontSize: centeredTitle ? 30 : 28,
              fontWeight: centeredTitle ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: centeredTitle ? TextAlign.center : TextAlign.left,
              style: const TextStyle(
                color: CompassColors.mutedText,
                fontSize: 15,
              ),
            ),
          ],
          const SizedBox(height: 28),
          child,
          const SizedBox(height: 28),
          PortalActionRow(children: actions),
        ],
      ),
    );
  }
}

class PortalActionRow extends StatelessWidget {
  const PortalActionRow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 12,
      runSpacing: 10,
      children: children,
    );
  }
}

class PortalResponsiveFields extends StatelessWidget {
  const PortalResponsiveFields({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        if (compact) {
          return Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i != children.length - 1) const SizedBox(height: 14),
              ],
            ],
          );
        }

        return Wrap(
          spacing: 18,
          runSpacing: 16,
          children: children
              .map(
                (child) => SizedBox(
                  width: (constraints.maxWidth - 18) / 2,
                  child: child,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class PortalTab extends StatelessWidget {
  const PortalTab({
    required this.label,
    required this.active,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active
                  ? CompassColors.certiportTeal
                  : const Color(0xFF9CB4BA),
              width: active ? 4 : 1,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? CompassColors.certiportTeal : CompassColors.text,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class VoucherCard extends StatelessWidget {
  const VoucherCard({
    required this.voucherCode,
    required this.onRemove,
    super.key,
  });

  final String voucherCode;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final code = voucherCode.trim();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 4, color: CompassColors.ic3Green),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE2F1D6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.filter_alt,
                          color: Color(0xFF168B16),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Voucher',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              code,
                              style: const TextStyle(
                                color: CompassColors.mutedText,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: onRemove,
                        style: TextButton.styleFrom(
                          foregroundColor: CompassColors.certiportTeal,
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: const Text('Remove'),
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

class CheckRow extends StatelessWidget {
  const CheckRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CompassColors.border)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: CompassColors.successGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: CompassColors.successGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
