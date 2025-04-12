import 'package:talker/talker.dart';

class LoggerService extends ILoggerService {
  final talker = Talker();
  @override
  void logDebug(String message) {
    talker.debug(message);
  }

  @override
  void logError(String message) {
    talker.error(message);
  }

  @override
  void logInfo(String message) {
    talker.info(message);
  }

  @override
  void logVerbose(String message) {
    talker.verbose(message);
  }

  @override
  void logWarning(String message) {
    talker.warning(message);
  }
}

abstract class ILoggerService {
  void logError(String message);
  void logInfo(String message);
  void logDebug(String message);
  void logWarning(String message);
  void logVerbose(String message);
}
