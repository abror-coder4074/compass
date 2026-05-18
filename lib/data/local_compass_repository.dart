import '../ui/exam/exam_mock_data.dart';
import '../ui/exam/exam_models.dart';
import 'compass_models.dart';
import 'compass_repository.dart';

class LocalCompassRepository implements CompassRepository {
  LocalCompassRepository();

  static const _testCenter = CompassTestCenter(
    id: 'local-test-center',
    name: 'Edu Action LLC.',
    code: '90087882',
  );

  static const _candidate = CompassCandidate(
    id: 'local-candidate',
    username: 'pochta@gmail.com',
    email: 'alex.morgan@example.com',
    displayName: 'Alex Morgan',
    candidateIdentifier: 'CP-842916',
    score: 700,
    addressLine1: '41 Amir Temur Street',
    addressLine2: 'Office 1205',
    city: 'Tashkent',
    postalCode: '100000',
    country: 'Uzbekistan',
  );

  static const _programs = [
    CompassProgram(id: 'ic3', name: 'IC3 Digital Literacy'),
    CompassProgram(id: 'mos', name: 'Microsoft Office Specialist'),
  ];

  static const _exams = [
    CompassExam(
      id: 'ic3-gs6-l1',
      programId: 'ic3',
      title: 'IC3 Digital Literacy GS6 Level 1',
      shortTitle: 'IC3 GS6 Level 1',
      code: 'IC3-GS6-L1-2026',
      durationMinutes: 50,
      questionCount: 45,
      passScore: 700,
      language: 'English',
    ),
    CompassExam(
      id: 'ic3-gs5-cf',
      programId: 'ic3',
      title: 'IC3 GS5 SR - Computing Fundamentals',
      shortTitle: 'IC3 GS5 Computing Fundamentals',
      code: 'IC3-GS5-CF',
      durationMinutes: 50,
      questionCount: 45,
      passScore: 700,
      language: 'English',
    ),
    CompassExam(
      id: 'ic3-gs5-ka',
      programId: 'ic3',
      title: 'IC3 GS5 SR - Key Applications',
      shortTitle: 'IC3 GS5 Key Applications',
      code: 'IC3-GS5-KA',
      durationMinutes: 50,
      questionCount: 45,
      passScore: 700,
      language: 'English',
    ),
    CompassExam(
      id: 'ic3-gs5-lo',
      programId: 'ic3',
      title: 'IC3 GS5 SR - Living Online',
      shortTitle: 'IC3 GS5 Living Online',
      code: 'IC3-GS5-LO',
      durationMinutes: 50,
      questionCount: 45,
      passScore: 700,
      language: 'English',
    ),
  ];

  static const _vouchers = [
    CompassVoucher(
      id: 'voucher-1',
      code: 'IC3G-2026-DEMO-7821',
      examId: 'ic3-gs6-l1',
      status: 'assigned',
    ),
    CompassVoucher(
      id: 'voucher-2',
      code: 'IC3G-2026-DEMO-9144',
      examId: 'ic3-gs6-l1',
      status: 'assigned',
    ),
    CompassVoucher(
      id: 'voucher-3',
      code: '3075-HZ25-5GVY-3X5P',
      examId: 'ic3-gs6-l1',
      status: 'assigned',
    ),
  ];

  static const _checks = [
    SystemCheckData(label: 'User Admin', status: 'pass'),
    SystemCheckData(label: 'Hardware Requirements', status: 'pass'),
    SystemCheckData(label: 'Printer Driver', status: 'pass'),
    SystemCheckData(label: 'Running Processes', status: 'pass'),
    SystemCheckData(label: 'Exam Up to Date', status: 'pass'),
    SystemCheckData(label: 'VBScript', status: 'pass'),
  ];

  static const _pathways = [
    PathwayData(name: 'IC3 Digital Literacy GS6 Master', percentComplete: 0),
    PathwayData(
      name: 'Future Proof Economies: Workforce Ready',
      percentComplete: 0,
    ),
    PathwayData(name: 'Workforce Ready', percentComplete: 0),
  ];

  @override
  Future<LoginResult> loginCandidate({
    required String username,
    required String password,
  }) async {
    return const LoginResult(
      candidate: _candidate,
      testCenter: _testCenter,
      vouchers: _vouchers,
    );
  }

