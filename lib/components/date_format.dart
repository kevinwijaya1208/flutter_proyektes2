import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime dateTime) {
  var locale = 'id_ID';
  initializeDateFormatting(locale);

  final dayName = DateFormat('EEEE', locale).format(dateTime);
  final day = DateFormat('d', locale).format(dateTime);
  final monthName = DateFormat('MMM', locale).format(dateTime);
  final year = DateFormat('yyyy').format(dateTime);
  final hourMinute = DateFormat('HH:mm').format(dateTime);

  return '$dayName, $day $monthName $year $hourMinute';
}

String formatDate2(DateTime dateTime) {
  var locale = 'id_ID';
  initializeDateFormatting(locale); 

  final day = DateFormat('d', locale).format(dateTime);
  final monthName = DateFormat('MMMM', locale).format(dateTime);
  final year = DateFormat('yyyy').format(dateTime);

  return '$day $monthName $year';
}

String formatDateTime(DateTime dateTime) {
  var locale = 'id_ID';
  final timeFormat = DateFormat.Hm(locale);
  return timeFormat.format(dateTime);
}

String agendaDateFormatter(DateTime time) {
  return DateFormat('yyyy-MM-dd', 'id_ID').format(time);
}

String timeDifference(DateTime from, DateTime to) {
  Duration diff = to.difference(from);

  if (diff.inMinutes < 60) {
    return '${diff.inMinutes} minutes ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} hours ago';
  } else if (diff.inDays < 7) {
    return '${diff.inDays} days ago';
  } else if (diff.inDays < 30) {
    int weeks = (diff.inDays / 7).floor();
    return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
  } else if (diff.inDays < 365) {
    int months = (diff.inDays / 30).floor();
    return '$months ${months == 1 ? 'month' : 'months'} ago';
  } else {
    int years = (diff.inDays / 365).floor();
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }
}
