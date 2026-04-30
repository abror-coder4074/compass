import '../ui/exam/exam_models.dart';
import 'compass_models.dart';

abstract class CompassRepository {
  Future<LoginResult> loginCandidate({
    required String username,
    required String password,
  });

  Future<PortalCatalog> loadCatalog();

  Future<VoucherValidationResult> validateVoucher({
    required String candidateId,
    required String voucherCode,
  });

  Future<ExamStartData> startExamSession({
    required String candidateId,
    required String examId,
    String? voucherCode,
  });

  Future<bool> unlockExam({
    required String sessionId,
    required String proctorUsername,
    required String proctorPassword,
  });

  Future<void> saveAnswer({
    required String sessionId,
    required ExamQuestion question,
  });

  Future<ScoreReportData> finishExam({required String sessionId});

  Future<void> saveFeedback({
    required String sessionId,
    required String feedback,
  });

  Future<CompassCandidate> updateCandidateEmail({
    required String candidateId,
    required String email,
  });
}
