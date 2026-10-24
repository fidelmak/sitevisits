// core/utils/date_formatter.dart
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  // for example  "1 Jan, 01:00"
  static const String visitPattern = 'd MMM, HH:mm';

  static String visitUpdated(DateTime date) =>
      DateFormat(visitPattern).format(date.toLocal());
}