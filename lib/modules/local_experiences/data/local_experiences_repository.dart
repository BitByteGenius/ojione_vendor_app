import '../../../core/network/api_response.dart';
import '../models/experience_category_model.dart';
import '../models/experience_model.dart';
import '../models/local_experiences_analytics_model.dart';
import 'local_experiences_data_source.dart';
import 'mock_local_experiences_data_source.dart';

class LocalExperiencesRepository {
  final LocalExperiencesDataSource _dataSource;

  LocalExperiencesRepository({LocalExperiencesDataSource? dataSource})
      : _dataSource = dataSource ?? MockLocalExperiencesDataSource();

  Future<ApiResponse<LocalExperiencesDashboardAnalytics>> getExperiencesAnalytics() {
    return _dataSource.getExperiencesAnalytics();
  }

  Future<ApiResponse<List<ExperienceModel>>> getExperiences() {
    return _dataSource.getExperiences();
  }

  Future<ApiResponse<List<ExperienceCategoryModel>>> getCategories() {
    return _dataSource.getCategories();
  }

  Future<ApiResponse<bool>> createExperience(Map<String, dynamic> data) {
    return _dataSource.createExperience(data);
  }
}
