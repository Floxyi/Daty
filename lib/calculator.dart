class Calculator {
  static String getDayName(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'error';
    }
  }

  static String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'Feburary';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'Spetember';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'error';
    }
  }

  static int calculateAge(DateTime birthday) {
    final DateTime now =
        DateTime(birthday.year, DateTime.now().month, DateTime.now().day - 1);

    if (DateTime.now().month == birthday.month &&
        DateTime.now().day == birthday.day) {
      return DateTime.now().year - birthday.year;
    }

    if (now.isBefore(birthday)) {
      return DateTime.now().year - birthday.year - 1;
    } else {
      return DateTime.now().year - birthday.year;
    }
  }

  static int nextBirthday(DateTime birthday) {
    final DateTime now =
        DateTime(birthday.year, DateTime.now().month, DateTime.now().day);

    if (now.isBefore(birthday)) {
      return DateTime.now().year - birthday.year;
    } else if (DateTime.now().month == birthday.month &&
        DateTime.now().day == birthday.day) {
      return DateTime.now().year - birthday.year;
    } else {
      return DateTime.now().year - birthday.year + 1;
    }
  }

  static int daysTillBirthday(DateTime birthday) {
    final DateTime now = DateTime(
      birthday.year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (now.isBefore(birthday)) {
      final from = DateTime(now.year, now.month, now.day);
      final to = DateTime(now.year, birthday.month, birthday.day);
      return (to.difference(from).inHours / 24).round() == 365
          ? 0
          : (to.difference(from).inHours / 24).round();
    }

    final from = DateTime(now.year, now.month, now.day);
    final to = DateTime(now.year + 1, birthday.month, birthday.day);
    return DateTime.now().month == birthday.month &&
            DateTime.now().day == birthday.day
        ? 0
        : (to.difference(from).inHours / 24).round();
  }

  static int hoursTillBirthday(DateTime birthday) {
    if (birthday.day == DateTime.now().day) return 0;

    int hours = birthday.hour - DateTime.now().hour - 1;
    return hours < 0 ? hours + 24 : hours;
  }

  static int minutesTillBirthday(DateTime birthday) {
    if (birthday.day == DateTime.now().day) return 0;

    int minutes = birthday.minute - DateTime.now().minute - 1;
    return minutes < 0 ? minutes + 60 : minutes;
  }

  static int secondsTillBirthday(DateTime birthday) {
    if (birthday.day == DateTime.now().day) return 0;

    int seconds = birthday.second - DateTime.now().second - 1;
    return seconds < 0 ? seconds + 60 : seconds;
  }
}
