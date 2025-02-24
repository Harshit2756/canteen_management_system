/// Storage service for managing local data
///
/// Purpose:
/// - Handle local storage
/// - Manage secure storage
/// - Cache data
library;

import 'package:canteen_app/core/utils/helpers/logger.dart';
import 'package:get_storage/get_storage.dart';

import '../base_service.dart';

class StorageService extends BaseService {
  late final GetStorage _box;

  Future<void> clear() async {
    try {
      await _box.erase();
      HLoggerHelper.info('Storage cleared successfully');
    } catch (e) {
      HLoggerHelper.error('Error clearing storage: $e');
    }
  }

  Future<StorageService> init() async {
    try {
      await GetStorage.init();
      _box = GetStorage();
      HLoggerHelper.info('Storage service initialized successfully');
      return this;
    } catch (e) {
      HLoggerHelper.error('Error initializing storage: $e');
      rethrow;
    }
  }

  T? read<T>(String key) {
    try {
      final value = _box.read<T>(key);
      HLoggerHelper.debug('Successfully read value of type <${value.runtimeType}>: $value from key: $key');
      return value;
      // return _decodeValue<T>(value);
    } catch (e, stackTrace) {
      HLoggerHelper.error('Error reading type <$T> from storage at $key, Error: $e \n StackTrace: $stackTrace');
      return null;
    }
  }

  Future<void> remove(String key) async {
    HLoggerHelper.info('Removing from storage at key: $key');
    try {
      await _box.remove(key);
      HLoggerHelper.info('Successfully removed value at key: $key');
    } catch (e) {
      HLoggerHelper.error('Error removing from storage at $key , Error: $e');
    }
  }

  Future<void> write<T>(String key, T value) async {
    HLoggerHelper.info('Writing to storage at key: $key with value: $value');
    try {
      // Convert objects to JSON string if necessary
      // final valueToStore = value is String ? value : _encodeValue(value);
      await _box.write(key, value);
      HLoggerHelper.info('Successfully wrote value of type <${value.runtimeType}> : $value at key: $key');
    } catch (e) {
      HLoggerHelper.error('Error writing type <${value.runtimeType}> to storage at $key : $value , Error: $e');
    }
  }
}
