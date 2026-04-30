import 'admin_models.dart';

abstract class AdminRepository {
  Future<AdminSnapshot> loadSnapshot();

  Future<void> saveRecord({
    required AdminSectionConfig section,
    required String? id,
    required Map<String, dynamic> payload,
  });

  Future<void> saveQuestion(AdminQuestionDraft draft);

  Future<List<String>> deleteBlockersFor({
    required AdminSectionConfig section,
    required String id,
  });

  Future<void> deleteRecord({
    required AdminSectionConfig section,
    required String id,
  });
}
