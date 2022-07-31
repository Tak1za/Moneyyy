extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  String getWeekday(int weekdayNum, bool getFull) {
    switch (weekdayNum) {
      case 1:
        if (getFull) {
          return "Monday";
        }
        return "Mon";
      case 2:
        if (getFull) {
          return "Tuesday";
        }
        return "Tue";
      case 3:
        if (getFull) {
          return "Wednesday";
        }
        return "Wed";
      case 4:
        if (getFull) {
          return "Thursday";
        }
        return "Thu";
      case 5:
        if (getFull) {
          return "Friday";
        }
        return "Fri";
      case 6:
        if (getFull) {
          return "Saturday";
        }
        return "Sat";
      case 7:
        if (getFull) {
          return "Sunday";
        }
        return "Sun";
      default:
        return "Mon";
    }
  }

  String getMonth(int monthNum, bool getFull) {
    switch (monthNum) {
      case 1:
        if (getFull) {
          return "January";
        }
        return "Jan";
      case 2:
        if (getFull) {
          return "February";
        }
        return "Feb";
      case 3:
        if (getFull) {
          return "March";
        }
        return "Mar";
      case 4:
        if (getFull) {
          return "April";
        }
        return "Apr";
      case 5:
        if (getFull) {
          return "May";
        }
        return "May";
      case 6:
        if (getFull) {
          return "June";
        }
        return "Jun";
      case 7:
        if (getFull) {
          return "July";
        }
        return "Jul";
      case 8:
        if (getFull) {
          return "August";
        }
        return "Aug";
      case 9:
        if (getFull) {
          return "September";
        }
        return "Sep";
      case 10:
        if (getFull) {
          return "October";
        }
        return "Oct";
      case 11:
        if (getFull) {
          return "November";
        }
        return "Nov";
      case 12:
        if (getFull) {
          return "December";
        }
        return "Dec";
      default:
        return "Jan";
    }
  }
}