  @override
  Future<PortalCatalog> loadCatalog() async {
    return const PortalCatalog(
      programs: _programs,
      exams: _exams,
      ndaAgreements: [
        NdaAgreementData(
          examId: 'ic3-gs6-l1',
          version: '2026.1',
          content:
              'The content of Certiport certification examinations is confidential and protected by trade secret law and other applicable law.',
        ),
      ],
      systemChecks: _checks,
      pathways: _pathways,
    );
  }

  @override
  Future<VoucherValidationResult> validateVoucher({
    required String candidateId,
    required String voucherCode,
  }) async {
    final normalized = voucherCode.trim().toUpperCase();
    CompassVoucher? voucher;
    for (final item in _vouchers) {
      if (item.code == normalized) {
        voucher = item;
        break;
      }
    }
    return VoucherValidationResult(
      valid: voucher != null,
      voucher: voucher,
      message: voucher == null ? 'Voucher was not found.' : null,
    );
  }

  @override
  Future<ExamStartData> startExamSession({
    required String candidateId,
    required String examId,
    String? voucherCode,
  }) async {
    return ExamStartData(
      sessionId: 'local-session',
      surveySections: const [
        SurveySectionData(
          position: 1,
          title: 'Digital Literacy Courses',
          description:
              'Select the statement that best describes the courses you have taken that cover Digital Literacy.',
          selectionType: 'single',
          theme: 'navy',
          options: surveyCourseOptions,
        ),
        SurveySectionData(
          position: 2,
          title: 'Preparation Resources',
          description:
              'Select all types of resources you used to prepare for the exam.',
          selectionType: 'multi',
          theme: 'green',
          options: surveyResourceOptions,
        ),
        SurveySectionData(
          position: 3,
          title: 'Digital Literacy Usage',
          description:
              'Select all statements that describe how you use your Digital Literacy skills.',
          selectionType: 'multi',
          theme: 'teal',
          options: surveyUsageOptions,
        ),
      ],
      questions: _localQuestions(),
    );
  }

  @override
  Future<bool> unlockExam({
    required String sessionId,
    required String proctorUsername,
    required String proctorPassword,
  }) async {
    return proctorUsername.trim().isNotEmpty &&
        proctorPassword.trim().isNotEmpty;
  }

  @override
  Future<void> saveAnswer({
    required String sessionId,
    required ExamQuestion question,
  }) async {}

  @override
  Future<ScoreReportData> finishExam({required String sessionId}) async {
    final candidateScore = _candidate.score;
    return ScoreReportData(
      sessionId: 'local-session',
      requiredScore: 700,
      candidateScore: candidateScore,
      outcome: candidateScore >= 700 ? 'Pass' : 'Fail',
      sectionScores: const [
        SectionScoreData(name: 'Technology Basics', score: 72),
        SectionScoreData(name: 'Digital Citizenship', score: 68),
        SectionScoreData(name: 'Information Management', score: 71),
        SectionScoreData(name: 'Content Creation', score: 69),
        SectionScoreData(name: 'Communication', score: 73),
        SectionScoreData(name: 'Collaboration', score: 70),
        SectionScoreData(name: 'Security', score: 71),
      ],
      candidate: _candidate,
      exam: _exams.first,
      testCenter: _testCenter,
      pathways: _pathways,
    );
  }

  @override
  Future<void> saveFeedback({
    required String sessionId,
    required String feedback,
  }) async {}

  @override
  Future<CompassCandidate> updateCandidateEmail({
    required String candidateId,
    required String email,
  }) async {
    return CompassCandidate(
      id: _candidate.id,
      username: _candidate.username,
      email: email,
      displayName: _candidate.displayName,
      candidateIdentifier: _candidate.candidateIdentifier,
      score: _candidate.score,
      addressLine1: _candidate.addressLine1,
      addressLine2: _candidate.addressLine2,
      city: _candidate.city,
      postalCode: _candidate.postalCode,
      country: _candidate.country,
    );
  }

  List<ExamQuestion> _localQuestions() {
    return [
      for (final question in buildMockExamQuestions())
        cloneExamQuestion(question)..id = 'question-${question.number}',
    ];
  }
}
