import 'dart:convert';

import 'package:flutter/material.dart';

import '../ui/compass_theme.dart';
import 'admin_models.dart';
import 'admin_repository.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({required this.repository, super.key});

  final AdminRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compass Admin',
      theme: buildCompassTheme(),
      home: AdminPanelHome(repository: repository),
    );
  }
}

class AdminPanelHome extends StatefulWidget {
  const AdminPanelHome({required this.repository, super.key});

  final AdminRepository repository;

  @override
  State<AdminPanelHome> createState() => _AdminPanelHomeState();
}

class _AdminPanelHomeState extends State<AdminPanelHome> {
  AdminSectionConfig _section = allAdminSections.first;
  AdminSnapshot? _snapshot;
  String? _selectedId;
  bool _creating = false;
  bool _loading = true;
  bool _saving = false;
  String? _error;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({String? keepSelectedId}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final snapshot = await widget.repository.loadSnapshot();
      if (!mounted) {
        return;
      }
      final requestedId = keepSelectedId ?? _selectedId;
      final records = snapshot.records(_section.table);
      final selectedId =
          requestedId != null &&
              records.any((record) => record['id']?.toString() == requestedId)
          ? requestedId
          : records.isEmpty
          ? null
          : records.first['id']?.toString();
      setState(() {
        _snapshot = snapshot;
        _selectedId = selectedId;
        _creating = false;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = _friendlyError(error);
        _loading = false;
      });
    }
  }

  Future<void> _saveRecord(Map<String, dynamic> payload) async {
    await _runSave(() async {
      await widget.repository.saveRecord(
        section: _section,
        id: _creating ? null : _selectedId,
        payload: payload,
      );
    });
  }

  Future<void> _saveQuestion(AdminQuestionDraft draft) async {
    await _runSave(() => widget.repository.saveQuestion(draft));
  }

  Future<void> _runSave(Future<void> Function() action) async {
    setState(() {
      _saving = true;
    });
    try {
      await action();
      if (!mounted) {
        return;
      }
      _showMessage('Saved.');
      await _load();
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage('Could not save: ${_friendlyError(error)}');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _deleteSelected() async {
    final id = _selectedId;
    final record = _selectedRecord;
    if (id == null || record == null) {
      return;
    }

    final blockers = await widget.repository.deleteBlockersFor(
      section: _section,
      id: id,
    );
    if (!mounted) {
      return;
    }
    if (blockers.isNotEmpty) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cannot delete'),
          content: Text(
            'This record is used by ${blockers.join(', ')}. Remove those links first.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete record?'),
        content: Text(
          'Delete "${_recordTitle(record, _section)}" from ${_section.title}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      await widget.repository.deleteRecord(section: _section, id: id);
      if (!mounted) {
        return;
      }
      _showMessage('Deleted.');
      setState(() {
        _selectedId = null;
        _creating = false;
      });
      await _load();
    } catch (error) {
      if (!mounted) {
        return;
      }
      _showMessage('Could not delete: ${_friendlyError(error)}');
    }
  }

  AdminRecord? get _selectedRecord {
    final snapshot = _snapshot;
    final selectedId = _selectedId;
    if (snapshot == null || selectedId == null) {
      return null;
    }
    return snapshot.recordById(_section.table, selectedId);
  }

  List<AdminRecord> get _visibleRecords {
    final snapshot = _snapshot;
    if (snapshot == null) {
      return const [];
    }
    final records = snapshot.records(_section.table);
    final query = _search.trim().toLowerCase();
    if (query.isEmpty) {
      return records;
    }
    return [
      for (final record in records)
        if (_recordTitle(record, _section).toLowerCase().contains(query) ||
            _section.columns.any(
              (column) =>
                  _displayValue(record, column).toLowerCase().contains(query),
            ))
          record,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = _snapshot;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Row(
        children: [
          _AdminSidebar(
            selected: _section,
            onSelected: (section) {
              final records = _snapshot?.records(section.table) ?? const [];
              setState(() {
                _section = section;
                _selectedId = records.isEmpty
                    ? null
                    : records.first['id']?.toString();
                _creating = false;
                _search = '';
              });
            },
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AdminTopBar(
                  section: _section,
                  loading: _loading,
                  onRefresh: _load,
                  onCreate: _section.editable
                      ? () {
                          setState(() {
                            _creating = true;
                            _selectedId = null;
                          });
                        }
                      : null,
                ),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                      ? _ErrorState(message: _error!, onRetry: _load)
                      : snapshot == null
                      ? const SizedBox.shrink()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: _buildTablePane()),
                            _buildDetailPane(snapshot),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTablePane() {
    final records = _visibleRecords;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 10, 18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: CompassColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search records',
                  prefixIcon: Icon(Icons.search, size: 20),
                ),
                onChanged: (value) => setState(() => _search = value),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: records.isEmpty
                  ? const Center(child: Text('No records found.'))
                  : Scrollbar(
                      child: SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              const Color(0xFFEAF1F8),
                            ),
                            showCheckboxColumn: false,
                            columns: [
                              for (final column in _section.columns)
                                DataColumn(label: Text(_columnLabel(column))),
                            ],
                            rows: [
                              for (final record in records)
                                DataRow(
                                  selected:
                                      !_creating &&
                                      _selectedId == record['id']?.toString(),
                                  onSelectChanged: (_) {
                                    setState(() {
                                      _selectedId = record['id']?.toString();
                                      _creating = false;
                                    });
                                  },
                                  cells: [
                                    for (final column in _section.columns)
                                      DataCell(
                                        SizedBox(
                                          width:
                                              column == _section.displayColumn
                                              ? 260
                                              : 170,
                                          child: Text(
                                            _displayValue(record, column),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildDetailPane(AdminSnapshot snapshot) {
    final selectedRecord = _selectedRecord;
    final hasEditor = _creating || selectedRecord != null;

    return Container(
      width: 460,
      margin: const EdgeInsets.fromLTRB(8, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: CompassColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _creating
                        ? 'New ${_section.title}'
                        : selectedRecord == null
                        ? 'Details'
                        : _recordTitle(selectedRecord, _section),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_section.editable && selectedRecord != null)
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: _saving ? null : _deleteSelected,
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: !hasEditor
                ? const Center(child: Text('Select a row to view details.'))
                : _section.editable
                ? _section.questionEditor
                      ? AdminQuestionForm(
                          key: ValueKey(
                            'question-${selectedRecord?['id'] ?? 'new'}',
                          ),
                          snapshot: snapshot,
                          record: selectedRecord,
                          saving: _saving,
                          onSave: _saveQuestion,
                        )
                      : AdminRecordForm(
                          key: ValueKey(
                            '${_section.id}-${selectedRecord?['id'] ?? 'new'}',
                          ),
                          section: _section,
                          snapshot: snapshot,
                          record: selectedRecord,
                          saving: _saving,
                          onSave: _saveRecord,
                        )
                : AdminReadOnlyPanel(
                    section: _section,
                    snapshot: snapshot,
                    record: selectedRecord!,
                  ),
          ),
        ],
      ),
    );
  }

  String _displayValue(AdminRecord record, String column) {
    final value = record[column];
    final relation = _relationForColumn(_section, column);
    final snapshot = _snapshot;
    if (relation != null && snapshot != null) {
      return snapshot.labelFor(
        relation.table,
        value,
        labelKey: relation.labelKey,
      );
    }
    return _formatValue(value);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  const _AdminSidebar({required this.selected, required this.onSelected});

  final AdminSectionConfig selected;
  final ValueChanged<AdminSectionConfig> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      color: CompassColors.darkNavy,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Text(
                'Compass Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  const _SidebarGroupLabel('Manage'),
                  for (final section in editableAdminSections)
                    _SidebarTile(
                      section: section,
                      selected: section.id == selected.id,
                      onTap: () => onSelected(section),
                    ),
                  const _SidebarGroupLabel('History'),
                  for (final section in readOnlyAdminSections)
                    _SidebarTile(
                      section: section,
                      selected: section.id == selected.id,
                      onTap: () => onSelected(section),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarGroupLabel extends StatelessWidget {
  const _SidebarGroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF9DB8C8),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0,
        ),
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.section,
    required this.selected,
    required this.onTap,
  });

  final AdminSectionConfig section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: selected ? const Color(0xFF0A5F82) : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              section.title,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFFEAF1F8),
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminTopBar extends StatelessWidget {
  const _AdminTopBar({
    required this.section,
    required this.loading,
    required this.onRefresh,
    required this.onCreate,
  });

  final AdminSectionConfig section;
  final bool loading;
  final VoidCallback onRefresh;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (section.description.isNotEmpty)
                  Text(
                    section.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CompassColors.mutedText,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: loading ? null : onRefresh,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New'),
          ),
        ],
      ),
    );
  }
}

class AdminRecordForm extends StatefulWidget {
  const AdminRecordForm({
    required this.section,
    required this.snapshot,
    required this.record,
    required this.saving,
    required this.onSave,
    super.key,
  });

  final AdminSectionConfig section;
  final AdminSnapshot snapshot;
  final AdminRecord? record;
  final bool saving;
  final ValueChanged<Map<String, dynamic>> onSave;

  @override
  State<AdminRecordForm> createState() => _AdminRecordFormState();
}

class _AdminRecordFormState extends State<AdminRecordForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, String?> _selectValues;

  @override
  void initState() {
    super.initState();
    _controllers = {};
    _selectValues = {};
    for (final field in widget.section.fields) {
      final initialValue =
          widget.record?[field.key] ?? field.defaultValue ?? '';
      if (field.kind == AdminFieldKind.relation ||
          field.kind == AdminFieldKind.select) {
        _selectValues[field.key] = initialValue?.toString();
      } else {
        _controllers[field.key] = TextEditingController(
          text: initialValue?.toString() ?? '',
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  for (final field in widget.section.fields) ...[
                    _buildField(field),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
          ),
          _FormFooter(saving: widget.saving, onSave: _submit),
        ],
      ),
    );
  }

  Widget _buildField(AdminFieldConfig field) {
    return switch (field.kind) {
      AdminFieldKind.multiline => TextFormField(
        controller: _controllers[field.key],
        minLines: 4,
        maxLines: 8,
        decoration: InputDecoration(labelText: field.label),
        validator: (value) => _validateText(field, value),
      ),
      AdminFieldKind.integer => TextFormField(
        controller: _controllers[field.key],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: field.label),
        validator: (value) => _validateInteger(field, value),
      ),
      AdminFieldKind.relation => _buildRelationField(field),
      AdminFieldKind.select => _buildSelectField(field),
      AdminFieldKind.text => TextFormField(
        controller: _controllers[field.key],
        decoration: InputDecoration(labelText: field.label),
        validator: (value) => _validateText(field, value),
      ),
    };
  }

  Widget _buildRelationField(AdminFieldConfig field) {
    final relationTable = field.relationTable!;
    final records = widget.snapshot.records(relationTable);
    final currentValue = _selectValues[field.key];
    final hasCurrent =
        currentValue != null &&
        currentValue.isNotEmpty &&
        records.any((record) => record['id']?.toString() == currentValue);
    final value = hasCurrent ? currentValue : '';

    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: field.label),
      items: [
        if (field.nullable)
          const DropdownMenuItem<String>(value: '', child: Text('Unassigned')),
        for (final record in records)
          DropdownMenuItem<String>(
            value: record['id']?.toString() ?? '',
            child: Text(
              widget.snapshot.labelFor(
                relationTable,
                record['id'],
                labelKey: field.relationLabelKey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      validator: (value) {
        if (field.required && (value == null || value.isEmpty)) {
          return 'Required';
        }
        return null;
      },
      onChanged: (value) => _selectValues[field.key] = value,
    );
  }

  Widget _buildSelectField(AdminFieldConfig field) {
    final current = _selectValues[field.key];
    final value = field.options.contains(current)
        ? current
        : field.defaultValue?.toString() ?? field.options.first;
    _selectValues[field.key] = value;

    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: field.label),
      items: [
        for (final option in field.options)
          DropdownMenuItem<String>(value: option, child: Text(option)),
      ],
      onChanged: (value) => _selectValues[field.key] = value,
    );
  }

  String? _validateText(AdminFieldConfig field, String? value) {
    if (field.required && (value == null || value.trim().isEmpty)) {
      return 'Required';
    }
    return null;
  }

  String? _validateInteger(AdminFieldConfig field, String? value) {
    if (field.required && (value == null || value.trim().isEmpty)) {
      return 'Required';
    }
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final parsed = int.tryParse(value.trim());
    if (parsed == null) {
      return 'Enter a whole number';
    }
    if (field.key == 'percent_complete' && (parsed < 0 || parsed > 100)) {
      return 'Use 0 to 100';
    }
    if (_requiresPositiveInteger(field.key) && parsed <= 0) {
      return 'Must be greater than 0';
    }
    if (field.key == 'sort_order' && parsed < 0) {
      return 'Must be 0 or greater';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    final payload = <String, dynamic>{};
    for (final field in widget.section.fields) {
      if (field.kind == AdminFieldKind.relation) {
        final value = _selectValues[field.key];
        payload[field.key] = value == null || value.isEmpty ? null : value;
      } else if (field.kind == AdminFieldKind.select) {
        payload[field.key] = _selectValues[field.key] ?? field.defaultValue;
      } else if (field.kind == AdminFieldKind.integer) {
        final value = _controllers[field.key]!.text.trim();
        payload[field.key] = value.isEmpty ? null : int.parse(value);
      } else {
        payload[field.key] = _controllers[field.key]!.text.trim();
      }
    }
    widget.onSave(payload);
  }
}

class AdminQuestionForm extends StatefulWidget {
  const AdminQuestionForm({
    required this.snapshot,
    required this.record,
    required this.saving,
    required this.onSave,
    super.key,
  });

  final AdminSnapshot snapshot;
  final AdminRecord? record;
  final bool saving;
  final ValueChanged<AdminQuestionDraft> onSave;

  @override
  State<AdminQuestionForm> createState() => _AdminQuestionFormState();
}

class _AdminQuestionFormState extends State<AdminQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _numberController;
  late final TextEditingController _promptController;
  late final TextEditingController _detailsController;
  late final TextEditingController _requiredSelectionsController;
  late final TextEditingController _optionsController;
  late final TextEditingController _matrixRowsController;
  late final TextEditingController _sourceItemsController;
  late final TextEditingController _targetItemsController;
  String? _examId;
  String _type = 'singleChoice';

  @override
  void initState() {
    super.initState();
    final record = widget.record;
    final questionId = record?['id']?.toString();
    _examId = record?['exam_id']?.toString();
    _type = record?['type']?.toString() ?? 'singleChoice';
    _numberController = TextEditingController(
      text: record?['number']?.toString() ?? '',
    );
    _promptController = TextEditingController(
      text: record?['prompt']?.toString() ?? '',
    );
    _detailsController = TextEditingController(
      text: _stringList(record?['prompt_details']).join('\n'),
    );
    _requiredSelectionsController = TextEditingController(
      text: record?['required_selections']?.toString() ?? '1',
    );
    _optionsController = TextEditingController(
      text: _childLabels('question_options', questionId).join('\n'),
    );
    _matrixRowsController = TextEditingController(
      text: _childLabels('question_matrix_rows', questionId).join('\n'),
    );
    _sourceItemsController = TextEditingController(
      text: _matchLabels(questionId, 'source').join('\n'),
    );
    _targetItemsController = TextEditingController(
      text: _matchLabels(questionId, 'target').join('\n'),
    );
  }

  @override
  void dispose() {
    _numberController.dispose();
    _promptController.dispose();
    _detailsController.dispose();
    _requiredSelectionsController.dispose();
    _optionsController.dispose();
    _matrixRowsController.dispose();
    _sourceItemsController.dispose();
    _targetItemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exams = widget.snapshot.records('exams');
    final currentExamExists =
        _examId != null &&
        exams.any((record) => record['id']?.toString() == _examId);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: currentExamExists ? _examId : null,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Exam'),
                    items: [
                      for (final exam in exams)
                        DropdownMenuItem<String>(
                          value: exam['id']?.toString(),
                          child: Text(
                            exam['title']?.toString() ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                    onChanged: (value) => _examId = value,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Number'),
                    validator: (value) => _validatePositiveInt(value),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _type,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Question Type',
                    ),
                    items: [
                      for (final type in questionTypes)
                        DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _type = value;
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _promptController,
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(labelText: 'Prompt'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Required'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _detailsController,
                    minLines: 3,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Prompt Details',
                      hintText: 'One line per detail paragraph',
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _requiredSelectionsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Required Selections',
                    ),
                    validator: (value) => _validatePositiveInt(value),
                  ),
                  const SizedBox(height: 18),
                  ..._typeFields(),
                ],
              ),
            ),
          ),
          _FormFooter(saving: widget.saving, onSave: _submit),
        ],
      ),
    );
  }

  List<Widget> _typeFields() {
    final fields = <Widget>[];
    if (_usesAnswerOptions(_type)) {
      fields.add(
        _LineListField(
          controller: _optionsController,
          label: _type == 'matrix' ? 'Matrix Columns' : 'Answer Options',
          hint: 'One option per line',
        ),
      );
    }
    if (_type == 'matrix') {
      fields.add(const SizedBox(height: 14));
      fields.add(
        _LineListField(
          controller: _matrixRowsController,
          label: 'Matrix Rows',
          hint: 'One row per line',
        ),
      );
    }
    if (_type == 'ordering' || _type == 'matching') {
      fields.add(
        _LineListField(
          controller: _sourceItemsController,
          label: _type == 'ordering' ? 'Order Items' : 'Source Items',
          hint: 'One item per line',
        ),
      );
    }
    if (_type == 'matching') {
      fields.add(const SizedBox(height: 14));
      fields.add(
        _LineListField(
          controller: _targetItemsController,
          label: 'Target Items',
          hint: 'One item per line',
        ),
      );
    }
    return fields;
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final options = _lines(_optionsController.text);
    final matrixRows = _lines(_matrixRowsController.text);
    final sourceItems = _lines(_sourceItemsController.text);
    final targetItems = _lines(_targetItemsController.text);
    final typeError = _validateQuestionParts(
      type: _type,
      requiredSelections: int.parse(_requiredSelectionsController.text.trim()),
      options: options,
      matrixRows: matrixRows,
      sourceItems: sourceItems,
      targetItems: targetItems,
    );
    if (typeError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(typeError), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    widget.onSave(
      AdminQuestionDraft(
        id: widget.record?['id']?.toString(),
        examId: _examId!,
        number: int.parse(_numberController.text.trim()),
        prompt: _promptController.text.trim(),
        promptDetails: _lines(_detailsController.text),
        type: _type,
        requiredSelections: int.parse(
          _requiredSelectionsController.text.trim(),
        ),
        options: options,
        matrixRows: matrixRows,
        sourceItems: sourceItems,
        targetItems: targetItems,
      ),
    );
  }

  List<String> _childLabels(String table, String? questionId) {
    if (questionId == null) {
      return const [];
    }
    return [
      for (final row in widget.snapshot.records(table))
        if (row['question_id']?.toString() == questionId)
          row['label']?.toString() ?? '',
    ].where((value) => value.trim().isNotEmpty).toList();
  }

  List<String> _matchLabels(String? questionId, String side) {
    if (questionId == null) {
      return const [];
    }
    return [
      for (final row in widget.snapshot.records('question_match_items'))
        if (row['question_id']?.toString() == questionId && row['side'] == side)
          row['label']?.toString() ?? '',
    ].where((value) => value.trim().isNotEmpty).toList();
  }
}

