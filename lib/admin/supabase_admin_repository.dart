import 'package:supabase_flutter/supabase_flutter.dart';

import 'admin_models.dart';
import 'admin_repository.dart';

class SupabaseAdminRepository implements AdminRepository {
  SupabaseAdminRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<AdminSnapshot> loadSnapshot() async {
    final tableNames = <String>{
      for (final section in allAdminSections) section.table,
      'question_options',
      'question_matrix_rows',
      'question_match_items',
    };

    final tables = <String, List<AdminRecord>>{};
    for (final table in tableNames) {
      final rows = await _client.from(table).select();
      tables[table] = _asRecordList(rows);
    }

    for (final section in allAdminSections) {
      tables[section.table]?.sort((left, right) {
        return _sortValue(left, section).compareTo(_sortValue(right, section));
      });
    }

    _sortByPosition(tables['question_options']);
    _sortByPosition(tables['question_matrix_rows']);
    _sortByPosition(tables['question_match_items']);

    return AdminSnapshot(tables);
  }

  @override
  Future<void> saveRecord({
    required AdminSectionConfig section,
    required String? id,
    required Map<String, dynamic> payload,
  }) async {
    final table = _client.from(section.table);
    if (id == null) {
      await table.insert(payload);
      return;
    }
    await table.update(payload).eq('id', id);
  }

  @override
  Future<void> saveQuestion(AdminQuestionDraft draft) async {
    String questionId;
    if (draft.id == null) {
      final inserted = await _client
          .from('questions')
          .insert(draft.toQuestionPayload())
          .select('id')
          .single();
      questionId = inserted['id'].toString();
    } else {
      questionId = draft.id!;
      await _client
          .from('questions')
          .update(draft.toQuestionPayload())
          .eq('id', questionId);
    }

    await _client
        .from('question_options')
        .delete()
        .eq('question_id', questionId);
    await _client
        .from('question_matrix_rows')
        .delete()
        .eq('question_id', questionId);
    await _client
        .from('question_match_items')
        .delete()
        .eq('question_id', questionId);

    if (_usesOptions(draft.type)) {
      await _insertPositionedRows(
        table: 'question_options',
        questionId: questionId,
        values: draft.options,
      );
    }

    if (draft.type == 'matrix') {
      await _insertPositionedRows(
        table: 'question_matrix_rows',
        questionId: questionId,
        values: draft.matrixRows,
      );
    }

    if (draft.type == 'ordering') {
      await _insertMatchRows(
        questionId: questionId,
        side: 'source',
        values: draft.sourceItems,
      );
    }

    if (draft.type == 'matching') {
      await _insertMatchRows(
        questionId: questionId,
        side: 'source',
        values: draft.sourceItems,
      );
      await _insertMatchRows(
        questionId: questionId,
        side: 'target',
        values: draft.targetItems,
      );
    }
  }

  @override
  Future<List<String>> deleteBlockersFor({
    required AdminSectionConfig section,
    required String id,
  }) async {
    final blockers = <String>[];
    for (final blocker in deleteBlockers[section.table] ?? const []) {
      final rows = await _client
          .from(blocker.table)
          .select('id')
          .eq(blocker.foreignKey, id)
          .limit(1);
      if (_asRecordList(rows).isNotEmpty) {
        blockers.add(blocker.label);
      }
    }
    return blockers;
  }

  @override
  Future<void> deleteRecord({
    required AdminSectionConfig section,
    required String id,
  }) async {
    if (section.table == 'questions') {
      await _client.from('question_options').delete().eq('question_id', id);
      await _client.from('question_matrix_rows').delete().eq('question_id', id);
      await _client.from('question_match_items').delete().eq('question_id', id);
    }
    await _client.from(section.table).delete().eq('id', id);
  }

  Future<void> _insertPositionedRows({
    required String table,
    required String questionId,
    required List<String> values,
  }) async {
    final rows = [
      for (var index = 0; index < values.length; index++)
        {
          'question_id': questionId,
          'position': index + 1,
          'label': values[index],
        },
    ];
    if (rows.isNotEmpty) {
      await _client.from(table).insert(rows);
    }
  }

  Future<void> _insertMatchRows({
    required String questionId,
    required String side,
    required List<String> values,
  }) async {
    final rows = [
      for (var index = 0; index < values.length; index++)
        {
          'question_id': questionId,
          'side': side,
          'position': index + 1,
          'label': values[index],
        },
    ];
    if (rows.isNotEmpty) {
      await _client.from('question_match_items').insert(rows);
    }
  }

  bool _usesOptions(String type) {
    return type == 'singleChoice' ||
        type == 'multipleChoice' ||
        type == 'multiple_choice' ||
        type == 'true_false' ||
        type == 'yes_no' ||
        type == 'boolean' ||
        type == 'matrix';
  }

  List<AdminRecord> _asRecordList(Object? rows) {
    if (rows is List) {
      return [
        for (final row in rows)
          if (row is Map)
            row.map((key, value) => MapEntry(key.toString(), value)),
      ];
    }
    return const [];
  }

  String _sortValue(AdminRecord record, AdminSectionConfig section) {
    final number =
        record['sort_order'] ?? record['position'] ?? record['number'];
    if (number is num) {
      return number.toString().padLeft(8, '0');
    }
    return record[section.displayColumn]?.toString().toLowerCase() ??
        record['created_at']?.toString() ??
        '';
  }

  void _sortByPosition(List<AdminRecord>? rows) {
    rows?.sort((left, right) {
      final leftPosition = left['position'];
      final rightPosition = right['position'];
      if (leftPosition is num && rightPosition is num) {
        return leftPosition.compareTo(rightPosition);
      }
      return 0;
    });
  }
}
