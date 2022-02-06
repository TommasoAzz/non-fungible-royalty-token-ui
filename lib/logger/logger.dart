import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class _ConsoleLogPrinter extends LogPrinter {
  /// Date format
  static final _dateFormatter = DateFormat('dd/MM/yy HH:mm:ss');

  /// Emojis to be printed to graphically show the gravity of the log message.
  static const Map<Level, String> levelEmojis = {
    Level.nothing: '  ',
    Level.verbose: '💬',
    Level.debug: '🐛',
    Level.info: '💡 ',
    Level.warning: '⚠️',
    Level.error: '⛔',
    Level.wtf: '👾',
  };

  /// Label for the log line.
  final String label;

  /// A [label] is required for displaying who the logger is printing for.
  _ConsoleLogPrinter(this.label);

  @override
  List<String> log(final LogEvent event) {
    /// Emoji in the line of text of the log to begin the line (indicative).
    final emoji = levelEmojis[event.level]!;

    final currentDate = DateTime.now();

    return ['$emoji [${_dateFormatter.format(currentDate)} - $label]:\t${event.message}'];
  }
}

Logger getLogger(final String name) {
  return Logger(printer: _ConsoleLogPrinter(name));
}

void setLogLevel(final Level level) {
  Logger.level = level;
}