class _LineListField extends StatelessWidget {
  const _LineListField({
    required this.controller,
    required this.label,
    required this.hint,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      minLines: 4,
      maxLines: 8,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}

class AdminReadOnlyPanel extends StatelessWidget {
  const AdminReadOnlyPanel({
    required this.section,
    required this.snapshot,
    required this.record,
    super.key,
  });

  final AdminSectionConfig section;
  final AdminSnapshot snapshot;
  final AdminRecord record;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          for (final entry in record.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _columnLabel(entry.key),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: CompassColors.mutedText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    _formatValue(entry.value),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _FormFooter extends StatelessWidget {
  const _FormFooter({required this.saving, required this.onSave});

  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: CompassColors.border)),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: saving ? null : onSave,
          icon: saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save_outlined, size: 18),
          label: Text(saving ? 'Saving' : 'Save'),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 42),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

class _RelationInfo {
  const _RelationInfo(this.table, this.labelKey);

  final String table;
  final String labelKey;
}

_RelationInfo? _relationForColumn(AdminSectionConfig section, String column) {
  for (final field in section.fields) {
    if (field.key == column && field.relationTable != null) {
      return _RelationInfo(
        field.relationTable!,
        field.relationLabelKey ?? defaultLabelKeyForTable(field.relationTable!),
      );
    }
  }
  return switch (column) {
    'candidate_id' => const _RelationInfo('candidates', 'display_name'),
    'exam_id' => const _RelationInfo('exams', 'title'),
    'voucher_id' => const _RelationInfo('vouchers', 'code'),
    'question_id' => const _RelationInfo('questions', 'prompt'),
    'session_id' => const _RelationInfo('exam_sessions', 'id'),
    'test_center_id' => const _RelationInfo('test_centers', 'name'),
    'survey_question_id' => const _RelationInfo('survey_questions', 'title'),
    'program_id' => const _RelationInfo('programs', 'name'),
    _ => null,
  };
}

String _recordTitle(AdminRecord record, AdminSectionConfig section) {
  final value = record[section.displayColumn]?.toString();
  if (value != null && value.trim().isNotEmpty) {
    return value.trim();
  }
  return record['id']?.toString() ?? section.title;
}

String _columnLabel(String key) {
  return key
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String _formatValue(Object? value) {
  if (value == null) {
    return '';
  }
  if (value is List || value is Map) {
    return jsonEncode(value);
  }
  final text = value.toString();
  return text.length > 160 ? '${text.substring(0, 160)}...' : text;
}

String _friendlyError(Object error) {
  final text = error.toString();
  if (text.contains('duplicate key') || text.contains('23505')) {
    return 'A record with the same unique value already exists.';
  }
  if (text.contains('violates foreign key') || text.contains('23503')) {
    return 'This record references a missing related record.';
  }
  return text;
}

String? _validatePositiveInt(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required';
  }
  final parsed = int.tryParse(value.trim());
  if (parsed == null) {
    return 'Enter a whole number';
  }
  if (parsed <= 0) {
    return 'Must be greater than 0';
  }
  return null;
}

bool _requiresPositiveInteger(String key) {
  return const {
    'number',
    'position',
    'option_id',
    'duration_minutes',
    'question_count',
    'pass_score',
    'required_selections',
  }.contains(key);
}

String? _validateQuestionParts({
  required String type,
  required int requiredSelections,
  required List<String> options,
  required List<String> matrixRows,
  required List<String> sourceItems,
  required List<String> targetItems,
}) {
  if (_isSingleAnswerOptionType(type) && options.length < 2) {
    return 'Single choice questions need at least 2 answer options.';
  }
  if (_isMultiAnswerOptionType(type)) {
    if (options.length < 2) {
      return 'Multiple choice questions need at least 2 answer options.';
    }
    if (requiredSelections > options.length) {
      return 'Required selections cannot exceed answer options.';
    }
  }
  if (type == 'matrix') {
    if (options.length < 2) {
      return 'Matrix questions need at least 2 columns.';
    }
    if (matrixRows.isEmpty) {
      return 'Matrix questions need at least 1 row.';
    }
  }
  if (type == 'ordering' && sourceItems.length < 2) {
    return 'Ordering questions need at least 2 items.';
  }
  if (type == 'matching') {
    if (sourceItems.isEmpty || targetItems.isEmpty) {
      return 'Matching questions need source and target items.';
    }
    if (sourceItems.length != targetItems.length) {
      return 'Matching source and target item counts must match.';
    }
  }
  return null;
}

bool _usesAnswerOptions(String type) {
  return _isSingleAnswerOptionType(type) ||
      _isMultiAnswerOptionType(type) ||
      type == 'matrix';
}

bool _isSingleAnswerOptionType(String type) {
  return const {
    'singleChoice',
    'multiple_choice',
    'true_false',
    'yes_no',
    'boolean',
  }.contains(type);
}

bool _isMultiAnswerOptionType(String type) {
  return type == 'multipleChoice';
}

List<String> _lines(String value) {
  return value
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
}

List<String> _stringList(Object? value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }
  return const [];
}
