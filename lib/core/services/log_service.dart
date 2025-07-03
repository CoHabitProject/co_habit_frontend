abstract class LogService {
  void debug(dynamic message, {StackTrace? stackTrace});
  void info(dynamic message, {StackTrace? stackTrace});
  void warn(dynamic message, {StackTrace? stackTrace});
  void error(dynamic message, {StackTrace? stackTrace});
}
