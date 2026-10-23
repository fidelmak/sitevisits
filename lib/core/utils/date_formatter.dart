// core/utils/date_formatter.dart
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  // "1 Jan, 01:00" (matches your screenshot)
  static const String visitPattern = 'd MMM, HH:mm';

  static String visitUpdated(DateTime date) =>
      DateFormat(visitPattern).format(date.toLocal());
}