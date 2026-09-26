import 'package:logger/logger.dart';

/// App-wide logger. Single instance so log formatting/filtering is
/// consistent, and so a remote-logging sink can be added in one place later.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(methodCount: 1, errorMethodCount: 5, lineLength: 80, colors: true),
  );

  static void d(String message) => _logger.d(message);
  static void i(String message) => _logger.i(message);
  static void w(String message) => _logger.w(message);
  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
