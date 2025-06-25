import 'package:co_habit_frontend/core/services/log_service.dart';
import 'package:logger/logger.dart';

class LogServiceImpl implements LogService {
  final bool isCI = const bool.fromEnvironment('CI');

  late final Logger _logger;

  LogServiceImpl() {
    _logger = Logger(
      level: isCI ? Level.warning : Level.debug,
      printer: PrettyPrinter(
        methodCount: 0,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
        lineLength: 120,
      ),
    );
  }

  @override
  void debug(dynamic message, {StackTrace? stackTrace}) {
    _logger.d(_formatMessage(message, stackTrace));
  }

  @override
  void info(dynamic message, {StackTrace? stackTrace}) {
    _logger.i(_formatMessage(message, stackTrace));
  }

  @override
  void warn(dynamic message, {StackTrace? stackTrace}) {
    _logger.w(_formatMessage(message, stackTrace));
  }

  @override
  void error(dynamic message, {StackTrace? stackTrace}) {
    _logger.e(_formatMessage(message, stackTrace));
  }

  String _formatMessage(dynamic message, StackTrace? stackTrace) {
    if (stackTrace == null) return message.toString();

    final traceLines = stackTrace.toString().split('\n');

    // Filtrage optionnel pour ne pas inclure des lignes internes inutiles
    final shortTrace = traceLines
        .where((line) =>
            !line.contains('logger') &&
            !line.contains('dart-sdk') &&
            line.trim().isNotEmpty)
        .take(3)
        .join('\n');

    return '$message\nStackTrace:\n$shortTrace';
  }
}
