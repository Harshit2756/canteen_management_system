import 'package:logger/logger.dart';

class HLoggerHelper {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(printEmojis: true),
    level: Level.debug,
  );
  static void debug(String message) =>
      _logger.d(message, stackTrace: StackTrace.current);
  static void error(String message, [dynamic error]) =>
      _logger.e(message, error: error, stackTrace: StackTrace.current);
  static void info(String message) =>
      _logger.i(message, stackTrace: StackTrace.current);
  static void warning(String message) =>
      _logger.w(message, stackTrace: StackTrace.current);
}
