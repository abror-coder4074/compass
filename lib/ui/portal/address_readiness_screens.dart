import 'package:flutter/material.dart';

import '../compass_components.dart';
import '../compass_theme.dart';
import 'portal_state.dart';

class ReadinessScreen extends StatelessWidget {
  const ReadinessScreen({
    required this.hasExamGroup,
    required this.hasVoucher,
    required this.assignedVoucher,
    required this.voucherController,
    required this.onExamGroupChanged,
    required this.onVoucherChanged,
    required this.onAssignedVoucherChanged,
    required this.onVoucherInputChanged,
    required this.onPrevious,
    required this.onNext,
    this.assignedVoucherOptions = portalAssignedVouchers,
    super.key,
  });

  final bool hasExamGroup;
  final bool hasVoucher;
  final String assignedVoucher;
  final TextEditingController voucherController;
  final ValueChanged<bool> onExamGroupChanged;
  final ValueChanged<bool> onVoucherChanged;
  final ValueChanged<String?> onAssignedVoucherChanged;
  final ValueChanged<String> onVoucherInputChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final Map<String, String> assignedVoucherOptions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 900;
        return Padding(
          padding: const EdgeInsets.fromLTRB(42, 14, 42, 30),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome Certiport, let\'s get ready for your exam!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 34,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 34),
                  if (compact)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ReadinessQuestion(
                          title: 'Do you have an Exam Group ID today?',
                          example: 'Example Exam Group ID: xxxxx',
                          value: hasExamGroup,
                          toggleKey: const ValueKey('readiness-group-toggle'),
                          onChanged: onExamGroupChanged,
                        ),
                        const SizedBox(height: 34),
                        _VoucherQuestion(
                          hasVoucher: hasVoucher,
                          assignedVoucher: assignedVoucher,
                          assignedVoucherOptions: assignedVoucherOptions,
                          voucherController: voucherController,
                          onVoucherChanged: onVoucherChanged,
                          onAssignedVoucherChanged: onAssignedVoucherChanged,
                          onVoucherInputChanged: onVoucherInputChanged,
                        ),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _ReadinessQuestion(
                            title: 'Do you have an Exam Group ID today?',
                            example: 'Example Exam Group ID: xxxxx',
                            value: hasExamGroup,
                            toggleKey: const ValueKey('readiness-group-toggle'),
                            onChanged: onExamGroupChanged,
                          ),
                        ),
                        const SizedBox(width: 62),
                        Expanded(
                          child: _VoucherQuestion(
                            hasVoucher: hasVoucher,
                            assignedVoucher: assignedVoucher,
                            assignedVoucherOptions: assignedVoucherOptions,
                            voucherController: voucherController,
                            onVoucherChanged: onVoucherChanged,
                            onAssignedVoucherChanged: onAssignedVoucherChanged,
                            onVoucherInputChanged: onVoucherInputChanged,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: hasVoucher ? 36 : 58),
                  const Divider(height: 1, color: Color(0xFFE1E1E1)),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 68,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CompassColors.certiportTeal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        child: const Text('Next'),
                      ),
                    ),
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

class _VoucherQuestion extends StatelessWidget {
  const _VoucherQuestion({
    required this.hasVoucher,
    required this.assignedVoucher,
    required this.assignedVoucherOptions,
    required this.voucherController,
    required this.onVoucherChanged,
    required this.onAssignedVoucherChanged,
    required this.onVoucherInputChanged,
  });

  final bool hasVoucher;
  final String assignedVoucher;
  final Map<String, String> assignedVoucherOptions;
  final TextEditingController voucherController;
  final ValueChanged<bool> onVoucherChanged;
  final ValueChanged<String?> onAssignedVoucherChanged;
  final ValueChanged<String> onVoucherInputChanged;

  @override
  Widget build(BuildContext context) {
    final voucherValue = voucherController.text.trim();
    return _ReadinessQuestion(
      title: 'Do you have a Voucher to use for payment today?',
      example: 'Example Voucher: xxxx-xxxx-xxxx-xxxx',
      value: hasVoucher,
      toggleKey: const ValueKey('readiness-voucher-toggle'),
      onChanged: onVoucherChanged,
      input: hasVoucher
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'In order to proceed, you must select an assigned voucher OR enter a voucher\nnumber',
                  style: TextStyle(fontSize: 14, height: 1.45),
                ),
                const SizedBox(height: 42),
                if (voucherValue.isEmpty) ...[
                  const Text(
                    'Assigned Vouchers',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  _AssignedVoucherSelect(
                    value: assignedVoucher,
                    options: assignedVoucherOptions,
                    onChanged: onAssignedVoucherChanged,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'OR',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 38),
                ],
                const Text(
                  'Enter a voucher number',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                _VoucherInput(
                  controller: voucherController,
                  onChanged: onVoucherInputChanged,
                ),
              ],
            )
          : null,
    );
  }
}

class _ReadinessQuestion extends StatelessWidget {
  const _ReadinessQuestion({
    required this.title,
    required this.example,
    required this.value,
    required this.toggleKey,
    required this.onChanged,
    this.input,
  });

  final String title;
  final String example;
  final bool value;
  final Key toggleKey;
  final ValueChanged<bool> onChanged;
  final Widget? input;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        const Text(
          'Please make a selection below and then click "Next" to continue.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 14),
        const Text(
          'Your Teacher or Proctor would have given you a special code or series of numbers.',
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 14),
        Text(example, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 24),
        CompassToggle(key: toggleKey, value: value, onChanged: onChanged),
        if (input != null) ...[const SizedBox(height: 58), input!],
      ],
    );
  }
}

class _AssignedVoucherSelect extends StatelessWidget {
  const _AssignedVoucherSelect({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = {'Select': 'Select', ...options};
    return SizedBox(
      height: 42,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, size: 20),
        decoration: const InputDecoration(
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
        ),
        items: items.entries
            .map(
              (entry) => DropdownMenuItem<String>(
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

class _VoucherInput extends StatelessWidget {
  const _VoucherInput({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final hasValue = controller.text.trim().isNotEmpty;
    final borderColor = hasValue
        ? const Color(0xFFF2A900)
        : CompassColors.fieldBorder;

    return SizedBox(
      height: 42,
      child: TextFormField(
        key: const ValueKey('readiness-voucher-input'),
        controller: controller,
        onChanged: (value) => onChanged(value.toUpperCase()),
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: borderColor, width: hasValue ? 2 : 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: borderColor, width: hasValue ? 2 : 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Color(0xFFF2A900), width: 2),
          ),
        ),
      ),
    );
  }
}
