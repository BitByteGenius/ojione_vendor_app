import '../../../core/network/api_response.dart';
import '../models/experience_category_model.dart';
import '../models/experience_model.dart';
import '../models/local_experiences_analytics_model.dart';

abstract class LocalExperiencesDataSource {
  Future<ApiResponse<LocalExperiencesDashboardAnalytics>> getExperiencesAnalytics();
  Future<ApiResponse<List<ExperienceModel>>> getExperiences();
  Future<ApiResponse<List<ExperienceCategoryModel>>> getCategories();
  Future<ApiResponse<bool>> createExperience(Map<String, dynamic> data);
}
