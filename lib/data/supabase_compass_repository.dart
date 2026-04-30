import 'package:supabase_flutter/supabase_flutter.dart';

import '../ui/exam/exam_models.dart';
import 'compass_models.dart';
import 'compass_repository.dart';

class SupabaseCompassRepository implements CompassRepository {
  SupabaseCompassRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<LoginResult> loginCandidate({
    required String username,
    required String password,
  }) async {
    final payload = await _client.rpc(
      'app_login_candidate',
      params: {'p_username': username, 'p_password': password},
    );
    return LoginResult.fromJson(_asMap(payload));
  }

  @override
  Future<PortalCatalog> loadCatalog() async {
    final payload = await _client.rpc('app_get_catalog');
    return PortalCatalog.fromJson(_asMap(payload));
  }

  @override
  Future<VoucherValidationResult> validateVoucher({
    required String candidateId,
    required String voucherCode,
  }) async {
    final payload = await _client.rpc(
      'app_validate_voucher',
      params: {'p_candidate_id': candidateId, 'p_code': voucherCode},
    );
    return VoucherValidationResult.fromJson(_asMap(payload));
  }

  @override
  Future<ExamStartData> startExamSession({
    required String candidateId,
    required String examId,
    String? voucherCode,
  }) async {
    final payload = await _client.rpc(
      'app_start_exam_session',
      params: {
        'p_candidate_id': candidateId,
        'p_exam_id': examId,
        'p_voucher_code': voucherCode,
      },
    );
    return ExamStartData.fromJson(_asMap(payload));
  }

  @override
  Future<bool> unlockExam({
    required String sessionId,
    required String proctorUsername,
    required String proctorPassword,
  }) async {
    final payload = await _client.rpc(
      'app_unlock_exam',
      params: {
        'p_session_id': sessionId,
        'p_proctor_username': proctorUsername,
        'p_proctor_password': proctorPassword,
      },
    );
    return _asMap(payload)['unlocked'] == true;
  }

  @override
  Future<void> saveAnswer({
    required String sessionId,
    required ExamQuestion question,
  }) async {
    final questionId = question.id;
    if (questionId == null || questionId.isEmpty) {
      return;
    }

    await _client.rpc(
      'app_save_answer',
      params: {
        'p_session_id': sessionId,
        'p_question_id': questionId,
        'p_answer': answerPayloadFromQuestion(question),
        'p_marked_review': question.markedForReview,
        'p_marked_feedback': question.markedForFeedback,
      },
    );
  }

  @override
  Future<ScoreReportData> finishExam({required String sessionId}) async {
    final payload = await _client.rpc(
      'app_finish_exam',
      params: {'p_session_id': sessionId},
    );
    return ScoreReportData.fromJson(_asMap(payload));
  }

  @override
  Future<void> saveFeedback({
    required String sessionId,
    required String feedback,
  }) async {
    await _client.rpc(
      'app_save_feedback',
      params: {'p_session_id': sessionId, 'p_feedback': feedback},
    );
  }

  @override
  Future<CompassCandidate> updateCandidateEmail({
    required String candidateId,
    required String email,
  }) async {
    final payload = await _client.rpc(
      'app_update_candidate_email',
      params: {'p_candidate_id': candidateId, 'p_email': email},
    );
    return CompassCandidate.fromJson(_asMap(payload));
  }

  Map<String, dynamic> _asMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
  }
}
