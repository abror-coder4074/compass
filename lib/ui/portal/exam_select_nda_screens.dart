import 'package:flutter/material.dart';

import '../compass_components.dart';
import '../compass_theme.dart';
import 'portal_shared.dart';
import 'portal_state.dart';

class ExamSelectScreen extends StatelessWidget {
  const ExamSelectScreen({
    required this.activeTab,
    required this.program,
    required this.searchController,
    required this.voucherCode,
    required this.selectedExam,
    required this.onTabChanged,
    required this.onProgramChanged,
    required this.onSelectExam,
    required this.onRemoveVoucher,
    required this.onPrevious,
    this.programOptions = portalPrograms,
    this.examTitles = const [
      'IC3 GS5 SR - Computing Fundamentals',
      'IC3 GS5 SR - Key Applications',
      'IC3 GS5 SR - Living Online',
    ],
    super.key,
  });

  final String activeTab;
  final String program;
  final TextEditingController searchController;
  final String voucherCode;
  final String selectedExam;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<String?> onProgramChanged;
  final ValueChanged<String> onSelectExam;
  final VoidCallback onRemoveVoucher;
  final VoidCallback onPrevious;
  final Map<String, String> programOptions;
  final List<String> examTitles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(42, 30, 42, 28),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select Your Exam',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: PortalTab(
                      label: 'Search full list',
                      active: activeTab == 'search',
                      onTap: () => onTabChanged('search'),
                    ),
                  ),
                  Expanded(
                    child: PortalTab(
                      label: 'Help me find my exam',
                      active: activeTab == 'help',
                      onTap: () => onTabChanged('help'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _ExamFilters(
                program: program,
                programOptions: programOptions,
                searchController: searchController,
                onProgramChanged: onProgramChanged,
              ),
              if (voucherCode.trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                VoucherCard(
                  voucherCode: voucherCode,
                  onRemove: onRemoveVoucher,
                ),
              ],
              const SizedBox(height: 18),
              _ExamCatalogCard(
                examTitles: examTitles,
                selectedExam: selectedExam,
                onSelectExam: onSelectExam,
              ),
              const SizedBox(height: 22),
              const Divider(height: 1, color: Color(0xFFE1E1E1)),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: _PreviousButton(onPressed: onPrevious),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamFilters extends StatelessWidget {
  const _ExamFilters({
    required this.program,
    required this.programOptions,
    required this.searchController,
    required this.onProgramChanged,
  });

  final String program;
  final Map<String, String> programOptions;
  final TextEditingController searchController;
  final ValueChanged<String?> onProgramChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 680;
        final programField = _ProgramSelect(
          value: programOptions.containsKey(program) ? program : 'All programs',
          options: programOptions,
          onChanged: onProgramChanged,
        );
        final searchField = _SearchExamInput(controller: searchController);

        if (compact) {
          return Column(
            children: [programField, const SizedBox(height: 10), searchField],
          );
        }

        return Row(
          children: [
            SizedBox(width: 250, child: programField),
            const SizedBox(width: 8),
            Expanded(child: searchField),
          ],
        );
      },
    );
  }
}

class _ProgramSelect extends StatelessWidget {
  const _ProgramSelect({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final Map<String, String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down, size: 22),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        items: options.entries
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

class _SearchExamInput extends StatelessWidget {
  const _SearchExamInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Search by exam name',
          prefixIcon: Icon(Icons.search, size: 21),
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}

class _ExamCatalogCard extends StatelessWidget {
  const _ExamCatalogCard({
    required this.examTitles,
    required this.selectedExam,
    required this.onSelectExam,
  });

  final List<String> examTitles;
  final String selectedExam;
  final ValueChanged<String> onSelectExam;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 355),
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Image.asset(
                CompassAssets.ic3Logo,
                width: 54,
                height: 36,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'IC3 Digital Literacy Certification',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Column(
              children: [
                const _ExamTableHeader(),
                for (var i = 0; i < examTitles.length; i++)
                  _ExamCatalogRow(
                    title: examTitles[i],
                    selected: selectedExam == examTitles[i],
                    showDivider: i != examTitles.length - 1,
                    onSelect: () => onSelectExam(examTitles[i]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExamTableHeader extends StatelessWidget {
  const _ExamTableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: const Text(
        'EXAM',
        style: TextStyle(
          color: Color(0xFF525A60),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.8,
        ),
      ),
    );
  }
}

class _ExamCatalogRow extends StatelessWidget {
  const _ExamCatalogRow({
    required this.title,
    required this.selected,
    required this.showDivider,
    required this.onSelect,
  });

  final String title;
  final bool selected;
  final bool showDivider;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 14, right: 36),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFF9FCFD) : Colors.white,
        border: showDivider
            ? const Border(bottom: BorderSide(color: Color(0xFFE0E0E0)))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 36,
            child: CompassPrimaryButton(
              label: 'Select exam',
              onPressed: onSelect,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviousButton extends StatelessWidget {
  const _PreviousButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(58, 38),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        foregroundColor: CompassColors.text,
        side: const BorderSide(color: Color(0xFFBFC6CA)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
      ),
      child: const Text('Previous'),
    );
  }
}

class ExamRow extends StatelessWidget {
  const ExamRow({
    required this.title,
    required this.code,
    required this.details,
    required this.selected,
    required this.onSelect,
    super.key,
  });

  final String title;
  final String code;
  final String details;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: CompassColors.border)),
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.school_outlined,
            color: selected ? CompassColors.certiportTeal : CompassColors.text,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text('$code | $details'),
              ],
            ),
          ),
          const SizedBox(width: 14),
          CompassPrimaryButton(label: 'Select exam', onPressed: onSelect),
        ],
      ),
    );
  }
}
