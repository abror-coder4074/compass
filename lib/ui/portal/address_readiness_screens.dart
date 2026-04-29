import 'package:flutter/material.dart';

import '../compass_components.dart';
import '../compass_theme.dart';
import 'portal_state.dart';

class MailingAddressScreen extends StatelessWidget {
  const MailingAddressScreen({
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.onContinue,
    required this.onCancel,
    super.key,
  });

  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final VoidCallback onContinue;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Column(
        children: [
          const _AddressWebHeader(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 72, 32, 36),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 960),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Mailing address',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 78),
                              _MailingAddressCard(
                                addressLine1Controller: addressLine1Controller,
                                addressLine2Controller: addressLine2Controller,
                                cityController: cityController,
                                stateController: stateController,
                                postalCodeController: postalCodeController,
                              ),
                              const SizedBox(height: 78),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: onCancel,
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFF35424E),
                                      textStyle: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 22),
                                  SizedBox(
                                    width: 148,
                                    height: 58,
                                    child: ElevatedButton(
                                      onPressed: onContinue,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            CompassColors.certiportTeal,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      child: const Text('Continue'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressWebHeader extends StatelessWidget {
  const _AddressWebHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: const BoxDecoration(
        color: CompassColors.darkNavy,
        border: Border(bottom: BorderSide(color: Color(0xFFBFC4C8), width: 4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            child: Image.asset(
              CompassAssets.certiportLogo,
              width: 246,
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Help',
            onPressed: () {},
            color: Colors.white70,
            icon: const Icon(Icons.help_outline, size: 23),
          ),
          const SizedBox(width: 10),
          IconButton(
            tooltip: 'Language',
            onPressed: () {},
            color: Colors.white70,
            icon: const Icon(Icons.public, size: 24),
          ),
        ],
      ),
    );
  }
}

class _MailingAddressCard extends StatelessWidget {
  const _MailingAddressCard({
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
  });

  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(66, 58, 66, 62),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _AddressField(
                  label: 'Address  *',
                  controller: addressLine1Controller,
                ),
              ),
              const SizedBox(width: 26),
              Expanded(
                child: _AddressField(
                  hintText: 'Apt #, Suite, floor',
                  controller: addressLine2Controller,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _AddressField(label: 'City  *', controller: cityController),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _AddressField(
                  hintText: 'State',
                  controller: stateController,
                ),
              ),
              const SizedBox(width: 26),
              Expanded(
                child: _AddressField(
                  hintText: 'Zip / Postal code',
                  controller: postalCodeController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _CountryField(),
        ],
      ),
    );
  }
}

class _AddressField extends StatelessWidget {
  const _AddressField({required this.controller, this.label, this.hintText});

  final TextEditingController controller;
  final String? label;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          floatingLabelBehavior: label == null
              ? FloatingLabelBehavior.never
              : FloatingLabelBehavior.auto,
          labelStyle: const TextStyle(
            color: Color(0xFF66717B),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          hintStyle: const TextStyle(
            color: Color(0xFF66717B),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF9CA3AA), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF9CA3AA), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: CompassColors.certiportTeal,
              width: 1.8,
            ),
          ),
        ),
      ),
    );
  }
}

class _CountryField extends StatelessWidget {
  const _CountryField();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: DropdownButtonFormField<String>(
        initialValue: 'Uzbekistan',
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF66717B)),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          labelText: 'Country / Region  *',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            color: Color(0xFF66717B),
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF9CA3AA), width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF9CA3AA), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: CompassColors.certiportTeal,
              width: 1.8,
            ),
          ),
        ),
        items: const [
          DropdownMenuItem(value: 'Uzbekistan', child: Text('Uzbekistan')),
          DropdownMenuItem(
            value: 'United States',
            child: Text('United States'),
          ),
          DropdownMenuItem(value: 'Kazakhstan', child: Text('Kazakhstan')),
        ],
        onChanged: (_) {},
      ),
    );
  }
}

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
    required this.voucherController,
    required this.onVoucherChanged,
    required this.onAssignedVoucherChanged,
    required this.onVoucherInputChanged,
  });

  final bool hasVoucher;
  final String assignedVoucher;
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
  const _AssignedVoucherSelect({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = {'Select': 'Select', ...portalAssignedVouchers};
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
