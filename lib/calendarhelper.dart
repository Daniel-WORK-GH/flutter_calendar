class CalendarDayData {
  final int year;
  final int month;
  final int day;

  const CalendarDayData(this.year, this.month, this.day);

  bool equals(CalendarDayData date) {
    return year == date.year && month == date.month && day == date.day;
  }
}

class CalendarHelper {
  static const List<String> days = [
    'Monday',
    'Tuesday',
    'Wednsday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> daysshort = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static int getDaysInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }

    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];

    return daysInMonth[month - 1];
  }

  static List<List<CalendarDayData>> getDayRows(int year, int month) {
    List<List<CalendarDayData>> ret = [];

    int days = getDaysInMonth(year, month);

    DateTime firstday = DateTime(year, month);
    DateTime lastday = DateTime(year, month, days);

    int startoffset = firstday.weekday - 1;
    int endoffset = 7 - lastday.weekday;

    for (var i = 1 - startoffset; i <= days + endoffset; i++) {
      DateTime date = DateTime(year, month, i);

      if (date.weekday % 7 == 1) {
        ret.add([]);
      }

      ret.last.add(CalendarDayData(date.year, date.month, date.day));
    }

    return ret;
  }
}
