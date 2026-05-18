import 'package:flutter/material.dart';

import '../compass_components.dart';
import '../compass_theme.dart';
import 'portal_state.dart';

class ReadinessScreen extends StatelessWidget {
  const ReadinessScreen({
    required this.userName,
    required this.hasExamGroup,
    required this.hasVoucher,
    required this.assignedExamGroup,
    required this.assignedVoucher,
    required this.examGroupController,
    required this.voucherController,
    required this.onExamGroupChanged,
    required this.onAssignedExamGroupChanged,
    required this.onExamGroupInputChanged,
    required this.onVoucherChanged,
    required this.onAssignedVoucherChanged,
    required this.onVoucherInputChanged,
    required this.onPrevious,
    required this.onNext,
    this.assignedVoucherOptions = portalAssignedVouchers,
    super.key,
  });

  final String userName;
  final bool hasExamGroup;
  final bool hasVoucher;
  final String assignedExamGroup;
  final String assignedVoucher;
  final TextEditingController examGroupController;
  final TextEditingController voucherController;
  final ValueChanged<bool> onExamGroupChanged;
  final ValueChanged<String?> onAssignedExamGroupChanged;
  final ValueChanged<String> onExamGroupInputChanged;
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
                  Text(
                    'Welcome $userName, let\'s get you ready for your exam!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                        _ExamGroupQuestion(
                          hasExamGroup: hasExamGroup,
                          assignedExamGroup: assignedExamGroup,
                          examGroupController: examGroupController,
                          onExamGroupChanged: onExamGroupChanged,
                          onAssignedExamGroupChanged:
                              onAssignedExamGroupChanged,
                          onExamGroupInputChanged: onExamGroupInputChanged,
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
                          child: _ExamGroupQuestion(
                            hasExamGroup: hasExamGroup,
                            assignedExamGroup: assignedExamGroup,
                            examGroupController: examGroupController,
                            onExamGroupChanged: onExamGroupChanged,
                            onAssignedExamGroupChanged:
                                onAssignedExamGroupChanged,
                            onExamGroupInputChanged: onExamGroupInputChanged,
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
                  SizedBox(height: hasExamGroup || hasVoucher ? 36 : 58),
                  const Divider(height: 1, color: Color(0xFFE1E1E1)),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 68,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: hasVoucher ? onNext : null,
                        style:
                            ElevatedButton.styleFrom(
                              backgroundColor: CompassColors.certiportTeal,
                              disabledBackgroundColor: const Color(0xFFC9C9C9),
                              foregroundColor: Colors.white,
                              disabledForegroundColor: const Color(0xFF777777),
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ).copyWith(
                              side: CompassControlStates.elevatedHoverSide(),
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

class _ExamGroupQuestion extends StatelessWidget {
  const _ExamGroupQuestion({
    required this.hasExamGroup,
    required this.assignedExamGroup,
    required this.examGroupController,
    required this.onExamGroupChanged,
    required this.onAssignedExamGroupChanged,
    required this.onExamGroupInputChanged,
  });

  final bool hasExamGroup;
  final String assignedExamGroup;
  final TextEditingController examGroupController;
  final ValueChanged<bool> onExamGroupChanged;
  final ValueChanged<String?> onAssignedExamGroupChanged;
  final ValueChanged<String> onExamGroupInputChanged;

  @override
  Widget build(BuildContext context) {
    return _ReadinessQuestion(
      title: 'Do you have an Exam Group ID today?',
      example: 'Example Exam Group ID: xxxxx',
      value: hasExamGroup,
      toggleKey: const ValueKey('readiness-group-toggle'),
      onChanged: onExamGroupChanged,
      input: hasExamGroup
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'In order to proceed, you must select an exam group from the list OR enter an\nexam group value',
                  style: TextStyle(fontSize: 14, height: 1.45),
                ),
                const SizedBox(height: 42),
                const Text(
                  'Select Exam Group',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                _ReadinessSelect(
                  fieldKey: const ValueKey('readiness-group-select'),
                  menuKey: const ValueKey('readiness-group-select-menu'),
                  value: assignedExamGroup,
                  options: const {},
                  onChanged: onAssignedExamGroupChanged,
                ),
                const SizedBox(height: 30),
                const Text(
                  'OR',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 38),
                const Text(
                  'Enter exam group',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                _ReadinessInput(
                  inputKey: const ValueKey('readiness-group-input'),
                  controller: examGroupController,
                  onChanged: onExamGroupInputChanged,
                ),
              ],
            )
          : null,
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
                  _ReadinessSelect(
                    fieldKey: const ValueKey('readiness-voucher-select'),
                    menuKey: const ValueKey('readiness-voucher-select-menu'),
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
                _ReadinessInput(
                  inputKey: const ValueKey('readiness-voucher-input'),
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

class _ReadinessSelect extends StatefulWidget {
  const _ReadinessSelect({
    required this.fieldKey,
    required this.menuKey,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final Key fieldKey;
  final Key menuKey;
  final String value;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;

  @override
  State<_ReadinessSelect> createState() => _ReadinessSelectState();
}

class _ReadinessSelectState extends State<_ReadinessSelect> {
  static const _fieldHeight = 42.0;
  static const _menuItemHeight = 34.0;

  final _layerLink = LayerLink();
  final _fieldKey = GlobalKey();
  OverlayEntry? _menuEntry;
  bool _menuOpen = false;

  Map<String, String> get _items => {'Select': 'Select', ...widget.options};

  double get _fieldWidth {
    final context = _fieldKey.currentContext;
    if (context == null) {
      return 0;
    }
    final box = context.findRenderObject() as RenderBox?;
    return box?.size.width ?? 0;
  }

  @override
  void didUpdateWidget(covariant _ReadinessSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_menuOpen) {
      _menuEntry?.markNeedsBuild();
    }
  }

  @override
  void dispose() {
    _hideMenu(updateState: false);
    super.dispose();
  }

  void _toggleMenu() {
    if (_menuOpen) {
      _hideMenu();
      return;
    }
    _showMenu();
  }

  void _showMenu() {
    final overlay = Overlay.of(context);
    _menuEntry = OverlayEntry(builder: _buildMenuOverlay);
    overlay.insert(_menuEntry!);
    setState(() => _menuOpen = true);
  }

  void _hideMenu({bool updateState = true}) {
    _menuEntry?.remove();
    _menuEntry = null;
    if (updateState && mounted && _menuOpen) {
      setState(() => _menuOpen = false);
    } else {
      _menuOpen = false;
    }
  }

  void _selectItem(String value) {
    widget.onChanged(value);
    _hideMenu();
  }

  Widget _buildMenuOverlay(BuildContext context) {
    final width = _fieldWidth;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _hideMenu,
            child: const SizedBox.expand(),
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              key: widget.menuKey,
              width: width,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _items.entries
                      .map(
                        (entry) => _ReadinessSelectItem(
                          label: entry.value,
                          selected: entry.key == widget.value,
                          onTap: () => _selectItem(entry.key),
                        ),
                      )
                      .toList(),
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
    final borderColor = _menuOpen
        ? CompassColors.inputYellow
        : CompassColors.fieldBorder;
    final borderWidth = _menuOpen ? 2.0 : 1.0;

    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        key: _fieldKey,
        height: _fieldHeight,
        child: InkWell(
          key: widget.fieldKey,
          onTap: _toggleMenu,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius: BorderRadius.zero,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                12,
                _menuOpen ? 9 : 10,
                8,
                _menuOpen ? 9 : 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _items[widget.value] ?? widget.value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 14,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Color(0xFF555555),
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

class _ReadinessSelectItem extends StatelessWidget {
  const _ReadinessSelectItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _ReadinessSelectState._menuItemHeight,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF1976D2) : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 14,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadinessInput extends StatelessWidget {
  const _ReadinessInput({
    required this.inputKey,
    required this.controller,
    required this.onChanged,
  });

  final Key inputKey;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: TextFormField(
        key: inputKey,
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
            borderSide: BorderSide(color: CompassColors.fieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: CompassColors.fieldBorder),
          ),
          focusedBorder: const CompassFocusedInputBorder(),
        ),
      ),
    );
  }
}
