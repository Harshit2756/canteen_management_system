import '../../../core/utils/helpers/logger.dart';

/// Base repository with common functionality
///
/// Purpose:
/// - Define common repository methods
/// - Handle data transformation
/// - Provide shared utility methods for repositories
/// - Handle error handling and logging

abstract class BaseRepository {
  // Common validation methods
  bool isValidResponse(Map<String, dynamic>? data) {
    return data != null && data.isNotEmpty;
  }

  // Common data transformation methods
  List<T> transformList<T>(List data, T Function(Map<String, dynamic>) fromJson) {
    HLoggerHelper.info('Transforming $T length ${data.length} and type ${data.runtimeType}');
    try {
      return data.map((item) => fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      HLoggerHelper.error('Error transforming list: $e');
      return [];
    }
  }
}
